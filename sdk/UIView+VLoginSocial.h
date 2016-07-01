//
//  UIView+VLoginSocial.h
//  VSocialDemo
//
//  Created by 蚩尤 on 16/5/19.
//  Copyright © 2016年 ouer. All rights reserved.
//

#import "VSocial.h"
#import <UIKit/UIKit.h>
@interface UIView (VLoginSocial)
/**
 * v_wbReq.redirectURI = @"http://www.davebella.net.cn";
 */
@property (nonatomic,strong) VSocialActionReq *v_wbReq;
/**
 *  v_wxReq.appSecret = @"8a662f440bcdbe99f1ea302250b3d70b";
 */
@property (nonatomic,strong) VSocialActionReq *v_wxReq;

@property (nonatomic,strong) VSocialActionReq *v_qqReq;
/**
 *  调用登录视图
 */
- (void)v_showSocialLoginViewWithFrame:(CGRect)rect withCompletion:(VSocialCompletion)completion;
@end
