


//
//  VTencentSocialManager.m
//  VSocialDemo
//
//  Created by 蚩尤 on 16/5/18.
//  Copyright © 2016年 ouer. All rights reserved.
//

#import "VSocialTool.h"
#import "VTencentSocialManager.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>

static VSocialActionType actionType;
static VTencentSocialManager *manager;
static VSocialCompletion loginCompletion;
static VSocialCompletion shareCompletion;
static VSocialCompletion openCompletion;
@interface VTencentSocialManager ()
<QQApiInterfaceDelegate>
{
    TencentOAuth *tencentOAuth;
}
@end
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wprotocol"
@implementation VTencentSocialManager
#pragma clang diagnostic pop

+ (instancetype)manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[VTencentSocialManager alloc] init];
    });
    return manager;
}

- (void)registerWithAppId:(NSString *)appId
{
    tencentOAuth = [[TencentOAuth alloc] initWithAppId:appId andDelegate:(id<TencentSessionDelegate>)[VTencentSocialManager manager]];
}
- (void)qqSocialWithReq:(VSocialActionReq *)req withType:(VSocialActionType)type withCompletion:(VSocialCompletion)completion
{
    actionType = type;
    if (req.action == VSOCIALACTION_LOGIN) {
        [self qqLoginWithReq:req withCompletion:completion];
    } else if (req.action == VSOCIALACTION_SHARE) {
        [self qqShareWithReq:req withType:type withCompletion:completion];
    } else {
        if (completion) {
            completion(nil,VSOCIALACTIONTYPE_WB,VSOCIALACTIONSTATUS_INVAILD,@"微博组件调起错误，操作只有登录和分享两种");
        }
    }
    
}

- (void)handleOpenURL:(NSURL *)url withCompletion:(VSocialCompletion)completion
{
    openCompletion = completion;
    if ([TencentOAuth CanHandleOpenURL:url]) {
         [TencentOAuth HandleOpenURL:url];
    } else {
        [QQApiInterface handleOpenURL:url delegate:(id<QQApiInterfaceDelegate>)[VTencentSocialManager manager]];
    }
}

- (void)qqLoginWithReq:(VSocialActionReq *)req withCompletion:(VSocialCompletion)completion {
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_ADD_SHARE,
                            nil];
    [tencentOAuth authorize:permissions];
    loginCompletion = completion;
}

- (void)qqShareWithReq:(VSocialActionReq *)req withType:(VSocialActionType)type withCompletion:(VSocialCompletion)completion{
    if (![VSocialTool canShareWithReq:req]) {
        if (completion) {
            completion(nil,VSOCIALACTIONTYPE_WB,VSOCIALACTIONSTATUS_INVAILD,@"qq组件调起错误,分享数据有缺失");
        }
        return;
    }
    QQApiNewsObject *newsObject = [QQApiNewsObject objectWithURL:[NSURL URLWithString:req.shareURL] title:req.shareTitle description:req.shareText previewImageURL:[NSURL URLWithString:req.shareImgUrl]];
    SendMessageToQQReq *messge = [SendMessageToQQReq reqWithContent:newsObject];
    if (type == VSOCIALACTIONTYPE_QQ) {
        [QQApiInterface sendReq:messge];
    } else {
        [QQApiInterface SendReqToQZone:messge];
    }
    shareCompletion = completion;

}

#pragma mark -- TencentLoginDelegate

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin {
    if (![VSocialTool isEmpty:[tencentOAuth accessToken]]) {
        NSTimeInterval time = [[tencentOAuth expirationDate] timeIntervalSince1970]*1000;
        NSString *expiresTime = [NSString stringWithFormat:@"%@",@(time)];
        NSString *openId = tencentOAuth.openId;
        NSString *accessToken = tencentOAuth.accessToken;
        NSDictionary *infoDic = @{@"openId":openId,
                                  @"accessToken":accessToken,
                                  @"expiresTime":expiresTime};
        if (loginCompletion) {
            loginCompletion(infoDic,VSOCIALACTIONTYPE_QQ,VSOCIALACTIONSTATUS_SUCCESS,@"qq登录授权成功");
        }
        if (openCompletion) {
            openCompletion(infoDic,VSOCIALACTIONTYPE_QQ,VSOCIALACTIONSTATUS_SUCCESS,@"qq登录授权成功");
        }
    }
}
/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork {
    NSString *msg = @"qq授权登录时网络有问题";
    VSocialActionStatus status = VSOCIALACTIONSTATUS_INVAILD;
    if (loginCompletion) {
        loginCompletion(nil,VSOCIALACTIONTYPE_QQ,status,msg);
    }
    if (openCompletion) {
        openCompletion(nil,VSOCIALACTIONTYPE_QQ,status,msg);
    }
}
- (void)tencentDidNotLogin:(BOOL)cancelled {
    NSString *msg;
    VSocialActionStatus status;
    //取消登录，授权
    if (cancelled) {
        status = VSOCIALACTIONSTATUS_CANCEL;
        msg = @"qq登录授权取消";
    } else {
        status = VSOCIALACTIONSTATUS_FAILURE;
        msg = @"qq登录授权失败";
    }
    if (loginCompletion) {
        loginCompletion(nil,VSOCIALACTIONTYPE_QQ,status,msg);
    }
    if (openCompletion) {
        openCompletion(nil,VSOCIALACTIONTYPE_QQ,status,msg);
    }
}

#pragma mark -- QQApiInterfaceDelegate
- (void)onResp:(QQBaseResp *)resp
{
    NSString *msg;
    VSocialActionStatus status;
    if ([resp isKindOfClass:[SendMessageToQQResp class]]) {
        if (resp.result.integerValue == 0) {
            status = VSOCIALACTIONSTATUS_SUCCESS;
            msg = actionType == VSOCIALACTIONTYPE_QQ?@"qq分享成功":@"空间分享成功";
        } else if (resp.result.integerValue == -4) {
            status = VSOCIALACTIONSTATUS_CANCEL;
            msg = actionType == VSOCIALACTIONTYPE_QQ?@"qq分享取消":@"空间分享取消";
        } else {
            status = VSOCIALACTIONSTATUS_FAILURE;
            msg = actionType == VSOCIALACTIONTYPE_QQ?@"qq分享失败":@"空间分享失败";
        }
        if (shareCompletion) {
            shareCompletion(nil,VSOCIALACTIONTYPE_QQ,status,msg);
        }
        if (openCompletion) {
            openCompletion(nil,VSOCIALACTIONTYPE_QQ,status,msg);
        }
    }
}

- (BOOL)isQQInstalled
{
    return [QQApiInterface isQQInstalled];
}
@end
