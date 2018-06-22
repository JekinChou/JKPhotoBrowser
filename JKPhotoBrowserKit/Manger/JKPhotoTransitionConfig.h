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

@interface JKPhotoTransitionConfig : NSObject<JKPhotoTransitionProtocol>

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

@end
