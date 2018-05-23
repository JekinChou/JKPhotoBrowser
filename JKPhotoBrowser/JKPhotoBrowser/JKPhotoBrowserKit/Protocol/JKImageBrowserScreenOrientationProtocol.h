//
//  JKImageBrowserScreenOrientationProtocol.h
//  JKPhotoBrowser
//
//  Created by zhangjie on 2018/5/23.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKPhotoMacro.h"
@protocol JKImageBrowserScreenOrientationProtocol <NSObject>
@required

/**
 当前视图UI适配的屏幕方向
 */
@property (nonatomic, assign) JKImageBrowserScreenOrientation so_screenOrientation;

/**
 当前视图在竖直屏幕的frame
 */
@property (nonatomic, assign) CGRect so_frameOfVertical;

/**
 当前视图在横向屏幕的frame
 */
@property (nonatomic, assign) CGRect so_frameOfHorizontal;

/**
 更新约束是否完成
 */
@property (nonatomic, assign) BOOL so_isUpdateUICompletely;

- (void)so_setFrameInfoWithSuperViewScreenOrientation:(JKImageBrowserScreenOrientation)screenOrientation superViewSize:(CGSize)size;

- (void)so_updateFrameWithScreenOrientation:(JKImageBrowserScreenOrientation)screenOrientation;

@end
