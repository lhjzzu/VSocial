//
//  VWeiXinSocialManager.h
//  VSocialDemo
//
//  Created by 蚩尤 on 16/5/18.
//  Copyright © 2016年 ouer. All rights reserved.
//

#import "VSocial.h"
#import <Foundation/Foundation.h>
@interface VWeiXinSocialManager : NSObject
/**
 *  微信管理单例
 */
+ (instancetype)manager;
/**
 *  判断是否安装微信(如果不起作用，可用下面的方法替代)
 *  BOOL isWxInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
 */
- (BOOL)isWXAppInstalled;

/**
 *  注册应用
 *
 */
- (void)registerWithAppId:(NSString *)appId;
/**
 *  调用微信
 *
 *  @param req         操作的model
 *  @param commpletion 操作完成的回调
 */

- (void)wxSocialWithReq:(VSocialActionReq *)req withType:(VSocialActionType)type withCompletion:(VSocialCompletion)completion;

/**
 *  @brief            qq通过URL启动App时传递的数据
 *
 *  @param url        qq启动第三方应用时传递过来的URL
 *  @param completion 操作完成的回调
 */
- (void)handleOpenURL:(NSURL *)url withCompletion:(VSocialCompletion)completion;
@end
