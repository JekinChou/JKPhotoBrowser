//
//  JKPhotoBrowserContentView.m
//  JKPhotoBrowser
//
//  Created by zhangjie on 2018/6/19.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import "JKPhotoBrowserTopView.h"

@implementation JKPhotoBrowserTopView
- (instancetype)init {
    if (self= [super init]) {
        [self setupUI];
    }
    return self;
}
- (void)actionForButton:(UIButton *)button {
    if (_btnDidClick) {
        self.btnDidClick();
    }
}
- (void)setupUI {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake( [UIScreen mainScreen].bounds.size.width-50,10, 50, 50);
    [button setImage:[UIImage imageNamed:@"picture_browser_download_highlight"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionForButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}
@end
