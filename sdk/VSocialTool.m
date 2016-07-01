//
//  VSocialTool.m
//  VSocialDemo
//
//  Created by 蚩尤 on 16/5/17.
//  Copyright © 2016年 ouer. All rights reserved.
//

#import "VSocialTool.h"
#import "VSocial.h"
@implementation VSocialTool

#pragma mark - check String is Empty
+ (BOOL)isEmpty:(NSString *)string {
    
    if (![string isKindOfClass:[NSString class]])
        string = [string description];
    if (string == nil || string == NULL)
        return YES;
    if ([string isKindOfClass:[NSNull class]])
        return YES;
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0)
        return YES;
    if ([string isEqualToString:@"(null)"])
        return YES;
    if ([string isEqualToString:@"(null)(null)"])
        return YES;
    if ([string isEqualToString:@"<null>"])
        return YES;
    
    // return Default
    return NO;
}

+ (BOOL)canShareWithReq:(VSocialActionReq *)req
{
    if ([VSocialTool isEmpty:req.shareURL] || [VSocialTool isEmpty:req.shareImgUrl] || [VSocialTool isEmpty:req.shareText] || [VSocialTool isEmpty:req.shareTitle]) {
        return NO;
    } else {
        return YES;
    }
}
@end
