//
//  UIViewController+VShareSocial.h
//  VSocialDemo
//
//  Created by 蚩尤 on 16/5/19.
//  Copyright © 2016年 ouer. All rights reserved.
//

#import "VSocial.h"
#import <UIKit/UIKit.h>
@interface UIViewController (VShareSocial)
/**
 *  调用分享视图
 *
 *  @param req        分享的内容
 *  @param completion 分享完成的回调
 */
- (void)v_showSocialShareViewWithReq:(VSocialActionReq *)req withCompletion:(VSocialCompletion)completion;
@end
