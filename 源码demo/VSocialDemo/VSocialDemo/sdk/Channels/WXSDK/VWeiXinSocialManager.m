

//
//  VWeiXinSocialManager.m
//  VSocialDemo
//
//  Created by 蚩尤 on 16/5/18.
//  Copyright © 2016年 ouer. All rights reserved.
//
#import "WXApi.h"
#import "WXApiObject.h"
#import "VSocialTool.h"
#import "VWeiXinSocialManager.h"
static VSocialActionReq *actionReq;
static VSocialActionType actionType;
static VWeiXinSocialManager *manager;
static VSocialCompletion loginCompletion;
static VSocialCompletion shareCompletion;
static VSocialCompletion openCompletion;
@interface VWeiXinSocialManager ()
<WXApiDelegate>
@property (nonatomic, strong) NSString *appId;

@end
@implementation VWeiXinSocialManager

+ (instancetype)manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[VWeiXinSocialManager alloc] init];
    });
    return manager;
}

-(void)registerWithAppId:(NSString *)appId
{
    [WXApi registerApp:appId];
    self.appId = appId;
}

- (void)wxSocialWithReq:(VSocialActionReq *)req withType:(VSocialActionType)type withCompletion:(VSocialCompletion)completion{
    actionReq = req;
    actionType = type;
    if (req.action ==  VSOCIALACTION_LOGIN) {
        [self wxLoginWithReq:req withCompletion:completion];
    } else if (req.action == VSOCIALACTION_SHARE) {
        [self wxShareWithReq:req withType:type withCompletion:completion];
    } else {
        if (completion) {
            completion(nil,VSOCIALACTIONTYPE_WB,
                       VSOCIALACTIONSTATUS_INVAILD,
                       @"微博组件调起错误，操作只有登录和分享两种");
        }
    }
}

- (void)handleOpenURL:(NSURL *)url withCompletion:(VSocialCompletion)completion
{
    openCompletion = completion;
    [WXApi handleOpenURL:url delegate:self];
}

/**
 *  微信授权登录
 */
- (void)wxLoginWithReq:(VSocialActionReq *)req withCompletion:(VSocialCompletion)completion {
    if ([VSocialTool isEmpty:req.appSecret]) {
        if (completion) {
            completion(nil,VSOCIALACTIONTYPE_WX,VSOCIALACTIONSTATUS_INVAILD,@"微信调起错误,需要传入在微信平台生成的appSecret");
        }
        return;
    }
    SendAuthReq*authReq = [[SendAuthReq alloc] init];
    authReq.scope = @"snsapi_userinfo";
    authReq.state = @"wxLogin";
    [WXApi sendReq:authReq];
    loginCompletion = completion;
}

- (void)wxShareWithReq:(VSocialActionReq *)req withType:(VSocialActionType)type withCompletion:(VSocialCompletion)completion{    
    if (![VSocialTool canShareWithReq:req]) {
        if (completion) {
            completion(nil,VSOCIALACTIONTYPE_WB,VSOCIALACTIONSTATUS_INVAILD,@"微信组件调起错误,分享数据有缺失");
        }
        return;
    }
    __block VSocialActionReq *b_req = req;
    __weak typeof(self) wSelf = self;
    void (^reqImgDownCompletion)(UIImage *image) = ^(UIImage *image) {
        WXMediaMessage *mediaMessge = [WXMediaMessage message];
        mediaMessge.title = b_req.shareTitle;
        mediaMessge.description = b_req.shareText;
        WXWebpageObject *webpageObject = [WXWebpageObject object];
        webpageObject.webpageUrl = b_req.shareURL;
        mediaMessge.mediaObject = webpageObject;
        [mediaMessge setThumbImage:[wSelf scaleDown:image withSize:CGSizeMake(50, 50)]];
        SendMessageToWXReq *message = [[SendMessageToWXReq alloc] init];
        message.bText = NO;
        message.message = mediaMessge;
        if (type == VSOCIALACTIONTYPE_WX) {
            message.scene = WXSceneSession;
        } else {
            message.scene = WXSceneTimeline;
        }
        [WXApi sendReq:message];
        shareCompletion = completion;
    };
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [req performSelector:@selector(shareImageWithCompletion:) withObject:reqImgDownCompletion];
#pragma clang diagnostic pop
}

- (UIImage*)scaleDown:(UIImage*)image withSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, YES, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

