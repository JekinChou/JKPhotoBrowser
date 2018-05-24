//
//  JKPhotoBrowser.m
//  JKPhotoBrowser
//
//  Created by zhangjie on 2018/5/23.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import "JKPhotoBrowser.h"
#import "JKPhotoBrowserView.h"
#import "JKPhtotPageView.h"
#import "JKPhtotBrowserAnimatedTransitioning.h"
#import "JKPhtotProgressView.h"
#import "JKPhotoBrowserViewFlowLayout.h"
static CGFloat _maxDisplaySize = 3500;
static BOOL _showStatusBar = NO;    //改控制器是否需要隐藏状态栏
static BOOL _isControllerPreferredForStatusBar = YES; //状态栏是否是控制器优先
static BOOL _statusBarIsHideBefore = NO;    //状态栏在模态切换之前是否隐藏


@interface JKPhotoBrowser ()<UIViewControllerTransitioningDelegate,
JKPhotoBrowserViewDataSource,
JKPhotoBrowserViewDelegate> {
    UIInterfaceOrientationMask _supportAutorotateTypes;
    UIWindow *_window;
    BOOL _isDealViewDidAppear;
    JKPhtotBrowserAnimatedTransitioning *_animatedTransitioningManager;
}
@property (nonatomic,strong) JKPhotoTransitionManger *transitionManger;
@property (nonatomic,strong) JKPhotoBrowserView *browserView;
@property (class, assign) BOOL isControllerPreferredForStatusBar;
@end

@implementation JKPhotoBrowser
#pragma mark - init
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
        [self setConfig];
        [self getStatusBarConfigByInfoPlist];
    }
    return self;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (BOOL)shouldAutorotate {
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self registerNotification];
    if (_isControllerPreferredForStatusBar && !_showStatusBar && !_statusBarIsHideBefore) {
        [self configStatusBarHide:YES];
    }
    _statusBarIsHideBefore = [UIApplication sharedApplication].statusBarHidden;
    if (!_isDealViewDidAppear) {
        [self setConfigInfoToChildModules];
        [self.view addSubview:self.browserView];
        self.browserView.alpha = 0;
        [self.browserView scrollToPageWithIndex:self.currentIndex];
        _isDealViewDidAppear = YES;
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.browserView.alpha = 1;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_isControllerPreferredForStatusBar && !_showStatusBar && !_statusBarIsHideBefore) {
        [self configStatusBarHide:NO];
    }
}

#pragma mark - PRIVATEMETHOD
- (void)setConfig {
    _space = 18;
    _autoCountMaximumZoomScale = YES;
    _animatedTransitioningManager = [JKPhtotBrowserAnimatedTransitioning new];
    _transitionDuration = 0.35;
    _outScaleOfDragImageViewAnimation = 0.15;
    _inAnimation = JKImageBrowserAnimationMove;
    _outAnimation = JKImageBrowserAnimationMove;
    _verticalScreenImageViewFillType = JKImageBrowserImageViewFillTypeFullWidth;
    _horizontalScreenImageViewFillType = JKImageBrowserImageViewFillTypeFullWidth;
}
- (void)setConfigInfoToChildModules {
    self.browserView.autoCountMaximumZoomScale = _autoCountMaximumZoomScale;
    self.browserView.verticalScreenImageViewFillType = self.verticalScreenImageViewFillType;
    self.browserView.horizontalScreenImageViewFillType = self.horizontalScreenImageViewFillType;
    ((JKPhotoBrowserViewFlowLayout *)self.browserView.collectionViewLayout).space = self.space;
}
- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phtotBrowserChangeAlphaWithNotification:) name:JKPhtotBrowserChangeAlphaNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phtotBrowserDidShowWithNotification:) name:JKPhtotBrowserViewDidShowWithTimeIntervalNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phtotBrowserWillShowWithNotification:) name:JKPhtotBrowserViewWillShowWithTimeIntervalNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(phtotBrowserShouldHideWithNotification:) name:JKPhotoBrowserShouldHideNotification object:nil];
}
// !!!:notification
- (void)phtotBrowserChangeAlphaWithNotification:(NSNotification *)notification {
    CGFloat scale = [notification.userInfo[JKPhtotBrowserChangeAlphaNotification] floatValue];
    self.view.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:scale];
}
- (void)phtotBrowserWillShowWithNotification:(NSNotification *)notification {
    CGFloat timeInterval = [notification.userInfo[JKPhtotBrowserViewWillShowWithTimeIntervalNotification] floatValue];
    [UIView animateWithDuration:timeInterval animations:^{
        self.view.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:1];
    }];
}
- (void)phtotBrowserDidShowWithNotification:(NSNotification *)notification {
    self.view.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:1];
    if (self.browserView.isHidden) self.browserView.hidden = NO;
}
- (void)phtotBrowserShouldHideWithNotification:(NSNotification *)notification {
     if (!self.browserView.isHidden)  self.browserView.hidden = YES;
}

