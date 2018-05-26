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
    JKPhtotBrowserAnimatedTransitioning *_animatedTransitioningManager;
    NSMutableDictionary <NSString *,id<JKPhotoModel>>*_datasM;
}
@property (nonatomic,strong) JKPhotoTransitionManger *transitionManger;
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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismiss) name:JKPhtotBrowserWillDismissNotification object:nil];
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
    NSInteger number = [self.dataSource numberInPhotoBrowser:self];
    if(number == 0)number = self.dataArray.count;
    self.pageView.total = number;
    if (!_datasM)_datasM = [NSMutableDictionary  dictionaryWithCapacity:number];
    return number;
}

/**
 返回下标对应的模型
 
 @param browserView browserView description
 @param index index description
 @return return value description
 */
- (id<JKPhotoModel>)photoBrowserView:(JKPhotoBrowserView *)browserView itemForCellAtIndex:(NSInteger)index {
    //判断数组中是否有这个模型,如果有就返回
    //没有就走数据源方法,将返回的模型保存在数组中
    //最后返回Nil
    NSString *key = [NSString stringWithFormat:@"%ld",(long)index];
    if (_datasM&&[_datasM valueForKey:key]) {
        return _datasM[key];
    }else if ([self.dataSource respondsToSelector:@selector(photoBrowser:modelForCellAtIndex:)]){
        id<JKPhotoModel>model = [self.dataSource photoBrowser:self modelForCellAtIndex:index];
        [_datasM setObject:model forKey:key];
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
        NSLog(@"长按了");
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
- (void)setDataArray:(NSArray<JKPhotoModel> *)dataArray {
    _dataArray = dataArray;
    if (dataArray.count>0&&!_datasM) {
        _datasM = [NSMutableDictionary  dictionaryWithCapacity:dataArray.count];
        for (int i = 0; i<dataArray.count; i++) {
            [_datasM setObject:dataArray[i] forKey:[NSString stringWithFormat:@"%d",i]];
        }
    }
}
- (NSArray<JKPhotoModel> *)dataArray {
    if (!_dataArray) {
        NSArray *allKeys = _datasM.allKeys;
        [allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSComparisonResult resuest = [obj2 compare:obj1];
            return resuest;
        }];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:_datasM.count];
        for (NSString *key in allKeys) {
            [array addObject:_datasM[key]];
        }
        if (array.count == 0)array = nil;
        _dataArray = array.copy;
    }
    return _dataArray;
}
- (void)setStateView:(UIView<JKPhotoBrowserStateProtocol,NSCopying> *)stateView {
    self.browserView.stateView = stateView;
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

