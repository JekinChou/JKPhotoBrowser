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
static BOOL _showStatusBar = NO;    //改控制器是否需要隐藏状态栏
static BOOL _isControllerPreferredForStatusBar = YES; //状态栏是否是控制器优先
static BOOL _statusBarIsHideBefore = NO;    //状态栏在模态切换之前是否隐藏


@interface JKPhotoBrowser ()<UIViewControllerTransitioningDelegate,
JKPhotoBrowserViewDataSource,
JKPhotoBrowserViewDelegate> {
    UIInterfaceOrientationMask _supportAutorotateTypes;
    UIWindow *_window;
    JKPhtotBrowserAnimatedTransitioning *_animatedTransitioningManager;
}
@property (nonatomic,strong) JKPhotoTransitionConfig *transitionConfig;
@property (nonatomic,strong) JKPhotoBrowserView *browserView;
@property (class, assign) BOOL isControllerPreferredForStatusBar;
@end

@implementation JKPhotoBrowser
@synthesize dataArray = _dataArray;

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
    [self setConfigInfoToChildModules];
    [self.view addSubview:self.browserView];
    [self.view addSubview:self.pageView];
    if (self.topFunctionView)[self.view addSubview:self.topFunctionView];
    if (self.bottomFunctionView)[self.view addSubview:self.bottomFunctionView];
    self.browserView.alpha = 0;
    self.pageView.currentIndex = self.currentIndex+1;
    [self.browserView scrollToPageWithIndex:self.currentIndex];
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
    _customGestureDeal = YES;
    _autoCountMaximumZoomScale = YES;
    _animatedTransitioningManager = [JKPhtotBrowserAnimatedTransitioning new];
    _screenImageViewFillType = JKImageBrowserImageViewFillTypeFullWidth;
}
- (void)setConfigInfoToChildModules {
    self.browserView.autoCountMaximumZoomScale = _autoCountMaximumZoomScale;
    self.browserView.screenImageViewFillType = self.screenImageViewFillType;
    ((JKPhotoBrowserViewFlowLayout *)self.browserView.collectionViewLayout).space = self.space;
}
- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phtotBrowserChangeAlphaWithNotification:) name:JKPhtotBrowserChangeAlphaNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phtotBrowserDidShowWithNotification:) name:JKPhtotBrowserViewDidShowWithTimeIntervalNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phtotBrowserWillShowWithNotification:) name:JKPhtotBrowserViewWillShowWithTimeIntervalNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(phtotBrowserShouldHideWithNotification:) name:JKPhotoBrowserShouldHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismiss) name:JKPhtotBrowserWillDismissNotification object:nil];
}
// !!!:notification
- (void)phtotBrowserChangeAlphaWithNotification:(NSNotification *)notification {
    CGFloat scale = [notification.userInfo[JKPhtotBrowserChangeAlphaNotification] floatValue];
    self.view.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:scale];
    self.pageView.alpha = self.bottomFunctionView.alpha = self.topFunctionView.alpha = scale;
    
}
- (void)phtotBrowserWillShowWithNotification:(NSNotification *)notification {
    CGFloat timeInterval = [notification.userInfo[JKPhtotBrowserViewWillShowWithTimeIntervalNotification] floatValue];
    [UIView animateWithDuration:timeInterval animations:^{
        self.view.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:1];
        self.bottomFunctionView.alpha = self.topFunctionView.alpha = self.pageView.alpha = 1;
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
    [self showFromController:[UIApplication sharedApplication].keyWindow.rootViewController];
}
- (void)showFromController:(UIViewController *)controller {
    if (self.dataArray) {
        if (!self.dataArray.count)return;
    } else if (_dataSource && [_dataSource respondsToSelector:@selector(numberInPhotoBrowser:)]) {
        if (![_dataSource numberInPhotoBrowser:self]) return;
    } else{
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
    if (self.dataArray.count>0){
        self.pageView.total = self.dataArray.count;
        return self.dataArray.count;
    }
    NSInteger number = [self.dataSource numberInPhotoBrowser:self];
    self.pageView.total = number;
    if (!_dataArray){
        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:number];
        for (int i = 0; i<number; i++) {
            id<JKPhotoModel> model = [self.dataSource photoBrowser:self modelForCellAtIndex:i];
            [arrayM addObject:model];
        }
        self.dataArray = arrayM.copy;
    }
    return number;
}

/**
 返回下标对应的模型
 
 @param browserView browserView description
 @param index index description
 @return return value description
 */
- (id<JKPhotoModel>)photoBrowserView:(JKPhotoBrowserView *)browserView itemForCellAtIndex:(NSInteger)index {
    if (self.dataArray.count>0)return self.dataArray[index];
    if ([self.dataSource respondsToSelector:@selector(photoBrowser:modelForCellAtIndex:)]){
        id<JKPhotoModel>model = [self.dataSource photoBrowser:self modelForCellAtIndex:index];
        return model;
    }
    return nil;
}

#pragma mark - JKPhotoBrowserViewDelegate
- (void)photoBrowserView:(JKPhotoBrowserView *)browserView didScrollToIndex:(NSInteger)index {
    _currentIndex = index;
    if ([self.delegate respondsToSelector:@selector(photoBrowser:didScrollToIndex:)]) {
        [self.delegate photoBrowser:self didScrollToIndex:index];
    }
    self.pageView.currentIndex = index+1;
}

- (void)photoBrowserView:(JKPhotoBrowserView *)browserView longPressBegin:(UILongPressGestureRecognizer *)gesture index:(NSInteger)index {
    if (!self.customGestureDeal) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(photoBrowser:longPressWithIndex:)]) {
        [self.delegate photoBrowser:self longPressWithIndex:index];
    }
}
- (void)photoBrowserView:(JKPhotoBrowserView *)browserView singleTapWithGesture:(UITapGestureRecognizer *)tapGesture index:(NSInteger)index {
    if (!self.customGestureDeal) {
        [self dismiss];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(photoBrowser:clickWithIndex:)]) {
        [self.delegate photoBrowser:self clickWithIndex:index];
    }
}


