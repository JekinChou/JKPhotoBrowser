//
//  JKPhotoBrowserDataSouce.h
//  JKPhotoBrowser
//
//  Created by zhangjie on 2018/5/23.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKPhotoModel.h"
@class JKPhotoBrowser;
@protocol JKPhotoBrowserDataSouce <NSObject>
@required
/**
 返回点击的那个 UIImageView（用于做 JKImageBrowserAnimationMove 类型动效）
 
 @param imageBrowser 当前图片浏览器
 @return 点击的图片视图
 */
- (UIImageView * _Nullable)imageViewOfTouchForImageBrowser:(JKPhotoBrowser *)imageBrowser;

/**
 配置图片的数量
 
 @param imageBrowser 当前图片浏览器
 @return 图片数量
 */
- (NSInteger)numberInYBImageBrowser:(JKPhotoBrowser *)imageBrowser;

/**
 返回当前 index 图片对应的数据模型
 
 @param imageBrowser 当前图片浏览器
 @param index 当前下标
 @return 数据模型
 */
- (id<JKPhotoModel>)yBImageBrowser:(JKPhotoBrowser *)imageBrowser modelForCellAtIndex:(NSInteger)index;
@end
