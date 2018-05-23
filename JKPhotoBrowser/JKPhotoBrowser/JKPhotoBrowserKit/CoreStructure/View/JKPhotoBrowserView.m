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

@interface JKPhotoBrowserView ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@end

@implementation JKPhotoBrowserView
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.backgroundColor = [UIColor clearColor];
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

#pragma mark -  UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.jk_dataSource numberOfTotalImageInPhotoBrowser:self];
}



@end