#pragma mark - SET/GET
- (void)setStateView:(UIView<JKPhotoBrowserStateProtocol,NSCopying> *)stateView {
    [self.browserView setStateView:stateView];
}

- (void)setTopFunctionView:(UIView *)topFunctionView {
    _topFunctionView = topFunctionView;
    CGRect rect = topFunctionView.frame;
    rect.origin = CGPointZero;
    _topFunctionView.frame = rect;
}

- (void)setBottomFunctionView:(UIView *)bottomFunctionView {
    _bottomFunctionView = bottomFunctionView;
    CGRect rect = bottomFunctionView.frame;
    rect.origin = CGPointMake(0, [UIScreen mainScreen].bounds.size.height - rect.size.height);
    _bottomFunctionView.frame = rect;
}
- (UIView<JKPhotoIndexPage> *)pageView {
    if (!_pageView) {
        _pageView = [JKPhtotPageView new];
        _pageView.frame = [UIScreen mainScreen].bounds;
        _pageView.userInteractionEnabled = NO;
    }
    return _pageView;
}
- (JKPhotoBrowserView *)browserView {
    if (!_browserView) {
        _browserView = [[JKPhotoBrowserView alloc]initWithFrame:self.view.bounds collectionViewLayout:[JKPhotoBrowserViewFlowLayout new]];
        _browserView.backgroundColor = [UIColor clearColor];
        _browserView.jk_dataSource = self;
        _browserView.jk_delegate = self;
    }
    return _browserView;
}
- (JKPhotoTransitionConfig *)transitionConfig {
    if (!_transitionConfig) {
        _transitionConfig = [JKPhotoTransitionConfig new];
        _transitionConfig.transitionDuration = 0.35;
        _transitionConfig.outScaleOfDragImageViewAnimation = 0.15;
        _transitionConfig.inAnimation = JKImageBrowserAnimationMove;
        _transitionConfig.outAnimation = JKImageBrowserAnimationMove;
    }
    return _transitionConfig;
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

