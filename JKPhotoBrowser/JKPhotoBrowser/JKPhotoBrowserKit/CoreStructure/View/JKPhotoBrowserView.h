//
//  JKPhotoBrowserView.h
//  JKPhotoBrowser
//
//  Created by zhangjie on 2018/5/23.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKPhotoModel.h"
#import "JKPhotoTransitionManger.h"
#import "JKPhotoTransitionProtocol.h"
#import "JKPhtotProgressView.h"
@class JKPhotoBrowserView;
@protocol JKPhotoBrowserViewDelegate<NSObject>
@optional
/**
 滚动到当前index

 @param browserView browserView description
 @param index index description
 */
- (void)photoBrowserView:(JKPhotoBrowserView *)browserView didScrollToIndex:(NSInteger)index;

/**
 长按当前图片回调

 @param browserView browserView description
 @param gesture gesture description
 @param index index description
 */
- (void)photoBrowserView:(JKPhotoBrowserView *)browserView longPressBegin:(UILongPressGestureRecognizer *)gesture index:(NSInteger)index;

/**
 单点击回调

 @param browserView browserView description
 @param tapGesture tapGesture description
 @param index index description
 */
- (void)photoBrowserView:(JKPhotoBrowserView *)browserView singleTapWithGesture:(UITapGestureRecognizer *)tapGesture index:(NSInteger)index;

@end

@protocol JKPhotoBrowserViewDataSource <NSObject>

@required
/**
 图片总数

 @param browserView browserView description
 @return return value description
 */
- (NSInteger)numberOfTotalImageInPhotoBrowser:(JKPhotoBrowserView *)browserView;

/**
 返回下标对应的模型

 @param browserView browserView description
 @param index index description
 @return return value description
 */
- (id<JKPhotoModel>)photoBrowserView:(JKPhotoBrowserView *)browserView itemForCellAtIndex:(NSInteger)index;
@end
@interface JKPhotoBrowserView : UICollectionView <JKPhotoTransitionProtocol>
@property (nonatomic,weak) id<JKPhotoBrowserViewDelegate>jk_delegate;
@property (nonatomic,weak) id<JKPhotoBrowserViewDataSource> jk_dataSource;
@property (nonatomic,assign,readonly) NSInteger currentIndex;
@property (nonatomic,copy,readwrite) UIView<JKPhotoBrowserStateProtocol> *stateView;
@property (nonatomic, assign) JKImageBrowserImageViewFillType verticalScreenImageViewFillType;

- (void)scrollToPageWithIndex:(NSInteger)index;

@end
