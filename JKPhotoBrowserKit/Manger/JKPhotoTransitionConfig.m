//
//  JKPhotoTransitionManger.m
//  JKPhotoBrowser
//
//  Created by zhangjie on 2018/5/23.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import "JKPhotoTransitionConfig.h"

@implementation JKPhotoTransitionConfig
    @synthesize cancelDragImageViewAnimation = _cancelDragImageViewAnimation,outScaleOfDragImageViewAnimation = _outScaleOfDragImageViewAnimation,autoCountMaximumZoomScale = _autoCountMaximumZoomScale;
    
    
- (CGFloat)outScaleOfDragImageViewAnimation {
    if(_outScaleOfDragImageViewAnimation<0)return 0;
    return _outScaleOfDragImageViewAnimation;
}
@end
