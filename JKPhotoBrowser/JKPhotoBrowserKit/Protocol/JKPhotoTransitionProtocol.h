//
//  JKPhotoTransitionProtocol.h
//  JKPhotoBrowser
//
//  Created by zhangjie on 2018/5/23.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JKPhotoTransitionProtocol <NSObject>
@property (nonatomic, assign) BOOL cancelDragImageViewAnimation;
@property (nonatomic, assign) CGFloat outScaleOfDragImageViewAnimation;
@property (nonatomic, assign) BOOL autoCountMaximumZoomScale;
@end
