//
//  ViewController.m
//  VSocialDemo
//
//  Created by 蚩尤 on 16/5/20.
//  Copyright © 2016年 ouer. All rights reserved.
//

#import "ViewController.h"
#import "UIView+VLoginSocial.h"
#import "UIViewController+VShareSocial.h"

#define KRandomColor    [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1];

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //登录
    UIView *loginPlatform = [[UIView alloc] init];
    loginPlatform.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 200, CGRectGetWidth(self.view.frame), 200);
    VSocialActionReq *v_wbReq = [[VSocialActionReq alloc] init];
    v_wbReq.redirectURI = @"http://www.davebella.net.cn";
    VSocialActionReq *v_wxReq = [[VSocialActionReq alloc] init];
    v_wxReq.appSecret = @"8a662f440bcdbe99f1ea302250b3d70b";
    VSocialActionReq *v_qqReq = [[VSocialActionReq alloc] init];
    loginPlatform.v_wbReq = v_wbReq;
    loginPlatform.v_wxReq = v_wxReq;
    loginPlatform.v_qqReq = v_qqReq;
    [self.view addSubview:loginPlatform];
    [loginPlatform v_showSocialLoginViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200) withCompletion:^(NSDictionary *infoDic, VSocialActionType type, VSocialActionStatus status, NSString *msg) {
        NSLog(@"infoDic = %@, type = %@, status = %@, msg = %@",infoDic,@(type),@(status),msg);
    }];

    UIButton *allShareBtn = [[UIButton alloc] init];
    allShareBtn.frame = CGRectMake(0,0, 50, 50);
    allShareBtn.center = self.view.center;
    allShareBtn.backgroundColor = KRandomColor;
    [allShareBtn setTitle:@"集成分享" forState:UIControlStateNormal];
    [allShareBtn addTarget:self action:@selector(allShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    allShareBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:allShareBtn];

    
    
    
}

- (void)allShareBtnClick:(UIButton *)sender {
    VSocialActionReq *req = [[VSocialActionReq alloc] init];
    req.shareURL = @"http://www.baidu.com";
    req.shareImgUrl = @"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1463583034&di=0e4a7b64afbb1500c1155f40012a5a2a&src=http://g.hiphotos.baidu.com/image/pic/item/241f95cad1c8a7866f726fe06309c93d71cf5087.jpg";
    req.shareTitle = @"空间分享";
    req.shareText = @"啊哈哈";
    [self v_showSocialShareViewWithReq:req withCompletion:^(NSDictionary *infoDic, VSocialActionType type, VSocialActionStatus status, NSString *msg) {
        NSLog(@"infoDic = %@, type = %@, status = %@, msg = %@",infoDic,@(type),@(status),msg);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
