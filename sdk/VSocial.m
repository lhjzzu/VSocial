
//
//  VSocial.m
//  VSocialDemo
//
//  Created by 蚩尤 on 16/5/17.
//  Copyright © 2016年 ouer. All rights reserved.
//

#import "VSocial.h"
#import "VSocialTool.h"
#import <UIKit/UIKit.h>
#import "VWeiBoSocailManager.h"
#import "VWeiXinSocialManager.h"
#import "VTencentSocialManager.h"
#import <VNetworkManager/VNetworkManager.h>
#pragma mark -- VSocialActionReq

typedef void (^ImageDownCompletion)(UIImage *image);
@interface VSocialActionReq ()
{
    UIImage *img;
    ImageDownCompletion downCompletion;
}
@end

@implementation VSocialActionReq

@synthesize shareImgUrl = _shareImgUrl;

- (void)setShareImgUrl:(NSString *)shareImgUrl
{
    _shareImgUrl = shareImgUrl;
    __weak typeof(self) wSelf = self;
    
    [[VNetworkManager manager] v_networkDownImageWithURL:shareImgUrl withCompletion:^(UIImage *image, NSError *error, NSURL *imageURL) {
        if (!wSelf) {
            return ;
        }
        if (image) {
            __strong typeof(wSelf) sSelf = wSelf;
            sSelf->img = image;
            if (sSelf->downCompletion) {
                sSelf->downCompletion(image);
            }
        }
    }];
}
//先下载，如果调用时，图片已经下载完，那么直接回调。如果图片没有下载完，那么在图片下载完成的时候回调。
- (void)shareImageWithCompletion:(ImageDownCompletion)completion
{
    downCompletion = completion;
    if (img) {
        downCompletion(img);
    }
}

- (void)fetchWithPath:(NSString *)path withCompletion:(void(^)(id responseObjec, BOOL success, NSError *error))completion{
    [[VNetworkManager manager] v_networkWithPath:path withMethod:@"GET" withParamDic:nil withCompletion:^(id responseObjec, BOOL success, NSError *error) {
        completion(responseObjec,success,error);
    }];
}
@end


static VSocial *manager;
static Class wxClass;
static Class wbClass;
static Class qqClass;
static Class socialClass;

static NSString *wbScheme;
static NSString *wxScheme;
static NSString *qqScheme;
@implementation VSocial

