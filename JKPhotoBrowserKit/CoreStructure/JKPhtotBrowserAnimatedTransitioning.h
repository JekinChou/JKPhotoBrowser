//
//  JKPhtotBrowserAnimatedTransitioning.h
//  JKPhotoBrowser
//
//  Created by zhangjie on 2018/5/24.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKPhotoBrowser.h"

@interface JKPhtotBrowserAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>
- (void)setInfoWithImageBrowser:(JKPhotoBrowser *)browser;
@end
