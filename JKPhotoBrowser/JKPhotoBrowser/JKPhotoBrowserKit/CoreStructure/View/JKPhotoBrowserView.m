//
//  JKPhotoBrowserView.m
//  JKPhotoBrowser
//
//  Created by zhangjie on 2018/5/23.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import "JKPhotoBrowserView.h"
#import "JKPhotoBrowserCell.h"
static NSString *const JKPhotoBrowserCellIdentifier = @"JKPhotoBrowserCellIdentifier";

@interface JKPhotoBrowserView ()<UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
JKPhotoBrowserCellDelegate,
UIScrollViewDelegate>
@end

@implementation JKPhotoBrowserView
@synthesize cancelDragImageViewAnimation = _cancelDragImageViewAnimation,outScaleOfDragImageViewAnimation = _outScaleOfDragImageViewAnimation,autoCountMaximumZoomScale = _autoCountMaximumZoomScale;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.backgroundColor = [UIColor blueColor];
        [self registerClass:JKPhotoBrowserCell.class forCellWithReuseIdentifier:JKPhotoBrowserCellIdentifier];
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.alwaysBounceVertical = NO;
        self.delegate = self;
        self.dataSource = self;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}

#pragma mark - PRIVATEMETHOD
- (void)scrollToPageWithIndex:(NSInteger)index {
    if (index >= [self collectionView:self numberOfItemsInSection:0])return;
    self.contentOffset = CGPointMake(self.bounds.size.width * index, 0);
}


#pragma mark - JKPhotoBrowserCellDelegate
- (void)photoBrowserCell:(JKPhotoBrowserCell *)cell longPressBegin:(UILongPressGestureRecognizer *)gesture {
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    if ([self.jk_delegate respondsToSelector:@selector(photoBrowserView:longPressBegin:index:)]) {
        [self.jk_delegate photoBrowserView:self longPressBegin:gesture index:indexPath.row];
    }
}
- (void)photoBrowserApplyForHiddenWithCell:(JKPhotoBrowserCell *)cell {
    if ([self.jk_delegate respondsToSelector:@selector(photoBrowserApplyForHiddenWithView:)]) {
        [self.jk_delegate photoBrowserApplyForHiddenWithView:self];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat indexF = (scrollView.contentOffset.x / scrollView.bounds.size.width);
    NSUInteger index = (NSUInteger)(indexF + 0.5);
    if (index > [self collectionView:self numberOfItemsInSection:0]) return;
    if (self.currentIndex != index) {
        _currentIndex = index;
        if (self.jk_delegate && [self.jk_delegate respondsToSelector:@selector(photoBrowserView:didScrollToIndex:)]) {
            [self.jk_delegate photoBrowserView:self didScrollToIndex:self.currentIndex];
        }
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSArray<JKPhotoBrowserCell *>* array = (NSArray<JKPhotoBrowserCell *>*)[self visibleCells];
//    for (YBImageBrowserCell *cell in array) {
//        [cell reDownloadImageUrl];
//    }
}


#pragma mark -  UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.jk_dataSource numberOfTotalImageInPhotoBrowser:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JKPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JKPhotoBrowserCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.cancelDragImageViewAnimation = self.cancelDragImageViewAnimation;
    cell.outScaleOfDragImageViewAnimation = self.outScaleOfDragImageViewAnimation;
    cell.autoCountMaximumZoomScale = self.autoCountMaximumZoomScale;
    cell.verticalScreenImageViewFillType = self.verticalScreenImageViewFillType;
    cell.horizontalScreenImageViewFillType = self.horizontalScreenImageViewFillType;
    if ([self.jk_dataSource respondsToSelector:@selector(photoBrowserView:itemForCellAtIndex:)]) {
        cell.model = [self.jk_dataSource photoBrowserView:self itemForCellAtIndex:indexPath.row];
    }else {
        cell.model = nil;
    }
    
    return cell;
}




@end
