//
//  JKPhotoBrowserCell.h
//  JKPhotoBrowser
//
//  Created by zhangjie on 2018/5/23.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKPhotoModel.h"
@interface JKPhotoBrowserCell : UICollectionViewCell
@property (nonatomic,strong) id<JKPhotoModel>model;
@end
