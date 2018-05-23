//
//  JKPhotoTransitionManger.m
//  JKPhotoBrowser
//
//  Created by zhangjie on 2018/5/23.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import "JKPhotoTransitionManger.h"

@implementation JKPhotoTransitionManger



- (JKConfigToInAnimation)inAnimation {
    __weak typeof(self)weakself = self;
    return ^(JKImageBrowserAnimation inAnimation){
        return weakself;
    };
}
- (JKConfigToOutAnimation)outAnimation {
    __weak typeof(self)weakself = self;
    return ^(JKImageBrowserAnimation outAnimation){
        
        return weakself;
    };
}

- (JKConfigToTransionDuration)transitionDuration {
    __weak typeof(self)weakself = self;
    return ^(NSTimeInterval time){
        
        return weakself;
    };
}
- (JKConfigToCancelDrag)cancelDragImageViewAnimation {
    __weak typeof(self)weakself = self;
    return ^(BOOL cancelDrag){
        weakself.transitionSet.cancelDragImageViewAnimation = cancelDrag;
        return weakself;
    };
}

- (JKConfigToOutScaleForDrag)outScaleOfDragImageViewAnimation {
    __weak typeof(self)weakself = self;
    return ^(CGFloat outScaleOfDragImageViewAnimation){
        weakself.transitionSet.outScaleOfDragImageViewAnimation = outScaleOfDragImageViewAnimation;
        return weakself;
    };
}
@end