#pragma mark --  WXApiDelegate
- (void)onResp:(BaseResp *)resp
{
  __block NSString *msg;
  __block NSDictionary *infoDic;
  __block VSocialActionStatus status = VSOCIALACTIONSTATUS_SUCCESS;
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *authResp = (SendAuthResp *)resp;
        if (authResp.errCode == WXSuccess) {//成功
            NSString *url = @"https://api.weixin.qq.com/sns/oauth2/access_token";
            if (![VSocialTool isEmpty:authResp.code]) {
                NSString *tokenURL = [NSString stringWithFormat:@"%@?appid=%@&secret=%@&code=%@&grant_type=%@",url,self.appId,actionReq.appSecret,authResp.code,@"authorization_code"];

                void(^completion)(id responseObject,BOOL success, NSError *error) = ^(id responseObject,BOOL success, NSError *error) {
                    
                    if (success) {
                        NSString *openId = [responseObject objectForKey:@"openid"];
                        NSString *accessToken = [responseObject objectForKey:@"access_token"];
                        NSString *refreshToken = [responseObject objectForKey:@"refresh_token"];
                        NSTimeInterval expiresTime = [[responseObject objectForKey:@"expires_in"] floatValue]*1000;
                        infoDic = @{@"openId":openId,
                                    @"accessToken":accessToken,
                                    @"refreshToken":refreshToken,
                                    @"expiresTime":[NSString stringWithFormat:@"%@",@(expiresTime)]};
                        msg = @"微信授权登录成功";
                        status = VSOCIALACTIONSTATUS_SUCCESS;
                        if (loginCompletion) {
                            loginCompletion(infoDic,VSOCIALACTIONTYPE_WX,status,msg);
                        }
                        if (openCompletion) {
                            openCompletion(infoDic,VSOCIALACTIONTYPE_WX,status,msg);
                        }
                    } else {
                        msg = @"调用错误，微信登录，网络请求出错有问题请检查网络";
                        status = VSOCIALACTIONSTATUS_INVAILD;
                        if (loginCompletion) {
                            loginCompletion(infoDic,VSOCIALACTIONTYPE_WX,status,msg);
                        }
                        if (openCompletion) {
                            openCompletion(infoDic,VSOCIALACTIONTYPE_WX,status,msg);
                        }
                    }
                };
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                [actionReq performSelector:@selector(fetchWithPath:withCompletion:) withObject:tokenURL withObject:completion];
#pragma clang diagnostic pop
            }
        } else if (authResp.errCode == WXErrCodeUserCancel) {//取消
            msg = @"微信授权登录取消";
            status = VSOCIALACTIONSTATUS_CANCEL;
            if (loginCompletion) {
                loginCompletion(infoDic,VSOCIALACTIONTYPE_WX,status,msg);
            }
            if (openCompletion) {
                openCompletion(infoDic,VSOCIALACTIONTYPE_WX,status,msg);
            }
        } else { //失败
            msg = @"微信授权登录失败";
            status = VSOCIALACTIONSTATUS_FAILURE;
            if (loginCompletion) {
                loginCompletion(infoDic,VSOCIALACTIONTYPE_WX,status,msg);
            }
            if (openCompletion) {
                openCompletion(infoDic,VSOCIALACTIONTYPE_WX,status,msg);
            }
        }
        
    } else if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (resp.errCode == WXSuccess) {
            msg = actionType == VSOCIALACTIONTYPE_WX?@"微信分享成功":@"朋友圈分享成功";
            status = VSOCIALACTIONSTATUS_SUCCESS;
        } else if (resp.errCode == WXErrCodeUserCancel){
            msg = actionType == VSOCIALACTIONTYPE_WX?@"微信分享取消":@"朋友圈分享取消";
            status = VSOCIALACTIONSTATUS_CANCEL;
        } else {
            msg = actionType == VSOCIALACTIONTYPE_WX?@"微信分享失败":@"朋友圈分享失败";
            status = VSOCIALACTIONSTATUS_FAILURE;
        }
        if (shareCompletion) {
            shareCompletion(infoDic,actionType,status,msg);
        }
        if (openCompletion) {
            openCompletion(infoDic,actionType,status,msg);
        }
    }
    
}

- (BOOL)isWXAppInstalled
{
    return [WXApi isWXAppInstalled];
}

@end
