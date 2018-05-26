//
//  JKPhtotProgressView.m
//  JKPhotoBrowser
//
//  Created by zhangjie on 2018/5/24.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import "JKPhtotProgressView.h"

@interface JKPhtotProgressView()
// 外界圆形
@property (nonatomic, strong) CAShapeLayer *circleLayer;
// 内部扇形
@property (nonatomic, strong) CAShapeLayer *fanshapedLayer;
// 错误
@property (nonatomic, strong) CAShapeLayer *errorLayer;
@end

@implementation JKPhtotProgressView
@synthesize progress = _progress;


- (instancetype)initWithFrame:(CGRect)frame {
   
    if ( self = [super initWithFrame:frame]) {
        CGRect rect = self.frame;
        rect.size = CGSizeMake(50, 50);
        self.frame = rect;
        [self setupUI];
    }
    return self;
}
- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.strokeColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8].CGColor;
    circleLayer.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    circleLayer.path = [self circlePath].CGPath;
    [self.layer addSublayer:circleLayer];
    self.circleLayer = circleLayer;
    
    CAShapeLayer *fanshapedLayer = [CAShapeLayer layer];
    fanshapedLayer.fillColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8].CGColor;
    [self.layer addSublayer:fanshapedLayer];
    self.fanshapedLayer = fanshapedLayer;
    
    CAShapeLayer *errorLayer = [CAShapeLayer layer];
    errorLayer.frame = self.bounds;
    // 旋转 45 度
    errorLayer.affineTransform = CGAffineTransformMakeRotation(M_PI_4);
    errorLayer.fillColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8].CGColor;
    errorLayer.path = [self errorPath].CGPath;
    errorLayer.hidden = YES;
    [self.layer addSublayer:errorLayer];
    self.errorLayer = errorLayer;
}

#pragma mark - PRIVATEMETHOD
- (void)updateProgrAPsLayer {
    self.errorLayer.hidden = YES;
    self.fanshapedLayer.hidden = NO;
    self.fanshapedLayer.path = [self pathForProgrAPs:self.progress].CGPath;
}
- (UIBezierPath *)errorPath {
    CGFloat width = 30;
    CGFloat height = 5;
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:CGRectMake(self.frame.size.width * 0.5 - height * 0.5, (self.frame.size.width - width) * 0.5, height, width)];
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRect:CGRectMake((self.frame.size.width - width) * 0.5, self.frame.size.width * 0.5 - height * 0.5, width, height)];
    [path2 appendPath:path1];
    return path2;
}
- (UIBezierPath *)circlePath {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5) radius:25 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    path.lineWidth = 1;
    return path;
}

- (UIBezierPath *)pathForProgrAPs:(CGFloat)progrAPs {
    CGPoint center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    CGFloat radius = self.frame.size.height * 0.5 - 2.5;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: center];
    [path addLineToPoint:CGPointMake(self.frame.size.width * 0.5, center.y - radius)];
    [path addArcWithCenter:center radius: radius startAngle: -M_PI / 2 endAngle: -M_PI / 2 + M_PI * 2 * progrAPs clockwise:YES];
    [path closePath];
    path.lineWidth = 1;
    return path;
}
#pragma mark - PROTOCOL
- (void)showSuccessful {
    self.hidden = YES;
}

- (void)showFail {
    self.errorLayer.hidden = NO;
    self.fanshapedLayer.hidden = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
    });
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self updateProgrAPsLayer];
}
@end
