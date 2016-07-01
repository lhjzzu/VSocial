//
//  UIViewController+VShareSocial.m
//  VSocialDemo
//
//  Created by 蚩尤 on 16/5/19.
//  Copyright © 2016年 ouer. All rights reserved.
//

#import <objc/runtime.h>
#import "VWeiBoSocailManager.h"
#import "VWeiXinSocialManager.h"
#import "VTencentSocialManager.h"
#import "UIViewController+VShareSocial.h"
@interface VShareSocialView : UIView
{
    UIButton *wbBtn;
    UIButton *wxBtn;
    UIButton *qqBtn;
    UIButton *cpBtn;
    UIButton *wxFriBtn;
    UIButton *qqZoneBtn;

    UILabel *wbLab;
    UILabel *wxLab;
    UILabel *qqLab;
    UILabel *cpLab;
    UILabel *wxFriLab;
    UILabel *qqZoneLab;
    
    UIView *lineView;
    UIButton *cancelBtn;
}
@property (nonatomic,strong) UIViewController *vc;
@property (nonatomic,strong) VSocialActionReq *req;
@property (nonatomic,strong) VSocialCompletion completion;

@end
@implementation VShareSocialView
- (instancetype)init
{
    self = [super init];
    if (self) {
        BOOL isWxInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
        BOOL isQQInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
        BOOL isWbInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]];
        if (isWxInstalled) {
            //微信
            wxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *wxImgPath = [[NSBundle mainBundle] pathForResource:@"VSocialResources.bundle/resources/vsocail_btn_wx" ofType:@"png"];
            [wxBtn setBackgroundImage:[UIImage imageWithContentsOfFile:wxImgPath] forState:UIControlStateNormal];
            wxBtn.adjustsImageWhenHighlighted = NO;
            wxBtn.bounds = CGRectMake(0, 0, 50, 50);
            [wxBtn addTarget:self action:@selector(v_shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            objc_setAssociatedObject(wxBtn, @selector(v_shareBtnClick:), @(VSOCIALACTIONTYPE_WX), OBJC_ASSOCIATION_RETAIN);
            [self addSubview:wxBtn];

            wxLab = [[UILabel alloc] init];
            wxLab.font = [UIFont systemFontOfSize:12];
            wxLab.text = @"微信";
            wxLab.textColor = [UIColor grayColor];
            [wxLab sizeToFit];
            [self addSubview:wxLab];
            // 朋友圈
            wxFriBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *wxFriImgPath = [[NSBundle mainBundle] pathForResource:@"VSocialResources.bundle/resources/vsocail_btn_fri" ofType:@"png"];
            [wxFriBtn setBackgroundImage:[UIImage imageWithContentsOfFile:wxFriImgPath] forState:UIControlStateNormal];
            wxFriBtn.adjustsImageWhenHighlighted = NO;
            wxFriBtn.bounds = CGRectMake(0, 0, 50, 50);
            [wxFriBtn addTarget:self action:@selector(v_shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            objc_setAssociatedObject(wxFriBtn, @selector(v_shareBtnClick:), @(VSOCIALACTIONTYPE_FRIEND), OBJC_ASSOCIATION_RETAIN);
            [self addSubview:wxFriBtn];
            
            wxFriLab = [[UILabel alloc] init];
            wxFriLab.font = [UIFont systemFontOfSize:12];
            wxFriLab.text = @"微信朋友圈";
            wxFriLab.textColor = [UIColor grayColor];
            [wxFriLab sizeToFit];
            [self addSubview:wxFriLab];
        }
        if (isQQInstalled) {
            //qq
            qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *qqImgPath = [[NSBundle mainBundle] pathForResource:@"VSocialResources.bundle/resources/vsocail_btn_qq" ofType:@"png"];
            [qqBtn setBackgroundImage:[UIImage imageWithContentsOfFile:qqImgPath] forState:UIControlStateNormal];
            qqBtn.bounds = CGRectMake(0, 0, 50, 50);
            qqBtn.adjustsImageWhenHighlighted = NO;
            [qqBtn addTarget:self action:@selector(v_shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            objc_setAssociatedObject(qqBtn, @selector(v_shareBtnClick:), @(VSOCIALACTIONTYPE_QQ), OBJC_ASSOCIATION_RETAIN);
            [self addSubview:qqBtn];
            // qqLab
            qqLab = [[UILabel alloc] init];
            qqLab.font = [UIFont systemFontOfSize:12];
            qqLab.text = @"QQ";
            qqLab.textColor = [UIColor grayColor];
            [qqLab sizeToFit];
            [self addSubview:qqLab];
            //qqZoneBtn
            qqZoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *qqZoneImgPath = [[NSBundle mainBundle] pathForResource:@"VSocialResources.bundle/resources/vsocail_btn_zone" ofType:@"png"];
            [qqZoneBtn setBackgroundImage:[UIImage imageWithContentsOfFile:qqZoneImgPath] forState:UIControlStateNormal];
            qqZoneBtn.adjustsImageWhenHighlighted = NO;
            qqZoneBtn.bounds = CGRectMake(0, 0, 50, 50);
            [qqZoneBtn addTarget:self action:@selector(v_shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            objc_setAssociatedObject(qqZoneBtn, @selector(v_shareBtnClick:), @(VSOCIALACTIONTYPE_ZONE), OBJC_ASSOCIATION_RETAIN);
            [self addSubview:qqZoneBtn];
            // qqZoneLab
            qqZoneLab = [[UILabel alloc] init];
            qqZoneLab.font = [UIFont systemFontOfSize:12];
            qqZoneLab.text = @"QQ空间";
            qqZoneLab.textColor = [UIColor grayColor];
            [qqZoneLab sizeToFit];
            [self addSubview:qqZoneLab];
        }
        if (isWbInstalled) {
            wbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *wbImgPath = [[NSBundle mainBundle] pathForResource:@"VSocialResources.bundle/resources/vsocail_btn_wb" ofType:@"png"];
            [wbBtn setBackgroundImage:[UIImage imageWithContentsOfFile:wbImgPath] forState:UIControlStateNormal];
            wbBtn.bounds = CGRectMake(0, 0, 50, 50);
            wbBtn.adjustsImageWhenHighlighted = NO;
            [wbBtn addTarget:self action:@selector(v_shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            objc_setAssociatedObject(wbBtn, @selector(v_shareBtnClick:), @(VSOCIALACTIONTYPE_WB), OBJC_ASSOCIATION_RETAIN);
            [self addSubview:wbBtn];
            // wbLab
            wbLab = [[UILabel alloc] init];
            wbLab.font = [UIFont systemFontOfSize:12];
            wbLab.text = @"微博";
            wbLab.textColor = [UIColor grayColor];
            [wbLab sizeToFit];
            [self addSubview:wbLab];
        }
    }
    cpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *cpImgPath = [[NSBundle mainBundle] pathForResource:@"VSocialResources.bundle/resources/vsocail_btn_copy" ofType:@"png"];
    objc_setAssociatedObject(cpBtn, @selector(v_shareBtnClick:), @(VSOCIALACTIONTYPE_COPY), OBJC_ASSOCIATION_RETAIN);
    [cpBtn setBackgroundImage:[UIImage imageWithContentsOfFile:cpImgPath] forState:UIControlStateNormal];
    cpBtn.adjustsImageWhenHighlighted = NO;
    cpBtn.bounds = CGRectMake(0, 0, 50, 50);
    [cpBtn addTarget:self action:@selector(v_shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cpBtn];
    
    cpLab = [[UILabel alloc] init];
    cpLab.font = [UIFont systemFontOfSize:12];
    cpLab.text = @"复制链接";
    cpLab.textColor = [UIColor grayColor];
    [cpLab sizeToFit];
    [self addSubview:cpLab];
    
    lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.6;
    [self addSubview:lineView];
    
    cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn addTarget:self action:@selector(v_cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self addSubview:cancelBtn];
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    UIWindow *window =  [[UIApplication sharedApplication].delegate window];
    CGFloat btnWidth = 50;
    //按钮之间的距离
    CGFloat space = (window.bounds.size.width - (btnWidth * 3)) / 5 * 1.5;
    //按钮和对应标题的距离
    CGFloat padding = 5;
    //上一行的标题和下一行按钮之间的距离
    CGFloat betW = 15;
    CGFloat left = (window.bounds.size.width - (btnWidth * 3)) / 5 ;
    CGFloat top = 19;
    BOOL isWxInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
    BOOL isQQInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
    BOOL isWbInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]];
    if (isWxInstalled && isQQInstalled && isWbInstalled) {
        //第一行
        wxBtn.frame = CGRectMake(left, top, btnWidth, btnWidth);
        wxLab.center = CGPointMake(wxBtn.center.x, CGRectGetMaxY(wxBtn.frame) + padding + CGRectGetHeight(wxLab.frame)/ 2);
        wxFriBtn.frame = CGRectMake(CGRectGetMaxX(wxBtn.frame) + space, top, btnWidth, btnWidth);
        wxFriLab.center = CGPointMake(wxFriBtn.center.x, CGRectGetMaxY(wxFriBtn.frame) + padding + CGRectGetHeight(wxFriLab.frame)/ 2);
        wbBtn.frame = CGRectMake(CGRectGetMaxX(wxFriLab.frame) + space, top, btnWidth, btnWidth);
        wbLab.center = CGPointMake(wbBtn.center.x, CGRectGetMaxY(wbBtn.frame) + padding + CGRectGetHeight(wbLab.frame)/ 2);
        //第二行
        qqBtn.frame = CGRectMake(left, CGRectGetMaxY(wbLab.frame)+ betW , btnWidth, btnWidth);
        qqLab.center = CGPointMake(qqBtn.center.x, CGRectGetMaxY(qqBtn.frame) + padding + CGRectGetHeight(qqLab.frame)/ 2);
        qqZoneBtn.frame = CGRectMake(CGRectGetMaxX(qqBtn.frame) + space, CGRectGetMaxY(wbLab.frame)+ betW, btnWidth, btnWidth);
        qqZoneLab.center = CGPointMake(qqZoneBtn.center.x, CGRectGetMaxY(qqZoneBtn.frame) + padding + CGRectGetHeight(qqZoneLab.frame)/ 2);
        cpBtn.frame = CGRectMake(CGRectGetMaxX(qqZoneBtn.frame) + space, CGRectGetMaxY(wbLab.frame)+ betW, btnWidth, btnWidth);
        cpLab.center = CGPointMake(cpBtn.center.x, CGRectGetMaxY(cpBtn.frame) + padding + CGRectGetHeight(cpLab.frame)/ 2);
    } else if (!isWxInstalled && isQQInstalled && isWbInstalled) {
        //第一行
        wbBtn.frame = CGRectMake(left, top, btnWidth, btnWidth);
        wbLab.center = CGPointMake(wbBtn.center.x, CGRectGetMaxY(wbBtn.frame) + padding + CGRectGetHeight(wbLab.frame)/ 2);
        qqBtn.frame = CGRectMake(CGRectGetMaxX(wbBtn.frame) + space, top, btnWidth, btnWidth);
        qqLab.center = CGPointMake(qqBtn.center.x, CGRectGetMaxY(qqBtn.frame) + padding + CGRectGetHeight(qqLab.frame)/ 2);
        qqZoneBtn.frame = CGRectMake(CGRectGetMaxX(qqBtn.frame) + space, CGRectGetMaxY(wbLab.frame)+ betW, btnWidth, btnWidth);
        qqZoneLab.center = CGPointMake(qqZoneBtn.center.x, CGRectGetMaxY(qqZoneBtn.frame) + padding + CGRectGetHeight(qqZoneLab.frame)/ 2);
        //第二行
        cpBtn.frame = CGRectMake(left, CGRectGetMaxY(wbLab.frame)+ betW, btnWidth, btnWidth);
        cpLab.center = CGPointMake(cpBtn.center.x, CGRectGetMaxY(cpBtn.frame) + padding + CGRectGetHeight(cpLab.frame)/ 2);
    } else if (isWxInstalled && !isQQInstalled && isWbInstalled) {
        //第一行
        wxBtn.frame = CGRectMake(left, top, btnWidth, btnWidth);
        wxLab.center = CGPointMake(wxBtn.center.x, CGRectGetMaxY(wxBtn.frame) + padding + CGRectGetHeight(wxLab.frame)/ 2);
        wxFriBtn.frame = CGRectMake(CGRectGetMaxX(wxBtn.frame) + space, top, btnWidth, btnWidth);
        wxFriLab.center = CGPointMake(wxFriBtn.center.x, CGRectGetMaxY(wxFriBtn.frame) + padding + CGRectGetHeight(wxFriLab.frame)/ 2);
        wbBtn.frame = CGRectMake(CGRectGetMaxX(wxFriLab.frame) + space, top, btnWidth, btnWidth);
        wbLab.center = CGPointMake(wbBtn.center.x, CGRectGetMaxY(wbBtn.frame) + padding + CGRectGetHeight(wbLab.frame)/ 2);
        //第二行
        cpBtn.frame = CGRectMake(left, CGRectGetMaxY(wbLab.frame)+ betW, btnWidth, btnWidth);
        cpLab.center = CGPointMake(cpBtn.center.x, CGRectGetMaxY(cpBtn.frame) + padding + CGRectGetHeight(cpLab.frame)/ 2);
    } else if (isWxInstalled && isQQInstalled && !isWbInstalled) {
        //第一行
        wxBtn.frame = CGRectMake(left, top, btnWidth, btnWidth);
        wxLab.center = CGPointMake(wxBtn.center.x, CGRectGetMaxY(wxBtn.frame) + padding + CGRectGetHeight(wxLab.frame)/ 2);
        wxFriBtn.frame = CGRectMake(CGRectGetMaxX(wxBtn.frame) + space, top, btnWidth, btnWidth);
        wxFriLab.center = CGPointMake(wxFriBtn.center.x, CGRectGetMaxY(wxFriBtn.frame) + padding + CGRectGetHeight(wxFriLab.frame)/ 2);
        qqBtn.frame = CGRectMake(CGRectGetMaxX(wxFriBtn.frame) + space, top , btnWidth, btnWidth);
        qqLab.center = CGPointMake(qqBtn.center.x, CGRectGetMaxY(qqBtn.frame) + padding + CGRectGetHeight(qqLab.frame)/ 2);
        //第二行
        qqZoneBtn.frame = CGRectMake(left, CGRectGetMaxY(qqLab.frame)+ betW, btnWidth, btnWidth);
        qqZoneLab.center = CGPointMake(qqZoneBtn.center.x, CGRectGetMaxY(qqZoneBtn.frame) + padding + CGRectGetHeight(qqZoneLab.frame)/ 2);
        cpBtn.frame = CGRectMake(CGRectGetMaxX(qqZoneBtn.frame) + space, CGRectGetMaxY(qqZoneLab.frame)+ betW, btnWidth, btnWidth);
        cpLab.center = CGPointMake(cpBtn.center.x, CGRectGetMaxY(cpBtn.frame) + padding + CGRectGetHeight(cpLab.frame)/ 2);
    } else if (!isWxInstalled && !isQQInstalled && isWbInstalled) {
        //第一行
        wbBtn.frame = CGRectMake(left, top, btnWidth, btnWidth);
        wbLab.center = CGPointMake(wbBtn.center.x, CGRectGetMaxY(wbBtn.frame) + padding + CGRectGetHeight(wbLab.frame)/ 2);
        cpBtn.frame = CGRectMake(CGRectGetMaxX(wbBtn.frame) + space, top, btnWidth, btnWidth);
        cpLab.center = CGPointMake(cpBtn.center.x, CGRectGetMaxY(cpBtn.frame) + padding + CGRectGetHeight(cpLab.frame)/ 2);
    } else if (!isWxInstalled && isQQInstalled && !isWbInstalled) {
        qqBtn.frame = CGRectMake(left, top, btnWidth, btnWidth);
        //第一行
        qqLab.center = CGPointMake(qqBtn.center.x, CGRectGetMaxY(qqBtn.frame) + padding + CGRectGetHeight(qqLab.frame)/ 2);
        qqZoneBtn.frame = CGRectMake(CGRectGetMaxX(qqBtn.frame) + space, top, btnWidth, btnWidth);
        qqZoneLab.center = CGPointMake(qqZoneBtn.center.x, CGRectGetMaxY(qqZoneBtn.frame) + padding + CGRectGetHeight(qqZoneLab.frame)/ 2);
        cpBtn.frame = CGRectMake(CGRectGetMaxX(qqZoneBtn.frame) + space, top, btnWidth, btnWidth);
        cpLab.center = CGPointMake(cpBtn.center.x, CGRectGetMaxY(cpBtn.frame) + padding + CGRectGetHeight(cpLab.frame)/ 2);
    } else if (isWxInstalled && !isQQInstalled && !isWbInstalled) {
        //第一行
        wxBtn.frame = CGRectMake(left, top, btnWidth, btnWidth);
        wxLab.center = CGPointMake(wxBtn.center.x, CGRectGetMaxY(wxBtn.frame) + padding + CGRectGetHeight(wxLab.frame)/ 2);
        wxFriBtn.frame = CGRectMake(CGRectGetMaxX(wxBtn.frame) + space, top, btnWidth, btnWidth);
        wxFriLab.center = CGPointMake(wxFriBtn.center.x, CGRectGetMaxY(wxFriBtn.frame) + padding + CGRectGetHeight(wxFriLab.frame)/ 2);
        cpBtn.frame = CGRectMake(CGRectGetMaxX(wxFriBtn.frame) + space, top, btnWidth, btnWidth);
        cpLab.center = CGPointMake(cpBtn.center.x, CGRectGetMaxY(cpBtn.frame) + padding + CGRectGetHeight(cpLab.frame)/ 2);
    } else if (!isWxInstalled && !isQQInstalled && !isWbInstalled) {
        //第一行
        cpBtn.frame = CGRectMake(left, top, btnWidth, btnWidth);
        cpLab.center = CGPointMake(cpBtn.center.x, CGRectGetMaxY(cpBtn.frame) + padding + CGRectGetHeight(cpLab.frame)/ 2);
    }
    lineView.frame = CGRectMake(0, CGRectGetMaxY(cpLab.frame) + top, window.bounds.size.width, 0.5);
    cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(lineView.frame), window.bounds.size.width, btnWidth);
    
    CGRect frame = CGRectMake(0, CGRectGetHeight(window.bounds) - CGRectGetMaxY(cancelBtn.frame), CGRectGetWidth(window.bounds), CGRectGetMaxY(cancelBtn.frame));
    self.frame = frame;
}

#pragma mark -- 分享
- (void)v_shareBtnClick:(UIButton *)sender {
    VSocialActionType type = [objc_getAssociatedObject(sender, _cmd) integerValue];
    self.req.action = VSOCIALACTION_SHARE;
    [[VSocial manager] socialWithReq:self.req withType:type withCompeltion:self.completion];
}
#pragma mark -- 取消
- (void)v_cancelBtnClick:(UIButton *)sender {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [self.vc performSelector:@selector(v_dismissSocialShareView)];
#pragma clang diagnostic pop
}
@end


@implementation UIViewController (VShareSocial)
- (void)v_showSocialShareViewWithReq:(VSocialActionReq *)req withCompletion:(VSocialCompletion)completion
{
    if (!req) {
        completion(nil,VSOCIALACTIONTYPE_UNKNOW,VSOCIALACTIONSTATUS_INVAILD,@"分享视图调起失败,req不能为空");
        return;
    }
    UIWindow *window =  [[UIApplication sharedApplication].delegate window];
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.alpha = 0.6;
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.frame = window.frame;
    [window addSubview:backgroundView];
    objc_setAssociatedObject(self, @selector(v_dismissSocialShareView), backgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UITapGestureRecognizer *tapGeture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(v_dismissSocialShareView)];
    [backgroundView addGestureRecognizer:tapGeture];

    VShareSocialView *shareSocialView = [[VShareSocialView alloc] init];
    shareSocialView.frame = CGRectZero;
    shareSocialView.backgroundColor = [UIColor whiteColor];
    shareSocialView.completion = completion;
    shareSocialView.req = req;
    shareSocialView.vc = self;
    [window addSubview:shareSocialView];
    objc_setAssociatedObject(self, @selector(v_showSocialShareViewWithReq:withCompletion:), shareSocialView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)v_dismissSocialShareView {
    UIView *backgroundView = objc_getAssociatedObject(self, _cmd);
    if (backgroundView) {
        [backgroundView removeFromSuperview];
    }
    UIView *shareSocialView = objc_getAssociatedObject(self, @selector(v_showSocialShareViewWithReq:withCompletion:));
    if (shareSocialView) {
        [shareSocialView removeFromSuperview];
    }
}





@end