//控制状态栏
- (void)configStatusBarHide:(BOOL)hiden {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    statusBar.alpha = !hiden;
}
- (void)getStatusBarConfigByInfoPlist {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:bundlePath];
    id value = dict[@"UIViewControllerBasedStatusBarAppearance"];
    if (value) {
        _isControllerPreferredForStatusBar = [value boolValue];
    } else {
        _isControllerPreferredForStatusBar = YES;
    }
}
#pragma mark - PUBLICMETHOD
- (void)show {
    
}
- (void)showFromController:(UIViewController *)controller {
    if (self.dataArray) {
        if (!self.dataArray.count) {
            
            return;
        }
    } else if (_dataSource && [_dataSource respondsToSelector:@selector(numberInPhotoBrowser:)]) {
        if (![_dataSource numberInPhotoBrowser:self]) {
        
            return;
        }
    } else {
        return;
    }
    [controller presentViewController:self animated:YES completion:nil];
}
- (void)dismiss {
   [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    [_animatedTransitioningManager setInfoWithImageBrowser:self];
    return _animatedTransitioningManager;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    [_animatedTransitioningManager setInfoWithImageBrowser:self];
    return _animatedTransitioningManager;
}


#pragma mark - JKPhotoBrowserViewDataSource
- (NSInteger)numberOfTotalImageInPhotoBrowser:(JKPhotoBrowserView *)browserView {
    NSInteger index = [self.dataSource numberInPhotoBrowser:self];
    if(index == 0)index = self.dataArray.count;
    return index;
}

/**
 返回下标对应的模型
 
 @param browserView browserView description
 @param index index description
 @return return value description
 */
- (id<JKPhotoModel>)photoBrowserView:(JKPhotoBrowserView *)browserView itemForCellAtIndex:(NSInteger)index {
    if ([self.dataSource respondsToSelector:@selector(photoBrowser:modelForCellAtIndex:)]) {
        return [self.dataSource photoBrowser:self modelForCellAtIndex:index];
    }else if (self.dataArray.count>0){
        return self.dataArray[index];
    }
    return nil;
}

#pragma mark - JKPhotoBrowserViewDelegate
- (void)photoBrowserView:(JKPhotoBrowserView *)browserView didScrollToIndex:(NSInteger)index {
    _currentIndex = index;
    if ([self.delegate respondsToSelector:@selector(photoBrowser:didScrollToIndex:)]) {
        [self.delegate photoBrowser:self didScrollToIndex:index];
    }
}

- (void)photoBrowserView:(JKPhotoBrowserView *)browserView longPressBegin:(UILongPressGestureRecognizer *)gesture index:(NSInteger)index {
    
}
- (void)photoBrowserApplyForHiddenWithView:(JKPhotoBrowserView *)view {
    [self dismiss];
}

#pragma mark - SET/GET
- (UIView<JKPhotoBrowserStateProtocol> *)stateView {
    if (!_stateView) {
        _stateView = [JKPhtotProgressView new];
    }
    return _stateView;
}
- (UIView<JKPhotoIndexPage> *)pageView {
    if (!_pageView) {
        _pageView = [JKPhtotPageView new];
    }
    return _pageView;
}
- (JKPhotoBrowserView *)browserView {
    if (!_browserView) {
        _browserView = [[JKPhotoBrowserView alloc]initWithFrame:self.view.bounds collectionViewLayout:[JKPhotoBrowserViewFlowLayout new]];
        _browserView.backgroundColor = [UIColor blackColor];
        _browserView.jk_dataSource = self;
        _browserView.jk_delegate = self;
    }
    return _browserView;
}
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

