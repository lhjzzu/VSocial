//
//  VSocial.h
//  VSocialDemo
//
//  Created by 蚩尤 on 16/5/17.
//  Copyright © 2016年 ouer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
/**
 *  操作指:登录和分享
 */
static char *VSocialShareImageDownLoaderKey;

typedef NS_ENUM(NSInteger, VSocialAction) {
    VSOCIALACTION_LOGIN = 0, //登录
    VSOCIALACTION_SHARE      //分享
};


typedef NS_ENUM(NSInteger, VSocialActionType) {
    VSOCIALACTIONTYPE_WB = 100,    //微博
    VSOCIALACTIONTYPE_WX = 101,    //微信
    VSOCIALACTIONTYPE_FRIEND= 102, //朋友圈
    VSOCIALACTIONTYPE_QQ = 103,    //qq
    VSOCIALACTIONTYPE_ZONE= 104,   //qq空间
    VSOCIALACTIONTYPE_COPY= 105,   //复制链接
    VSOCIALACTIONTYPE_UNKNOW= 106  //未知类型

};


typedef NS_ENUM(NSInteger, VSocialActionStatus) {
    VSOCIALACTIONSTATUS_SUCCESS = 1000, //操作成功
    VSOCIALACTIONSTATUS_CANCEL = 1001,  //操作取消
    VSOCIALACTIONSTATUS_FAILURE = 1002, //操作失败
    VSOCIALACTIONSTATUS_INVAILD = 1003  //操作错误（调起组件时）
    
};

#pragma mark -- VSocialActionReq


@interface VSocialActionReq : NSObject
/**
 * 在开放平台注册生成的appSecret（微信登录需要传入）
 */
@property (nonatomic,copy) NSString *appSecret;
/**
 *  如果登录微博的时候要传入redirectURI（微博开放平台:应用信息->高级信息->授权回调页）
 */
@property (nonatomic,copy) NSString *redirectURI;
/**
 *  操作(登录或分享,默认为登录)
 */
@property (nonatomic, assign) VSocialAction action;
/**
 *  分享页面的链接（如果是登录，不用传入）
 */
@property (nonatomic,copy) NSString *shareURL;
/**
 *  分享的图片的链接（如果是登录，不用传入）
 */
@property (nonatomic,copy) NSString *shareImgUrl;


/**
 * 分享的内容（如果是登录，不用传入）
 */
@property (nonatomic,copy) NSString *shareText;
/**
 *  分享的标题（如果是登录，不用传入）
 */
@property (nonatomic,copy) NSString *shareTitle;

@end


/**
 *  操作完成的回调
 *
   msg:      操作后返回的信息
   type:     按钮的类型
   status:   操作后返回的状态
   infoDic:  社交应用返回的信息
 *
 */
typedef void(^VSocialCompletion) (NSDictionary *infoDic,VSocialActionType type,VSocialActionStatus status,NSString *msg);

#pragma mark --- VSocial 社会化组件

@interface VSocial : NSObject

/**
 *  社会化组件单例
 */
+ (instancetype)manager;


/**
 * 一定要在info.plist的URL Types中设置所有想要集成社交软件的scheme(微信，qq，微博)
 *  注册所有的应用
 */
- (void)regiserSocailApp;

/**
 *  @brief            处理微信/微博/qq通过URL启动App时传递的数据
 *
    application:handleOpenURL:
    application:openURL:options:
    application:openURL:sourceApplication:annotation:

 
 *  @param url        微信/微博/qq启动第三方应用时传递过来的URL
 *  @param compeltion 操作完成的回调
 */
- (void)handleOpenURL:(NSURL *)url withCompeltion:(VSocialCompletion)compeltion;

/**
 *  调用社会化组件
 *
 *  @param req        操作传入的model
 *  @param type       操作的类型
 *  @param compeltion 操作完成的回调
 */
- (void)socialWithReq:(VSocialActionReq *)req withType:(VSocialActionType)type withCompeltion:(VSocialCompletion)compeltion;





@end
