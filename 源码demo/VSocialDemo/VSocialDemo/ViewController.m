//
//  ViewController.m
//  VSocialDemo
//
//  Created by 蚩尤 on 16/5/17.
//  Copyright © 2016年 ouer. All rights reserved.
//

#import "VSocial.h"
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
    
    
    UIButton *wbLoginBtn = [[UIButton alloc] init];
    wbLoginBtn.frame = CGRectMake(50, 100, 50, 50);
    wbLoginBtn.backgroundColor = KRandomColor;
    [wbLoginBtn setTitle:@"微博登录" forState:UIControlStateNormal];
    [wbLoginBtn addTarget:self action:@selector(wbLoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    wbLoginBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:wbLoginBtn];
    
    UIButton *wbShareBtn = [[UIButton alloc] init];
    wbShareBtn.frame = CGRectMake(150, 100, 50, 50);
    wbShareBtn.backgroundColor = KRandomColor;
    [wbShareBtn setTitle:@"微博分享" forState:UIControlStateNormal];
    [wbShareBtn addTarget:self action:@selector(wbShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    wbShareBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:wbShareBtn];
    
    UIButton *copyBtn = [[UIButton alloc] init];
    copyBtn.frame = CGRectMake(250, 100, 50, 50);
    copyBtn.backgroundColor = KRandomColor;
    [copyBtn setTitle:@"复制链接" forState:UIControlStateNormal];
    [copyBtn addTarget:self action:@selector(copyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    copyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:copyBtn];
    
    UIButton *wxLoginBtn = [[UIButton alloc] init];
    wxLoginBtn.frame = CGRectMake(50, 200, 50, 50);
    wxLoginBtn.backgroundColor = KRandomColor;
    [wxLoginBtn setTitle:@"微信登录" forState:UIControlStateNormal];
    [wxLoginBtn addTarget:self action:@selector(wxLoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    wxLoginBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:wxLoginBtn];
    
    UIButton *wxShareBtn = [[UIButton alloc] init];
    wxShareBtn.frame = CGRectMake(150, 200, 50, 50);
    wxShareBtn.backgroundColor = KRandomColor;
    [wxShareBtn setTitle:@"微信分享" forState:UIControlStateNormal];
    [wxShareBtn addTarget:self action:@selector(wxShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    wxShareBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:wxShareBtn];
    
    UIButton *wxFriShareBtn = [[UIButton alloc] init];
    wxFriShareBtn.frame = CGRectMake(250, 200, 50, 50);
    wxFriShareBtn.backgroundColor = KRandomColor;
    [wxFriShareBtn setTitle:@"朋友圈分享" forState:UIControlStateNormal];
    [wxFriShareBtn addTarget:self action:@selector(wxFriShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    wxFriShareBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:wxFriShareBtn];

    
    UIButton *qqLoginBtn = [[UIButton alloc] init];
    qqLoginBtn.frame = CGRectMake(50,300, 50, 50);
    qqLoginBtn.backgroundColor = KRandomColor;
    [qqLoginBtn setTitle:@"qq登录" forState:UIControlStateNormal];
    [qqLoginBtn addTarget:self action:@selector(qqLoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    qqLoginBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:qqLoginBtn];
    
    UIButton *qqShareBtn = [[UIButton alloc] init];
    qqShareBtn.frame = CGRectMake(150,300, 50, 50);
    qqShareBtn.backgroundColor = KRandomColor;
    [qqShareBtn setTitle:@"qq分享" forState:UIControlStateNormal];
    [qqShareBtn addTarget:self action:@selector(qqShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    qqShareBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:qqShareBtn];
    
    UIButton *qqZoneShareBtn = [[UIButton alloc] init];
    qqZoneShareBtn.frame = CGRectMake(250,300, 50, 50);
    qqZoneShareBtn.backgroundColor = KRandomColor;
    [qqZoneShareBtn setTitle:@"空间分享" forState:UIControlStateNormal];
    [qqZoneShareBtn addTarget:self action:@selector(qqZoneShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    qqZoneShareBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:qqZoneShareBtn];
    
    
    UIButton *allShareBtn = [[UIButton alloc] init];
    allShareBtn.frame = CGRectMake(150,400, 50, 50);
    allShareBtn.backgroundColor = KRandomColor;
    [allShareBtn setTitle:@"集成分享" forState:UIControlStateNormal];
    [allShareBtn addTarget:self action:@selector(allShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    allShareBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:allShareBtn];
    
    
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
    
    
    
   
}

- (void)wbLoginBtnClick:(UIButton *)sender {
    VSocialActionReq *req = [[VSocialActionReq alloc] init];
    req.action = VSOCIALACTION_LOGIN;
    req.redirectURI = @"http://www.davebella.net.cn";
    [[VSocial manager] socialWithReq:req withType:VSOCIALACTIONTYPE_WB withCompletion:^(NSDictionary *infoDic, VSocialActionType type, VSocialActionStatus status, NSString *msg) {
        NSLog(@"infoDic = %@, type = %@, status = %@, msg = %@",infoDic,@(type),@(status),msg);
    }];
}

- (void)wbShareBtnClick:(UIButton *)sender {
    VSocialActionReq *req = [[VSocialActionReq alloc] init];
    req.action = VSOCIALACTION_SHARE;
    req.shareURL = @"http://www.baidu.com";
    req.shareImgUrl = @"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1463583034&di=0e4a7b64afbb1500c1155f40012a5a2a&src=http://g.hiphotos.baidu.com/image/pic/item/241f95cad1c8a7866f726fe06309c93d71cf5087.jpg";
    req.shareTitle = @"微博分享";
    req.shareText = @"啊哈哈";
    
    [[VSocial manager] socialWithReq:req withType:VSOCIALACTIONTYPE_WB withCompletion:^(NSDictionary *infoDic, VSocialActionType type, VSocialActionStatus status, NSString *msg) {
        NSLog(@"infoDic = %@, type = %@, status = %@, msg = %@",infoDic,@(type),@(status),msg);
    }];
}


- (void)copyBtnClick:(UIButton *)sender {
    VSocialActionReq *req = [[VSocialActionReq alloc] init];
    req.shareURL = @"http://www.baidu.com";
    [[VSocial manager] socialWithReq:req withType:VSOCIALACTIONTYPE_COPY withCompletion:^(NSDictionary *infoDic, VSocialActionType type, VSocialActionStatus status, NSString *msg) {
        NSLog(@"infoDic = %@, type = %@, status = %@, msg = %@",infoDic,@(type),@(status),msg);
    }];
}

- (void)wxLoginBtnClick:(UIButton *)sender {
    VSocialActionReq *req = [[VSocialActionReq alloc] init];
    req.action = VSOCIALACTION_LOGIN;
    req.appSecret = @"8a662f440bcdbe99f1ea302250b3d70b";
    [[VSocial manager] socialWithReq:req withType:VSOCIALACTIONTYPE_FRIEND withCompletion:^(NSDictionary *infoDic, VSocialActionType type, VSocialActionStatus status, NSString *msg) {
        
        NSLog(@"infoDic = %@, type = %@, status = %@, msg = %@",infoDic,@(type),@(status),msg);
    }];
    
}

- (void)wxShareBtnClick:(UIButton *)sender {
    VSocialActionReq *req = [[VSocialActionReq alloc] init];
    req.action = VSOCIALACTION_SHARE;
    req.shareURL = @"http://www.baidu.com";
    req.shareImgUrl = @"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1463583034&di=0e4a7b64afbb1500c1155f40012a5a2a&src=http://g.hiphotos.baidu.com/image/pic/item/241f95cad1c8a7866f726fe06309c93d71cf5087.jpg";
    req.shareTitle = @"微信分享";
    req.shareText = @"啊哈哈";
    
    [[VSocial manager] socialWithReq:req withType:VSOCIALACTIONTYPE_WX withCompletion:^(NSDictionary *infoDic, VSocialActionType type, VSocialActionStatus status, NSString *msg) {
        NSLog(@"infoDic = %@, type = %@, status = %@, msg = %@",infoDic,@(type),@(status),msg);
    }];
    
}

- (void)wxFriShareBtnClick:(UIButton *)sender {
    VSocialActionReq *req = [[VSocialActionReq alloc] init];
    req.action = VSOCIALACTION_SHARE;
    req.shareURL = @"http://www.baidu.com";
    req.shareImgUrl = @"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1463583034&di=0e4a7b64afbb1500c1155f40012a5a2a&src=http://g.hiphotos.baidu.com/image/pic/item/241f95cad1c8a7866f726fe06309c93d71cf5087.jpg";
    req.shareTitle = @"朋友圈分享";
    req.shareText = @"啊哈哈";
    
    [[VSocial manager] socialWithReq:req withType:VSOCIALACTIONTYPE_FRIEND withCompletion:^(NSDictionary *infoDic, VSocialActionType type, VSocialActionStatus status, NSString *msg) {
        NSLog(@"infoDic = %@, type = %@, status = %@, msg = %@",infoDic,@(type),@(status),msg);
    }];
    
}


- (void)qqLoginBtnClick:(UIButton *)sender {
    VSocialActionReq *req = [[VSocialActionReq alloc] init];
    req.action = VSOCIALACTION_LOGIN;
    
    [[VSocial manager] socialWithReq:req withType:VSOCIALACTIONTYPE_QQ withCompletion:^(NSDictionary *infoDic, VSocialActionType type, VSocialActionStatus status, NSString *msg) {
        NSLog(@"infoDic = %@, type = %@, status = %@, msg = %@",infoDic,@(type),@(status),msg);
    }];
}

- (void)qqShareBtnClick:(UIButton *)sender {
    VSocialActionReq *req = [[VSocialActionReq alloc] init];
    req.action = VSOCIALACTION_SHARE;
    req.shareURL = @"http://www.baidu.com";
    req.shareImgUrl = @"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1463583034&di=0e4a7b64afbb1500c1155f40012a5a2a&src=http://g.hiphotos.baidu.com/image/pic/item/241f95cad1c8a7866f726fe06309c93d71cf5087.jpg";
    req.shareTitle = @"qq分享";
    req.shareText = @"啊哈哈";
    
    [[VSocial manager] socialWithReq:req withType:VSOCIALACTIONTYPE_QQ withCompletion:^(NSDictionary *infoDic, VSocialActionType type, VSocialActionStatus status, NSString *msg) {
        NSLog(@"infoDic = %@, type = %@, status = %@, msg = %@",infoDic,@(type),@(status),msg);
    }];
}

- (void)qqZoneShareBtnClick:(UIButton *)sender {
    VSocialActionReq *req = [[VSocialActionReq alloc] init];
    req.action = VSOCIALACTION_SHARE;
    req.shareURL = @"http://www.baidu.com";
    req.shareImgUrl = @"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1463583034&di=0e4a7b64afbb1500c1155f40012a5a2a&src=http://g.hiphotos.baidu.com/image/pic/item/241f95cad1c8a7866f726fe06309c93d71cf5087.jpg";
    req.shareTitle = @"空间分享";
    req.shareText = @"啊哈哈";
    
    [[VSocial manager] socialWithReq:req withType:VSOCIALACTIONTYPE_ZONE withCompletion:^(NSDictionary *infoDic, VSocialActionType type, VSocialActionStatus status, NSString *msg) {
        NSLog(@"infoDic = %@, type = %@, status = %@, msg = %@",infoDic,@(type),@(status),msg);
    }];
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
