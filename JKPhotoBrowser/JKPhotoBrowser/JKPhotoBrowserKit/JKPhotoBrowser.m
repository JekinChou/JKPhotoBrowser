//
//  JKPhotoBrowser.m
//  JKPhotoBrowser
//
//  Created by zhangjie on 2018/5/23.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import "JKPhotoBrowser.h"
#import "JKPhotoBrowserView.h"
static CGFloat _maxDisplaySize = 3500;
static BOOL _showStatusBar = NO;    //改控制器是否需要隐藏状态栏
static BOOL _isControllerPreferredForStatusBar = YES; //状态栏是否是控制器优先
static BOOL _statusBarIsHideBefore = NO;    //状态栏在模态切换之前是否隐藏


@interface JKPhotoBrowser ()<UIViewControllerTransitioningDelegate>
@property (nonatomic,strong) JKPhotoTransitionManger *transitionManger;
@property (nonatomic,strong) JKPhotoBrowserView *browserView;
@end

@implementation JKPhotoBrowser
#pragma mark - init
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];

}


#pragma mark - PUBLICMETHOD
- (void)show {
    
}
- (void)showFromController:(UIViewController *)controller {
    
}
- (void)dismiss {
    
}

#pragma mark - SET/GET

- (JKPhotoTransitionManger *)transitionManger {
    if (!_transitionManger) {
        _transitionManger = [JKPhotoTransitionManger new];
        _transitionManger.transitionSet = self.browserView;
  _transitionManger.outScaleOfDragImageViewAnimation(0.15).transitionDuration(1).cancelDragImageViewAnimation(NO);
    }
    return _transitionManger;
}

+ (CGFloat)maxDisplaySize {
    return _maxDisplaySize;
}

+ (void)setMaxDisplaySize:(CGFloat)maxDisplaySize {
    _maxDisplaySize = maxDisplaySize;
}
+ (BOOL)showStatusBar {
    return _showStatusBar;
}

+ (void)setShowStatusBar:(BOOL)showStatusBar {
    _showStatusBar = showStatusBar;
}

+ (void)setStatusBarIsHideBefore:(BOOL)statusBarIsHideBefore {
    _statusBarIsHideBefore = statusBarIsHideBefore;
}

+ (BOOL)statusBarIsHideBefore {
    return _statusBarIsHideBefore;
}

+ (BOOL)isControllerPreferredForStatusBar {
    return _isControllerPreferredForStatusBar;
}

+ (void)setIsControllerPreferredForStatusBar:(BOOL)isControllerPreferredForStatusBar {
    _isControllerPreferredForStatusBar = isControllerPreferredForStatusBar;
}

@end

