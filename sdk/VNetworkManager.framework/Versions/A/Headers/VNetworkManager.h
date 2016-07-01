//
//  VNetworkManager.h
//  VBaseModel
//
//  Created by 蚩尤 on 16/5/19.
//  Copyright © 2016年 lhjzzu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface VNetworkManager : NSObject
/**
 *  单例
 */
+ (instancetype)manager;
/**
 *  请求数据
 *
 *  @param path       接口
 *  @param method     GET/POST
 *  @param paramDic   参数字典
 *  @param completion 请求完成的回调
 */
- (void)v_networkWithPath:(NSString *)path withMethod:(NSString *)method withParamDic:(NSDictionary *)paramDic withCompletion:(void(^)(id responseObjec, BOOL success ,NSError *error))completion;
/**
 *  下载图片
 *
 *  @param url        图片链接
 *  @param completion 请求完成的回调
 */
- (void)v_networkDownImageWithURL:(NSString *)url  withCompletion:(void(^)(UIImage *image ,NSError *error, NSURL *imageURL))completion;

@end
