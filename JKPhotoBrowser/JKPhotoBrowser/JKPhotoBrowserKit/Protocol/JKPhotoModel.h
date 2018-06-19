//
//  JKPhotoModel.h
//  JKPhotoBrowser
//
//  Created by zhangjie on 2018/5/23.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYImage/YYImage.h>
NS_ASSUME_NONNULL_BEGIN
typedef void(^JKWebImageProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);
typedef NS_ENUM(NSInteger,JKDownLoadState){
    JKDownLoadStateUnLoad = 0,//未下载
   JKDownLoadStateFail,//下载失败
   JKDownLoadStateUnderway,//下载中
   
};
@protocol JKPhotoModel <NSObject>
/**
 本地图片 支持gif显示
 */
@property (nonatomic,strong,nullable)UIImage *localImage;

/**
 网络图片 url
 （setUrlWithDownloadInAdvance: 设置 url 的时候异步预下载）
 */
@property(nonatomic,strong,nullable)NSURL *url;

/**
 进度回调
 */
@property (nonatomic,copy,nullable) void(^progressCallBack)(CGFloat progress);

//下载状态
@property (nonatomic,assign) JKDownLoadState downState;
/**
 下载网络图片

 @param url url description
 @param progress 进度(0.00)
 @param successful 成功的回调
 @param error 失败的回调
 */
- (void)setUrlWithDownloadInAdvance:(NSURL *)url progress:(JKWebImageProgressBlock)progress successful:(os_block_t)successful fail:(void(^)(NSError *error))error;



/**
 来源图片视图
 （用于做动效）
 */
@property (nonatomic, strong, nullable) UIImageView *sourceImageView;

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
