//
//  JKPhotoModel.h
//  JKPhotoBrowser
//
//  Created by zhangjie on 2018/5/23.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYImage.h>
NS_ASSUME_NONNULL_BEGIN
typedef void(^JKWebImageProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);
typedef NS_ENUM(NSInteger,JKDownLoadState){
   JKDownLoadStateSuccessful,//下载成功
   JKDownLoadStateFail,//下载失败
   JKDownLoadStateUnderway,//下载中
};
@protocol JKPhotoModel <NSObject>
/**
 本地图片
  
 */
@property (nonatomic,strong,nullable)UIImage *localImage;

/**
 网络图片 url
 （setUrlWithDownloadInAdvance: 设置 url 的时候异步预下载）
 */
@property(nonatomic,strong,nullable)NSURL *url;
//下载进度,可用kvo监听
@property (nonatomic,assign) CGFloat progress;
//下载状态
@property (nonatomic,assign) JKDownLoadState downState;
/**
 下载网络图片

 @param url url description
 @param progress 进度(0.00)
 @param successful 成功的回调
 @param error 失败的回调
 */
- (void)setUrlWithDownloadInAdvance:(NSURL *)url progress:(JKWebImageProgressBlock)progress successful:(os_block_t)successful fail:(void(^)(NSError *))error;




/**
 本地 gif 名字
 （不带后缀）
 */
@property (nonatomic,copy,nullable) NSString *gifName;

/**
 gif 转换图
 */
@property (nonatomic,strong,nullable) YYImage *animatedImage;

/**
 最大缩放值 默认4
 （若 JKImageBrowser 的 autoCountMaximumZoomScale 属性为 NO 有效）
 */
@property (nonatomic, assign) CGFloat maximumZoomScale;

/**
 缩略图 (当网络加载时候的占位图)
 */
@property (nonatomic,strong,nullable) UIImage *briefImage;

/**
 下载错误视图
 */
@property (nonatomic,strong,nullable) UIImage *errorImage;

@end
NS_ASSUME_NONNULL_END
