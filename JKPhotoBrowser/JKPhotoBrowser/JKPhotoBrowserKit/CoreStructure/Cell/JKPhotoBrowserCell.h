//
//  JKPhotoBrowserCell.h
//  JKPhotoBrowser
//
//  Created by zhangjie on 2018/5/23.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKPhotoModel.h"
#import "JKPhotoTransitionProtocol.h"
#import "JKPhotoBrowserStateProtocol.h"
#import "JKPhotoBrowser.h"
@class JKPhotoBrowserCell;
@protocol JKPhotoBrowserCellDelegate <NSObject>
//长按触发
- (void)photoBrowserCell:(JKPhotoBrowserCell *)cell longPressBegin:(UILongPressGestureRecognizer *)gesture;
//单点手势触发
- (void)photoBrowserCell:(JKPhotoBrowserCell *)cell singleTapWithGesture:(UITapGestureRecognizer *)tapGesture;
@end

@interface JKPhotoBrowserCell : UICollectionViewCell<
JKPhotoTransitionProtocol>
@property (nonatomic,strong) id<JKPhotoModel>model;
/**
 状态view
 */
@property (nonatomic,assign,class) UIView<JKPhotoBrowserStateProtocol> *progressView;
@property (nonatomic,weak) id<JKPhotoBrowserCellDelegate> delegate;
@property (nonatomic,strong,readonly) YYAnimatedImageView *imageView;
@property (nonatomic, strong, readonly) YYAnimatedImageView *animateImageView;
@property (nonatomic, assign) JKImageBrowserImageViewFillType verticalScreenImageViewFillType;

+ (void)countWithContainerSize:(CGSize)containerSize image:(id)image verticalFillType:(JKImageBrowserImageViewFillType)verticalFillType completed:(void(^)(CGRect imageFrame, CGSize contentSize, CGFloat minimumZoomScale, CGFloat maximumZoomScale))completed;
@end
