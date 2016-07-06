
//
//  UIView+VLoginSocial.m
//  VSocialDemo
//
//  Created by 蚩尤 on 16/5/19.
//  Copyright © 2016年 ouer. All rights reserved.
//

#import <objc/runtime.h>
#import "UIView+VLoginSocial.h"
#import "VWeiBoSocailManager.h"
#import "VWeiXinSocialManager.h"
#import "VTencentSocialManager.h"
static char *VSocialTypeInLoginBtnKey;
static char *VSocialCompletionBlockInViewKey;

@implementation UIView (VLoginSocial)
- (void)v_showSocialLoginViewWithFrame:(CGRect)rect withCompletion:(VSocialCompletion)completion
{
    if (completion) {
        objc_setAssociatedObject(self, &VSocialCompletionBlockInViewKey, completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    CGRect wbFrame = CGRectZero, wxFrame = CGRectZero, qqFrame = CGRectZero;
    BOOL isWxInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
    BOOL isQQInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
    CGFloat btnWidth = 50;
    if (isQQInstalled && isWxInstalled) {
        CGFloat space = (CGRectGetWidth(rect)-(3 * btnWidth))/4;
        wbFrame = CGRectMake(space, (CGRectGetHeight(rect)-btnWidth)/2, btnWidth, btnWidth);
        wxFrame = CGRectMake(space * 2 +btnWidth, (CGRectGetHeight(rect)-btnWidth)/2, btnWidth, btnWidth);
        qqFrame = CGRectMake(space * 3 +btnWidth * 2, (CGRectGetHeight(rect)-btnWidth)/2, btnWidth, btnWidth);
    } else if (isQQInstalled && !isWxInstalled) {
        CGFloat space = (CGRectGetWidth(rect)-(2 * btnWidth))/3;
        wbFrame = CGRectMake(space, (CGRectGetHeight(rect)-btnWidth)/2, btnWidth, btnWidth);
        qqFrame = CGRectMake(space * 2 +btnWidth, (CGRectGetHeight(rect)-btnWidth)/2, btnWidth, btnWidth);

    } else if (!isQQInstalled && isWxInstalled) {
        CGFloat space = (CGRectGetWidth(rect)-(2 * btnWidth))/3;
        wbFrame = CGRectMake(space, (CGRectGetHeight(rect)-btnWidth)/2, btnWidth, btnWidth);
        wxFrame = CGRectMake(space * 2 +btnWidth, (CGRectGetHeight(rect)-btnWidth)/2, btnWidth, btnWidth);
    } else {
        wbFrame = CGRectMake((CGRectGetWidth(rect)-btnWidth)/2, (CGRectGetHeight(rect)-btnWidth)/2, btnWidth, btnWidth);
    }
    if (isQQInstalled) {
        UIButton *qqLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        qqLoginBtn.frame = qqFrame;
        qqLoginBtn.adjustsImageWhenHighlighted = NO;
        NSString *qqImgPath = [[NSBundle mainBundle] pathForResource:@"VSocialResources.bundle/resources/vsocail_btn_qq" ofType:@"png"];
        [qqLoginBtn setImage:[UIImage imageWithContentsOfFile:qqImgPath] forState:UIControlStateNormal];                [qqLoginBtn addTarget:self action:@selector(v_socialBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:qqLoginBtn];
        UILabel * qqLabel = [[UILabel alloc] initWithFrame:CGRectMake(qqLoginBtn.frame.origin.x, qqLoginBtn.frame.size.height + qqLoginBtn.frame.origin.y + 5, qqLoginBtn.frame.size.width, 15)];
        qqLabel.text = @"QQ";
        qqLabel.textColor = [UIColor grayColor];
        qqLabel.textAlignment = NSTextAlignmentCenter;
        qqLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:qqLabel]; 
        objc_setAssociatedObject(qqLoginBtn, &VSocialTypeInLoginBtnKey, @(VSOCIALACTIONTYPE_QQ), OBJC_ASSOCIATION_RETAIN);
    }
    if (isWxInstalled) {
        UIButton *wxLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        wxLoginBtn.frame = wxFrame;
        wxLoginBtn.adjustsImageWhenHighlighted = NO;
        NSString *wxImgPath = [[NSBundle mainBundle] pathForResource:@"VSocialResources.bundle/resources/vsocail_btn_wx" ofType:@"png"];
        [wxLoginBtn setImage:[UIImage imageWithContentsOfFile:wxImgPath] forState:UIControlStateNormal];        [wxLoginBtn addTarget:self action:@selector(v_socialBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:wxLoginBtn];
        UILabel * wxLabel = [[UILabel alloc] initWithFrame:CGRectMake(wxLoginBtn.frame.origin.x, wxLoginBtn.frame.size.height + wxLoginBtn.frame.origin.y + 5, wxLoginBtn.frame.size.width, 15)];
        wxLabel.text = @"微信";
        wxLabel.textColor = [UIColor grayColor];
        wxLabel.textAlignment = NSTextAlignmentCenter;
        wxLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:wxLabel];
        objc_setAssociatedObject(wxLoginBtn, &VSocialTypeInLoginBtnKey, @(VSOCIALACTIONTYPE_WX), OBJC_ASSOCIATION_RETAIN);
    }
    UIButton *wbLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wbLoginBtn.frame = wbFrame;
    wbLoginBtn.adjustsImageWhenHighlighted = NO;
    NSString *wbImgPath = [[NSBundle mainBundle] pathForResource:@"VSocialResources.bundle/resources/vsocail_btn_wb" ofType:@"png"];
    [wbLoginBtn setImage:[UIImage imageWithContentsOfFile:wbImgPath] forState:UIControlStateNormal];
    [wbLoginBtn addTarget:self action:@selector(v_socialBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:wbLoginBtn];
    UILabel * wbLabel = [[UILabel alloc] initWithFrame:CGRectMake(wbLoginBtn.frame.origin.x, wbLoginBtn.frame.size.height + wbLoginBtn.frame.origin.y + 5, wbLoginBtn.frame.size.width, 15)];
    wbLabel.text = @"微博";
    wbLabel.textColor = [UIColor grayColor];
    wbLabel.textAlignment = NSTextAlignmentCenter;
    wbLabel.font = [UIFont systemFontOfSize:12];
    objc_setAssociatedObject(wbLoginBtn, &VSocialTypeInLoginBtnKey, @(VSOCIALACTIONTYPE_WB), OBJC_ASSOCIATION_RETAIN);
    [self addSubview:wbLabel];
}
- (void)v_socialBtnClick:(UIButton *)sender {
    VSocialActionType type = [objc_getAssociatedObject(sender, &VSocialTypeInLoginBtnKey) integerValue];
    VSocialCompletion completion = objc_getAssociatedObject(self, &VSocialCompletionBlockInViewKey);
    if (type == VSOCIALACTIONTYPE_WB) {
        [[VSocial manager] socialWithReq:self.v_wbReq withType:VSOCIALACTIONTYPE_WB withCompletion:completion];
    } else if (type == VSOCIALACTIONTYPE_WX) {
        [[VSocial manager] socialWithReq:self.v_wxReq withType:VSOCIALACTIONTYPE_FRIEND withCompletion:completion];
    } else if (type == VSOCIALACTIONTYPE_QQ) {
        [[VSocial manager] socialWithReq:self.v_qqReq withType:VSOCIALACTIONTYPE_QQ withCompletion:completion];
    }
}
- (void)setV_wbReq:(VSocialActionReq *)v_wbReq
{
    v_wbReq.action = VSOCIALACTION_LOGIN;
    objc_setAssociatedObject(self, @selector(v_wbReq), v_wbReq, OBJC_ASSOCIATION_RETAIN);
}

- (VSocialActionReq *)v_wbReq
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setV_wxReq:(VSocialActionReq *)v_wxReq
{
    v_wxReq.action = VSOCIALACTION_LOGIN;
    objc_setAssociatedObject(self, @selector(v_wxReq), v_wxReq, OBJC_ASSOCIATION_RETAIN);
}

- (VSocialActionReq *)v_wxReq
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setV_qqReq:(VSocialActionReq *)v_qqReq
{
    v_qqReq.action = VSOCIALACTION_LOGIN;
    objc_setAssociatedObject(self, @selector(v_qqReq), v_qqReq, OBJC_ASSOCIATION_RETAIN);
}

- (VSocialActionReq *)v_qqReq
{
    return objc_getAssociatedObject(self, _cmd);
}







@end
