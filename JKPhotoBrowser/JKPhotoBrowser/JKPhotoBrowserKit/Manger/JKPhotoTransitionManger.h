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
@class JKPhotoTransitionManger;
typedef JKPhotoTransitionManger *(^JKConfigToTransionDuration)(NSTimeInterval time);
typedef JKPhotoTransitionManger *(^JKConfigToCancelDrag)(BOOL cancelDrag);
typedef JKPhotoTransitionManger *(^JKConfigToOutScaleForDrag)(CGFloat outScaleOfDragImageViewAnimation);
typedef JKPhotoTransitionManger *(^JKConfigToInAnimation)(JKImageBrowserAnimation inAnimation);
typedef JKPhotoTransitionManger *(^JKConfigToOutAnimation)(JKImageBrowserAnimation outAnimation);
@interface JKPhotoTransitionManger : NSObject
@property (nonatomic,weak) id<JKPhotoTransitionProtocol> transitionSet;
/**
 转场动画持续时间
 */
@property (nonatomic,copy,readonly) JKConfigToTransionDuration transitionDuration;

/**
 取消拖拽图片的动画效果
 */
@property (nonatomic,copy,readonly)JKConfigToCancelDrag cancelDragImageViewAnimation;

/**
 拖拽图片动效触发出场的比例（拖动距离/屏幕高度 默认0.15）
 */
@property (nonatomic,copy,readonly) JKConfigToOutScaleForDrag outScaleOfDragImageViewAnimation;

/**
 入场动画类型
 */
@property (nonatomic,copy,readonly)JKConfigToInAnimation inAnimation;
/**
 出场动画类型
 */
@property (nonatomic,copy,readonly)JKConfigToOutAnimation outAnimation;

@end
