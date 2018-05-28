//
//  JKPhotoTransitionManger.h
//  JKPhotoBrowser
//
//  Created by zhangjie on 2018/5/23.
//  Copyright © 2018年 zhangjie. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "JKPhotoMacro.h"
#import "JKPhotoTransitionProtocol.h"

@interface JKPhotoTransitionConfig : NSObject

/**
 入场动画类型
 */
@property (nonatomic, assign) JKImageBrowserAnimation inAnimation;

/**
 出场动画类型
 */
@property (nonatomic, assign) JKImageBrowserAnimation outAnimation;
/**
 转场动画持续时间
 */
@property (nonatomic, assign) NSTimeInterval transitionDuration;

/**
 取消拖拽图片的动画效果
 */
@property (nonatomic, assign) BOOL cancelDragImageViewAnimation;

/**
 拖拽图片动效触发出场的比例（拖动距离/屏幕高度 默认0.15）
 */
@property (nonatomic, assign) CGFloat outScaleOfDragImageViewAnimation;



@end
