//
//  JKPhotoIndexPage.h
//  JKPhotoBrowser
//
//  Created by zhangjie on 2018/5/23.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol JKPhotoIndexPage <NSObject>
@property (nonatomic,assign) NSInteger total;
@property (nonatomic,assign) NSInteger currentIndex;
@end