+ (instancetype)manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[VSocial alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        wxClass = NSClassFromString(@"VWeiXinSocialManager");
        wbClass = NSClassFromString(@"VWeiBoSocailManager");
        qqClass = NSClassFromString(@"VTencentSocialManager");
    }
    return self;
}
- (void)socialWithReq:(VSocialActionReq *)req withType:(VSocialActionType)type withCompletion:(VSocialCompletion)completion
{
   
    if (type == VSOCIALACTIONTYPE_WB) {
        //检测是否支持微博
        socialClass = NSClassFromString(@"VWeiBoSocailManager");
        if (![socialClass instanceMethodForSelector:@selector(wbSocialWithReq:withCompletion:)]) {
            if (completion) {
                completion(nil,VSOCIALACTIONTYPE_WB,VSOCIALACTIONSTATUS_INVAILD,@"社会化组件调起错误，没有微博这个渠道");
            }
            return;
        }
        if ([VSocialTool isEmpty:wbScheme]) {
            if (completion) {
                completion(nil,VSOCIALACTIONTYPE_WB,VSOCIALACTIONSTATUS_INVAILD,@"社会化组件调起错误，请在info.plist的URL Types中设置微博的scheme");
            }
            return;
        }
        [[socialClass manager] wbSocialWithReq:req withCompletion:completion];
    } else if (type == VSOCIALACTIONTYPE_WX || type == VSOCIALACTIONTYPE_FRIEND) {
        //检测是否支持微信
        socialClass = NSClassFromString(@"VWeiXinSocialManager");
        if (![socialClass instanceMethodForSelector:@selector(wxSocialWithReq:withType:withCompletion:)]) {
            if (completion) {
                completion(nil,VSOCIALACTIONTYPE_WB,VSOCIALACTIONSTATUS_INVAILD,@"社会化组件调起错误，没有微信这个渠道");
            }
            return;
        }
        if ([VSocialTool isEmpty:wxScheme]) {
            if (completion) {
                completion(nil,VSOCIALACTIONTYPE_WB,VSOCIALACTIONSTATUS_INVAILD,@"社会化组件调起错误，请在info.plist的URL Types中设置微信的scheme");
            }
            return;
        }
        //调用
        [[socialClass manager] wxSocialWithReq:req withType:type withCompletion:completion];
    } else if (type == VSOCIALACTIONTYPE_QQ || type == VSOCIALACTIONTYPE_ZONE) {
        //检测是否支持qq
        socialClass = NSClassFromString(@"VTencentSocialManager");
        if (![socialClass instanceMethodForSelector:@selector(qqSocialWithReq:withType:withCompletion:)]) {
            if (completion) {
                completion(nil,VSOCIALACTIONTYPE_WB,VSOCIALACTIONSTATUS_INVAILD,@"社会化组件调起错误，请在info.plist的URL Types中设置qq的scheme");
            }
            return;
        }
        if ([VSocialTool isEmpty:qqScheme]) {
            if (completion) {
                completion(nil,VSOCIALACTIONTYPE_WB,VSOCIALACTIONSTATUS_INVAILD,@"社会化组件调起错误，请在info.plist的URL Types中设置qq的scheme");
            }
            return;
        }
        //调用
        [[socialClass manager] qqSocialWithReq:req withType:type withCompletion:completion];
    } else if (type == VSOCIALACTIONTYPE_COPY) {
        if (![VSocialTool isEmpty:req.shareURL]) {
            NSURL *url = [NSURL URLWithString:req.shareURL];
            UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
            pasteBoard.URL = url;
            if (completion) {
                completion(nil,VSOCIALACTIONTYPE_COPY,VSOCIALACTIONSTATUS_SUCCESS,@"已经将链接复制到剪切板中");
            }
        } else {
            if (completion) {
                completion(nil,VSOCIALACTIONTYPE_COPY,VSOCIALACTIONSTATUS_INVAILD,@"社会化组件调起错误，复制的链接不能为空");
            }
        }
    } else {
        if (completion) {
            completion(nil,VSOCIALACTIONTYPE_UNKNOW,VSOCIALACTIONSTATUS_INVAILD,@"社会化组件调起错误，传入未知类型");
        }
    }
}


- (void)handleOpenURL:(NSURL *)url withCompletion:(VSocialCompletion)completion
{
    if ([url.scheme isEqualToString:wbScheme]) {
        [[socialClass manager] handleOpenURL:url withCompletion:completion];
    } else if ([url.scheme isEqualToString:wxScheme]) {
        [[socialClass manager] handleOpenURL:url withCompletion:completion];
    } else if ([url.scheme isEqualToString:qqScheme]) {
        [[socialClass manager] handleOpenURL:url withCompletion:completion];
    }
}

- (void)registerSocailApp
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSArray *schemeArr = [infoDic objectForKey:@"CFBundleURLTypes"];
    for (NSDictionary *dic in schemeArr) {
        NSString *scheme = [[dic objectForKey:@"CFBundleURLSchemes"] objectAtIndex:0];;
        if ([scheme hasPrefix:@"wx"]) {
            wxScheme = scheme;
        } else if ([scheme hasPrefix:@"wb"]) {
            wbScheme = scheme;
        } else if ([scheme hasPrefix:@"tencent"]) {
            qqScheme = scheme;
        }
    }
    if (![VSocialTool isEmpty:wxScheme]) {
        if ([wxClass instanceMethodForSelector:@selector(registerWithAppId:)]) {
            [[wxClass manager] registerWithAppId:wxScheme];
        }
    }
    if (![VSocialTool isEmpty:wbScheme]) {
        NSString *appId = [wbScheme substringFromIndex:2];
        if ([wbClass instanceMethodForSelector:@selector(registerWithAppId:)]) {
            [[wbClass manager] registerWithAppId:appId];
        }
    }
    if (![VSocialTool isEmpty:qqScheme]) {
        NSString *appId = [qqScheme substringFromIndex:7];
        if ([qqClass instanceMethodForSelector:@selector(registerWithAppId:)]) {
            [[qqClass manager] registerWithAppId:appId];
        }
    }
    
}


@end
