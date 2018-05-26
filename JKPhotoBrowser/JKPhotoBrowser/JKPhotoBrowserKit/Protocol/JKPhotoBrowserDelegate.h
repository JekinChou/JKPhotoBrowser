//
//  JKPhotoBrowserDelegate.h
//  JKPhotoBrowser
//
//  Created by zhangjie on 2018/5/23.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JKPhotoBrowser;
//图片浏览器的一般事件回调
@protocol JKPhotoBrowserDelegate <NSObject>
@optional
/**
 翻页

 @param browser browser description
 @param index index description
 */
- (void)photoBrowser:(JKPhotoBrowser *)browser didScrollToIndex:(NSInteger)index;

/**
 长按

 @param browser browser description
 @param index index description
 */
- (void)photoBrowser:(JKPhotoBrowser *)browser longPressWithIndex:(NSInteger)index;

/**
 点按

 @param browser browser description
 @param index index description
 */
- (void)photoBrowser:(JKPhotoBrowser *)browser clickWithIndex:(NSInteger)index;
@end
