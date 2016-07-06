//
//  VTencentSocialManager.h
//  VSocialDemo
//
//  Created by 蚩尤 on 16/5/18.
//  Copyright © 2016年 ouer. All rights reserved.
//

#import "VSocial.h"
#import <Foundation/Foundation.h>
@interface VTencentSocialManager : NSObject
/**
 *  qq管理单例
 */
+ (instancetype)manager;
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

- (void)qqSocialWithReq:(VSocialActionReq *)req withType:(VSocialActionType)type withCompletion:(VSocialCompletion)completion;

/**
 *  @brief            qq通过URL启动App时传递的数据
 *
 *  @param url        qq启动第三方应用时传递过来的URL
 *  @param completion 操作完成的回调
 */
- (void)handleOpenURL:(NSURL *)url withCompletion:(VSocialCompletion)completion;
/**
 *  判断是否安装qq(如果不起作用，可用下面的方法替代)
 *  BOOL isWxInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
 *
 */
- (BOOL)isQQInstalled;
@end
