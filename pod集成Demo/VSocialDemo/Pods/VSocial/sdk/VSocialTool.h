//
//  VSocialTool.h
//  VSocialDemo
//
//  Created by 蚩尤 on 16/5/17.
//  Copyright © 2016年 ouer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VSocialActionReq;
@interface VSocialTool : NSObject
+ (BOOL)isEmpty:(NSString *)string;
+ (BOOL)canShareWithReq:(VSocialActionReq *)req;

@end
