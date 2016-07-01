//
//  VWeiBoSocailManager.m
//  VSocialDemo
//
//  Created by 蚩尤 on 16/5/18.
//  Copyright © 2016年 ouer. All rights reserved.
//

#import "WeiboSDK.h"
#import "VSocialTool.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "VWeiBoSocailManager.h"
static VSocialCompletion loginCompletion;
static VSocialCompletion shareCompletion;
static VSocialCompletion openCompletion;


static VWeiBoSocailManager *manager;

@interface VWeiBoSocailManager ()
<WeiboSDKDelegate>

@end
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wprotocol"
@implementation VWeiBoSocailManager
#pragma clang diagnostic pop

+ (instancetype)manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[VWeiBoSocailManager alloc] init];
    });
    return manager;
}
- (void)registerWithAppId:(NSString *)appId
{
    [WeiboSDK registerApp:appId];
}
- (void)wbSocialWithReq:(VSocialActionReq *)req withCompletion:(VSocialCompletion)completion
{
    if (req.action == VSOCIALACTION_LOGIN) {
       [self weiboLoginWithRedirectURI:req.redirectURI withComletion:completion];
    } else if (req.action == VSOCIALACTION_SHARE) {
        [self weiboShareWithReq:req withCompletion:completion];
    } else {
        if (completion) {
            completion(nil,VSOCIALACTIONTYPE_WB,VSOCIALACTIONSTATUS_INVAILD,@"微博组件调起错误，操作只有登录和分享两种");
        }
    }
    
}

- (void)handleOpenURL:(NSURL *)url withCompeltion:(VSocialCompletion)compeltion
{
    openCompletion = compeltion;
    [WeiboSDK handleOpenURL:url delegate:[VWeiBoSocailManager manager]];
}
/**
 *  微博发起登录操作
 */
- (BOOL)weiboLoginWithRedirectURI:(NSString *)redirectURI withComletion:(VSocialCompletion)completion
{
    if ([VSocialTool isEmpty:redirectURI]) {
        if (completion) {
            completion(nil,VSOCIALACTIONTYPE_WB,VSOCIALACTIONSTATUS_INVAILD,
                       @"微博组件调起错误,微博授权登录缺少redirectURI(授权回调页路径)");
        }
        return NO;
    } else {
        WBAuthorizeRequest *weiboAuthReq = [WBAuthorizeRequest request];
        weiboAuthReq.scope = @"all";
        weiboAuthReq.redirectURI = redirectURI;
        [WeiboSDK sendRequest:weiboAuthReq];
        loginCompletion = completion;
        return YES;
    }
}
/**
 *  微博发起分享操作
 */
- (BOOL)weiboShareWithReq:(VSocialActionReq *)req withCompletion:(VSocialCompletion)completion
{
    
    if (![VSocialTool canShareWithReq:req]) {
        if (completion) {
            completion(nil,VSOCIALACTIONTYPE_WB,VSOCIALACTIONSTATUS_INVAILD,@"微博组件调起错误,分享数据有缺失");
        }
        return NO;
    }
    __block VSocialActionReq *b_req = req;
    void (^reqImgDownCompletion)(UIImage *image) = ^(UIImage *image) {
        WBImageObject *imageObject = [WBImageObject object];
        imageObject.imageData = UIImagePNGRepresentation(image);
        //多媒体model和图片model只能用一个
        WBMessageObject *message = [WBMessageObject message];
        message.imageObject = imageObject;
        message.text = [NSString stringWithFormat:@"%@%@( %@ )",b_req.shareTitle,b_req.shareText,b_req.shareURL];
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
        [WeiboSDK sendRequest:request];
        shareCompletion = completion;
    };

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
     [req performSelector:@selector(shareImageWithCompletion:) withObject:reqImgDownCompletion];
#pragma clang diagnostic pop

    return YES;
}

/**
 *  收到来自微博的响应
 *
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    NSString *msg;
    NSDictionary *infoDic;
    VSocialActionStatus status = VSOCIALACTIONSTATUS_SUCCESS;
    
    if ([response isKindOfClass:[WBAuthorizeResponse class]]) {
        
        if (response.statusCode == 0) { //授权成功
            WBAuthorizeResponse *authorizeResp = (WBAuthorizeResponse *)response;
            NSString *accessToken = authorizeResp.accessToken;
            NSString *uid = authorizeResp.userID;
            NSDate *expirationDate = authorizeResp.expirationDate;
            NSString *expiresTime = [NSString stringWithFormat:@"%.f",[expirationDate timeIntervalSince1970]*1000];

            infoDic = @{@"accessToken":accessToken?:@"",
                        @"uid":uid?:@"",
                        @"expiresTime":expiresTime?:@""};
            status = VSOCIALACTIONSTATUS_SUCCESS;
            msg = @"微博登录授权成功";
        } else if (response.statusCode == -1) { //取消授权
            status = VSOCIALACTIONSTATUS_CANCEL;
            msg = @"微博登录授权取消";
        } else {// 授权失败
            status = VSOCIALACTIONSTATUS_FAILURE;
            msg = @"微博登录授权失败";
        }
        if (loginCompletion) {
            loginCompletion(infoDic,VSOCIALACTIONTYPE_WB,status,msg);
        }
        if (openCompletion) {
            openCompletion(infoDic,VSOCIALACTIONTYPE_WB,status,msg);
        }
        
    } else if ([response isKindOfClass:[WBSendMessageToWeiboResponse class]]) {
    
        if (response.statusCode == 0) {
            status = VSOCIALACTIONSTATUS_SUCCESS;
            msg = @"微博分享成功";
        } else if (response.statusCode == -1) {
            status = VSOCIALACTIONSTATUS_CANCEL;
            msg = @"微博分享取消";
        } else {
            status = VSOCIALACTIONSTATUS_FAILURE;
            msg = @"微博分享失败";
        }
        if (shareCompletion) {
            shareCompletion(infoDic,VSOCIALACTIONTYPE_WB,status,msg);
        }
        if (openCompletion) {
            openCompletion(infoDic,VSOCIALACTIONTYPE_WB,status,msg);
        }
    }
}



- (BOOL)isWeiboAppInstalled
{
    return [WeiboSDK isWeiboAppInstalled];
}
@end
