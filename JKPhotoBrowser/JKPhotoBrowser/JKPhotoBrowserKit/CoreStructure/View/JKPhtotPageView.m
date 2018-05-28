//
//  JKPhtotPageView.m
//  JKPhotoBrowser
//
//  Created by zhangjie on 2018/5/24.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import "JKPhtotPageView.h"

@interface JKPhtotPageView ()
@property (nonatomic,strong) UILabel *pageLabel;
@end
@implementation JKPhtotPageView
@synthesize total = _total,currentIndex = _currentIndex;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.pageLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.pageLabel.frame = CGRectMake(0, 10,[UIScreen mainScreen].bounds.size.width , 50);
}



#pragma mark - SET/GET
- (void)setTotal:(NSInteger)total {
    _total = total;
    self.hidden = !total;
    self.pageLabel.text = [NSString stringWithFormat:@"%@/%@",@(self.currentIndex).stringValue,@(self.total).stringValue];
}
- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
     self.pageLabel.text = [NSString stringWithFormat:@"%@/%@",@(self.currentIndex).stringValue,@(self.total).stringValue];
}
- (UILabel *)pageLabel {
    if (!_pageLabel) {
        _pageLabel = [UILabel new];
        _pageLabel.text = @"0/0";
        _pageLabel.textColor = [UIColor whiteColor];
        _pageLabel.font = [UIFont systemFontOfSize:14];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _pageLabel;
}
@end
