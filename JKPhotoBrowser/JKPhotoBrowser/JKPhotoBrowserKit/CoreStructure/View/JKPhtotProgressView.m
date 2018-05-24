//
//  JKPhtotProgressView.m
//  JKPhotoBrowser
//
//  Created by zhangjie on 2018/5/24.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import "JKPhtotProgressView.h"

@implementation JKPhtotProgressView
@synthesize progress = _progress;




#pragma mark - PROTOCOL
- (void)showSuccessful {
    
}

- (void)showFail {
    
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
}
@end
