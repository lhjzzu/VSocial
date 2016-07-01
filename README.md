# VSocial
这是一个社会化组件，集成了微信，微博，qq，登录以及分享功能。

`(注意:由于库地址的变更，1.0.3之前的版本不再支持)`

# Usage

## 手动导入

* 把sdk中的文件夹拉倒工程中

* 导入相关的框架和库
   
        UIKit.framework
        Foundation.framework
        CoreGraphics.framework
        CoreText.framework
        QuartzCore.framework
        CoreTelephony.framework
        SystemConfiguration.framework
        CFNetwork.framework
        ImageIO.framework
        MobileCoreServices.framework
        Security.framework
        libc++.tbd
        libz.tbd
        libsqlite3.0.tbd
 
* `buildSetting`中的配置
   
        other Linker Flags -> -ObjC
        Enable Bitcode -> NO
        

## cocoapods自动导入

* 先`$ pod search VSocial`进行搜索，如果搜索不到就 `$ pod setup `更新我们本地的`pods`库
* `Podfile`文件中
  
        pod 'VSocial'
* 执行 `$ pod install --verbose --no-repo-update`


  
        
## `info.plist`中的配置
   
        1 支持http协议
        
        <key>NSAppTransportSecurity</key>
        <dict>
            <key>NSAllowsArbitraryLoads</key>
        <true/>
        </dict>
        
        2 为微博，微信，qq设置白名单
        
        <key>LSApplicationQueriesSchemes</key>
        <array>
        	<string>sinaweibo</string>
        	<string>sinaweibohd</string>
        	<string>sinaweibosso</string>
        	<string>sinaweibohdsso</string>
        	<string>weibosdk</string>
	        <string>weibosdk2.5</string>
	        <string>wechat</string>
	        <string>weixin</string>
	        <string>mqq</string>
	        <string>mqzoneopensdk</string>
	        <string>mqzoneopensdkapi</string>
	        <string>mqzoneopensdkapi19</string>
	        <string>mqzoneopensdkapiV2</string>
	        <string>mqqOpensdkSSoLogin</string>
	        <string>mqqopensdkapiV2</string>
	        <string>mqqopensdkapiV3</string>
	        <string>wtloginmqq2</string>
	        <string>mqqapi</string>
	        <string>mqqwpa</string>
	        <string>mqzone</string>
	        <string>mqqbrowser</string>
        </array>

        3 在URL Types中设置微信，微博，qq的scheme
        
        

## 工程中集成

* Appdelegate中

        - (BOOL)application:(UIApplication *)application d
        idFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
         // Override point for customization after application launch.
               [[VSocial manager] regiserSocailApp];

         return YES;
        }
        
        - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url 
        options:(NSDictionary<NSString *,id> *)options
        {
    
            [[VSocial manager] handleOpenURL:url withCompeltion
            :^(NSDictionary *infoDic, VSocialActionType type, 
            VSocialActionStatus status, NSString *msg) {
                NSLog(@"********* infoDic = %@, type = %@,
                 status = %@, msg = %@",infoDic,@(type),@(status),msg);
            }];    
            return YES;
        }
        - (BOOL)application:(UIApplication *)app 
        openURL:(nonnull NSURL *)url 
        sourceApplication:(nullable NSString *)sourceApplication 
        annotation:(nonnull id)annotation{
            [[VSocial manager] handleOpenURL:url withCompeltion:^(NSDictionary *infoDic, VSocialActionType type, VSocialActionStatus status, NSString *msg) {
        NSLog(@"********* infoDic = %@, type = %@, status = %@, msg = %@",infoDic,@(type),@(status),msg);
            }];
            return YES;
        }
        - (BOOL)application:(UIApplication *)app handleOpenURL:(nonnull NSURL *)url
        {
    
            [[VSocial manager] handleOpenURL:url 
            withCompeltion:^(NSDictionary *infoDic,        
             VSocialActionType type, VSocialActionStatus status, NSString *msg) {
                NSLog(@"********* infoDic = %@,  type = %@, 
                status = %@, msg = %@",infoDic,@(type),@(status),msg);
            }];
    
            return YES;
        }



*  在视图控制器中

        #import "UIView+VLoginSocial.h"
        #import "UIViewController+VShareSocial.h"
        
         //登录
        UIView *loginPlatform = [[UIView alloc] init];
            loginPlatform.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 200, CGRectGetWidth(self.view.frame), 200);
            VSocialActionReq *v_wbReq = [[VSocialActionReq alloc] init];
            v_wbReq.redirectURI = @"xxxxxxxxxxx";
            VSocialActionReq *v_wxReq = [[VSocialActionReq alloc] init];
            v_wxReq.appSecret = @"xxxxxxxxxxxxxx";
            VSocialActionReq *v_qqReq = [[VSocialActionReq alloc] init];
            loginPlatform.v_wbReq = v_wbReq;
            loginPlatform.v_wxReq = v_wxReq;
            loginPlatform.v_qqReq = v_qqReq;
            [self.view addSubview:loginPlatform];
            [loginPlatform v_showSocialLoginViewWithFrame:
            CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200) 
            withCompletion:^(NSDictionary *infoDic, VSocialActionType type, 
            VSocialActionStatus status, NSString *msg) {
            NSLog(@"infoDic = %@, type = %@, status = %@, 
            msg = %@",infoDic,@(type),@(status),msg);
            }];

         //分享
            UIButton *allShareBtn = [[UIButton alloc] init];
            allShareBtn.frame = CGRectMake(0,0, 50, 50);
            allShareBtn.center = self.view.center;
            allShareBtn.backgroundColor = KRandomColor;
            [allShareBtn setTitle:@"集成分享" forState:UIControlStateNormal];
            [allShareBtn addTarget:self action:@selector(allShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            allShareBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.view addSubview:allShareBtn];


          - (void)allShareBtnClick:(UIButton *)sender {
              VSocialActionReq *req = [[VSocialActionReq alloc] init];
              req.shareURL = @"http://xxxx.com";
              req.shareImgUrl = @"http://xxxxx.png";
              req.shareTitle = @"分享";
              req.shareText = @"啊哈哈";
              [self v_showSocialShareViewWithReq:req 
              withCompletion:^(NSDictionary *infoDic, 
              VSocialActionType type, VSocialActionStatus status, NSString *msg) {
                  NSLog(@"infoDic = %@, type = %@, 
                  status = %@, msg = %@",infoDic,@(type),@(status),msg);
              }];
          }
     
     
         你也可以自己调用socialWithReq:withType:withCompeltion:方法来定制自己的界面，
         如果只是想改图片的话，把原来的删除替换成自己的图片就可以了，但是名字要一样。
      
      


## 删除某个渠道(例如删除qq)

   
   1 如果是手动导入的，直接把Channers中`QQSDK`的文件夹直接删除(可以完全删除，也可以只删除索引)
   
   2 如果是`Cocoapods`导入，那么修改`Podfile`文件  `Pod 'VSocial/WXSDK'` `pod 'VSocial/WBSDK'`，
     然后重新安装即可

   
 
        
        
        
        
        