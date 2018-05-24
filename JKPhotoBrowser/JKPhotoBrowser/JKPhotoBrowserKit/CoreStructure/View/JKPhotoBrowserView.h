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
@class JKPhotoBrowserView;
@protocol JKPhotoBrowserViewDelegate<NSObject>

/**
 滚动到当前index

 @param browserView browserView description
 @param index index description
 */
- (void)photoBrowserView:(JKPhotoBrowserView *)browserView didScrollToIndex:(NSInteger)index;

- (void)photoBrowserView:(JKPhotoBrowserView *)browserView longPressBegin:(UILongPressGestureRecognizer *)gesture index:(NSInteger)index;
- (void)photoBrowserApplyForHiddenWithView:(JKPhotoBrowserView *)view;

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

@property (nonatomic, assign) JKImageBrowserImageViewFillType verticalScreenImageViewFillType;
@property (nonatomic, assign) JKImageBrowserImageViewFillType horizontalScreenImageViewFillType;

- (void)scrollToPageWithIndex:(NSInteger)index;

@end
