//
//  JKPhotoBrowserCell.m
//  JKPhotoBrowser
//
//  Created by zhangjie on 2018/5/23.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import "JKPhotoBrowserCell.h"
#import <YYImage/YYAnimatedImageView.h>
#import "JKPhtotProgressView.h"

static UIView<JKPhotoBrowserStateProtocol> *_progressView;

@interface JKPhotoBrowserCell ()<UIScrollViewDelegate> {
    //动画相关
    CGFloat _startScaleWidthInAnimationView; //开始拖动时比例
    CGFloat _startScaleheightInAnimationView;    //开始拖动时比例
    CGRect _frameOfOriginalOfImageView;  //开始拖动时图片frame
    CGPoint _startOffsetOfScrollView;    //开始拖动时scrollview的偏移
    CGFloat _lastPointX; //上一次触摸点x值
    CGFloat _lastPointY; //上一次触摸点y值
    CGFloat _totalOffsetXOfAnimateImageView; //总共的拖动偏移x
    CGFloat _totalOffsetYOfAnimateImageView; //总共的拖动偏移y
    BOOL _animateImageViewIsStart;   //拖动动效是否第一次触发
    BOOL _isCancelAnimate;   //正在取消拖动动效
    BOOL _isZooming; //是否正在释放
}
@property (nonatomic,strong) YYAnimatedImageView *imageView;
@property (nonatomic,strong) YYAnimatedImageView *animateImageView;//做移动动画的view
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,copy) UIView<JKPhotoBrowserStateProtocol> *stateView;
@end

@implementation JKPhotoBrowserCell
@synthesize cancelDragImageViewAnimation = _cancelDragImageViewAnimation,outScaleOfDragImageViewAnimation = _outScaleOfDragImageViewAnimation,autoCountMaximumZoomScale = _autoCountMaximumZoomScale;

#pragma mark  - initialize
- (void)dealloc {
    [_animateImageView removeFromSuperview];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        _autoCountMaximumZoomScale = YES;
        [self setUpUI];
        [self addGesture];
    }
    return self;
}
- (void)prepareForReuse {
    [super prepareForReuse];
    [self.scrollView setZoomScale:1.0 animated:NO];
    self.imageView.image = nil;
    self.stateView.hidden = YES;
    self.stateView.progress = 0.0;
}
#pragma mark - PRIVATEMETHOD
- (void)setUpUI {
    [self.contentView addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    [self.contentView addSubview:self.stateView];
}
- (void)addGesture {
    UITapGestureRecognizer *tapSingle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapSingle:)];
    tapSingle.numberOfTapsRequired = 1;
    UITapGestureRecognizer *tapDouble = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapDouble:)];
    tapDouble.numberOfTapsRequired = 2;
    [tapSingle requireGestureRecognizerToFail:tapDouble];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToLongPress:)];
    [self.scrollView addGestureRecognizer:tapSingle];
    [self.scrollView addGestureRecognizer:tapDouble];
    [self.scrollView addGestureRecognizer:longPress];
}
// !!!:gesturenEvent
-(void)respondsToTapSingle:(UITapGestureRecognizer *)tap {
    if (_delegate && [_delegate respondsToSelector:@selector(photoBrowserCell:singleTapWithGesture:)]) {
        [_delegate photoBrowserCell:self singleTapWithGesture:tap];
    }
}

- (void)respondsToTapDouble:(UITapGestureRecognizer *)tap {
    UIScrollView *scrollView = self.scrollView;
    UIView *zoomView = [self viewForZoomingInScrollView:scrollView];
    CGPoint point = [tap locationInView:zoomView];
    if (!CGRectContainsPoint(zoomView.bounds, point)) {
        return;
    }
    if (scrollView.zoomScale == scrollView.maximumZoomScale) {
        [scrollView setZoomScale:1 animated:YES];
    } else {
        //让指定区域尽可能大的显示在可视区域
        [scrollView zoomToRect:CGRectMake(point.x, point.y, 1, 1) animated:YES];
    }
}

- (void)respondsToLongPress:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if (_delegate && [_delegate respondsToSelector:@selector(photoBrowserCell:longPressBegin:)]) {
            [_delegate photoBrowserCell:self longPressBegin:longPress];
        }
    }
}

- (void)dragAnimation_respondsToScrollViewPanGesture {
    if (self.cancelDragImageViewAnimation || _isZooming) return;
    UIScrollView *scrollView = self.scrollView;
    UIPanGestureRecognizer *pan = scrollView.panGestureRecognizer;
    if (pan.numberOfTouches != 1) return;
    CGPoint point = [pan locationInView:self];
    BOOL shouldAddAnimationView = point.y > _lastPointY && scrollView.contentOffset.y < -10 && !self.animateImageView.superview;
    if (shouldAddAnimationView) {
        [self dragAnimation_addAnimationImageViewWithPoint:point];
    }
    if (pan.state == UIGestureRecognizerStateChanged) {
        [self dragAnimation_performAnimationForAnimationImageViewWithPoint:point container:self];
    }
    _lastPointY = point.y;
    _lastPointX = point.x;
}
- (void)dragAnimation_addAnimationImageViewWithPoint:(CGPoint)point {
    if (self.imageView.frame.size.width <= 0 || self.imageView.frame.size.height <= 0) return;
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if (!JKPhotoBrowser.isControllerPreferredForStatusBar) [[UIApplication sharedApplication] setStatusBarHidden:JKPhotoBrowser.statusBarIsHideBefore];
#pragma clang diagnostic pop

    [[NSNotificationCenter defaultCenter] postNotificationName:JKPhotoBrowserShouldHideNotification object:nil];
    
    _animateImageViewIsStart = YES;
    _totalOffsetYOfAnimateImageView = 0;
    _totalOffsetXOfAnimateImageView = 0;
    self.animateImageView.image = self.imageView.image;
    self.animateImageView.frame = _frameOfOriginalOfImageView;
    [[UIApplication sharedApplication].keyWindow addSubview:self.animateImageView];
}
- (void)dragAnimation_performAnimationForAnimationImageViewWithPoint:(CGPoint)point container:(UIView *)container {
    if (!self.animateImageView.superview) return;
    CGFloat maxHeight = container.bounds.size.height;
    if (maxHeight <= 0) return;
    //偏移
    CGFloat offsetX = point.x - _lastPointX,
    offsetY = point.y - _lastPointY;
    if (_animateImageViewIsStart) {
        offsetX = offsetY = 0;
        _animateImageViewIsStart = NO;
    }
    _totalOffsetXOfAnimateImageView += offsetX;
    _totalOffsetYOfAnimateImageView += offsetY;
    //缩放比例
    CGFloat scale = (1 - _totalOffsetYOfAnimateImageView / maxHeight);
    if (scale > 1) scale = 1;
    if (scale < 0) scale = 0;
    //执行变换
    CGFloat width = _frameOfOriginalOfImageView.size.width * scale, height = _frameOfOriginalOfImageView.size.height * scale;
    self.animateImageView.frame = CGRectMake(point.x - width * _startScaleWidthInAnimationView, point.y - height * _startScaleheightInAnimationView, width, height);
    [[NSNotificationCenter defaultCenter] postNotificationName:JKPhtotBrowserChangeAlphaNotification object:nil userInfo:@{JKPhtotBrowserChangeAlphaNotification:@(scale)}];
}
- (void)loadImageWithModel:(id<JKPhotoModel>)model {
    //如果有本地图片,显示本地图片
    //如果加载失败显示错误图片
    //如果正在加载中,显示加载中视图,如果有缩略图就显示缩略图
    __weak typeof(self)weakself = self;
    __weak typeof(model)weakModel = model;
    self.stateView.hidden = YES;
    if (model.localImage) {//加载本地
        [self countLayoutWithImage:model.localImage completed:nil];
    }else if (model.url.absoluteString.length>0){//网络图
        switch (model.downState) {
            case JKDownLoadStateFail:{
                if (model.errorImage)
                [self countLayoutWithImage:model.errorImage completed:nil];
            }
                break;
            case JKDownLoadStateUnderway:{//正在下载
                self.stateView.hidden = NO;
                //显示加载中并且进度变化
                model.progressCallBack = ^(CGFloat progress) {
                    if (weakself.model != weakModel)return ;
                    weakself.stateView.progress = progress;
                };
            }
                break;
            case JKDownLoadStateUnLoad:{//未下载
                self.stateView.hidden = NO;
                model.progressCallBack = nil;
                //去下载
                [model setUrlWithDownloadInAdvance:model.url progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    if (weakself.model != weakModel)return ;
                    weakself.stateView.progress = receivedSize*1.0/expectedSize;
                } successful:^{
                    if (weakself.model != weakModel)return ;
                    [weakself.stateView showSuccessful];
                    [weakself loadImageWithModel: weakModel];
                } fail:^(NSError * _Nonnull error) {
                    if (weakself.model != weakModel)return ;
                    [weakself.stateView showFail];
                    [weakself countLayoutWithImage:weakModel.errorImage completed:nil];
                }];
            }
            default:
                break;
        }
    }
}


#pragma mark - UI处理代码
- (void)countLayoutWithImage:(YYImage *)image completed:(void(^)(CGRect imageFrame))completed {
    [JKPhotoBrowserCell countWithContainerSize:self.scrollView.bounds.size image:image verticalFillType:self.screenImageViewFillType completed:^(CGRect imageFrame, CGSize contentSize, CGFloat minimumZoomScale, CGFloat maximumZoomScale) {
        self.scrollView.contentSize = CGSizeMake(contentSize.width, contentSize.height);
        self.scrollView.minimumZoomScale = minimumZoomScale;
        if (self.autoCountMaximumZoomScale) {
            self.scrollView.maximumZoomScale = maximumZoomScale * 1.2;  //多给用户缩放 0.2 倍
        } else {
            self.scrollView.maximumZoomScale = self.model.maximumZoomScale;
        }
        self.imageView.frame = imageFrame;
        self.imageView.image = image;
        if (completed) completed(imageFrame);
    }];
}

//计算图片大小核心代码
+ (void)countWithContainerSize:(CGSize)containerSize image:(YYImage *)image verticalFillType:(JKImageBrowserImageViewFillType)verticalFillType  completed:(void(^)(CGRect _imageFrame, CGSize _contentSize, CGFloat _minimumZoomScale, CGFloat _maximumZoomScale))completed {
    
    CGSize imageSize = image.size;
    CGFloat containerWidth = containerSize.width;
    CGFloat containerHeight = containerSize.height;
    CGFloat containerScale = containerWidth / containerHeight;
    
    CGFloat width = 0, height = 0, x = 0, y = 0, minimumZoomScale = 1, maximumZoomScale = 1;
    CGSize contentSize = CGSizeZero;
    
    //计算最大缩放比例
    CGFloat widthScale = imageSize.width / containerWidth,
    heightScale = imageSize.height / containerHeight,
    maxScale = widthScale > heightScale ? widthScale : heightScale;
    maximumZoomScale = maxScale > 1 ? maxScale : 1;
    
    //其他计算
    JKImageBrowserImageViewFillType currentFillType = verticalFillType;
    
    switch (currentFillType) {
        case JKImageBrowserImageViewFillTypeFullWidth: {
            
            width = containerWidth;
            height = containerWidth * (imageSize.height / imageSize.width);
            if (imageSize.width / imageSize.height >= containerScale) {
                x = 0;
                y = (containerHeight - height) / 2.0;
                contentSize = CGSizeMake(containerWidth, containerHeight);
                minimumZoomScale = 1;
            } else {
                x = 0;
                y = 0;
                contentSize = CGSizeMake(containerWidth, height);
                minimumZoomScale = containerHeight / height;
            }
        }
            break;
        case JKImageBrowserImageViewFillTypeCompletely: {
            
            if (imageSize.width / imageSize.height >= containerScale) {
                width = containerWidth;
                height = containerWidth * (imageSize.height / imageSize.width);
                x = 0;
                y = (containerHeight - height) / 2.0;
            } else {
                height = containerHeight;
                width = containerHeight * (imageSize.width / imageSize.height);
                x = (containerWidth - width) / 2.0;
                y = 0;
            }
            contentSize = CGSizeMake(containerWidth, containerHeight);
            minimumZoomScale = 1;
        }
            break;
        default:
            break;
    }
    
    if (completed) completed(CGRectMake(x, y, width, height), contentSize, minimumZoomScale, maximumZoomScale);
}


- (void)dragAnimation_recordInfoWithScrollView:(UIScrollView *)scrollView {
    if (self.cancelDragImageViewAnimation) return;
    CGPoint point = [scrollView.panGestureRecognizer locationInView:self];
    _startOffsetOfScrollView = scrollView.contentOffset;
    _frameOfOriginalOfImageView = [self.imageView convertRect:self.imageView.bounds toView:[UIApplication sharedApplication].keyWindow];
    _startScaleWidthInAnimationView = (point.x - _frameOfOriginalOfImageView.origin.x) / _frameOfOriginalOfImageView.size.width;
    _startScaleheightInAnimationView = (point.y - _frameOfOriginalOfImageView.origin.y) / _frameOfOriginalOfImageView.size.height;
}
- (void)dragAnimation_removeAnimationImageViewWithScrollView:(UIScrollView *)scrollView container:(UIView *)container {
    if (!self.animateImageView.superview) return;
    CGFloat maxHeight = container.bounds.size.height;
    if (maxHeight <= 0) return;
    if (scrollView.zoomScale <= 1) {
        scrollView.contentOffset = CGPointZero;
    }
    if (_totalOffsetYOfAnimateImageView > maxHeight * _outScaleOfDragImageViewAnimation) {
        //通知 用来移除图片浏览器
        [[NSNotificationCenter defaultCenter]postNotificationName:JKPhtotBrowserWillDismissNotification object:nil];
    } else {
        //复位
        if (_isCancelAnimate) return;
        _isCancelAnimate = YES;
        
        CGFloat duration = 0.25;
        [[NSNotificationCenter defaultCenter] postNotificationName:JKPhtotBrowserViewWillShowWithTimeIntervalNotification object:nil userInfo:@{JKPhtotBrowserViewWillShowWithTimeIntervalNotification:@(duration)}];
        
        [UIView animateWithDuration:duration animations:^{
            self.animateImageView.frame = self->_frameOfOriginalOfImageView;
        } completion:^(BOOL finished) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
            if (!JKPhotoBrowser.isControllerPreferredForStatusBar) [[UIApplication sharedApplication] setStatusBarHidden:!JKPhotoBrowser.showStatusBar];
#pragma clang diagnostic pop

            self.scrollView.contentOffset = self->_startOffsetOfScrollView;
            [[NSNotificationCenter defaultCenter] postNotificationName:JKPhtotBrowserViewDidShowWithTimeIntervalNotification object:nil];
            [self.animateImageView removeFromSuperview];
            self->_isCancelAnimate = NO;
        }];
    }
}
- (void)shouldScroll {
   ((UICollectionView *)self.superview).scrollEnabled = YES;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGRect imageViewFrame = self.imageView.frame;
    CGFloat width = imageViewFrame.size.width, height = imageViewFrame.size.height;
    CGFloat scrollViewHeight = scrollView.bounds.size.height;
    CGFloat scrollViewWidth = scrollView.bounds.size.width;
    if (height > scrollViewHeight) {
        imageViewFrame.origin.y = 0;
    } else {
        imageViewFrame.origin.y = (scrollViewHeight - height) / 2.0;
    }
    if (width > scrollViewWidth) {
        imageViewFrame.origin.x = 0;
    } else {
        imageViewFrame.origin.x = (scrollViewWidth - width) / 2.0;
    }
    self.imageView.frame = imageViewFrame;
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self dragAnimation_respondsToScrollViewPanGesture];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(shouldScroll) withObject:nil afterDelay:0.1 inModes:@[NSDefaultRunLoopMode]];
    ((UICollectionView *)self.superview).scrollEnabled = NO;
    
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    _isZooming = YES;
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self dragAnimation_recordInfoWithScrollView:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _isZooming = NO;
    [self dragAnimation_removeAnimationImageViewWithScrollView:scrollView container:self];
}
#pragma mark - SET/GET
- (void)setCancelDragImageViewAnimation:(BOOL)cancelDragImageViewAnimation {
    _cancelDragImageViewAnimation = cancelDragImageViewAnimation;
    self.scrollView.alwaysBounceVertical = !cancelDragImageViewAnimation;
    self.scrollView.alwaysBounceHorizontal = !cancelDragImageViewAnimation;
}
- (void)setModel:(id<JKPhotoModel>)model {
    _model = model;
    [self loadImageWithModel:model];
}
- (UIView<JKPhotoBrowserStateProtocol> *)stateView {
    if (!_stateView) {
        if (!_progressView)_progressView = [[JKPhtotProgressView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _stateView = _progressView.copy;
        _stateView.center = self.contentView.center;
    }
    return _stateView;
}
- (YYAnimatedImageView *)imageView {
    if (!_imageView) {
        _imageView = [[YYAnimatedImageView alloc]initWithFrame:self.contentView.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.backgroundColor = [UIColor blackColor];
    }
    return _imageView;
}
- (YYAnimatedImageView *)animateImageView {
    if (!_animateImageView) {
        _animateImageView = [YYAnimatedImageView new];
        _animateImageView.contentMode = UIViewContentModeScaleAspectFill;
        _animateImageView.layer.masksToBounds = YES;
    }
    return _animateImageView;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        _scrollView.maximumZoomScale = 1;
        _scrollView.minimumZoomScale = 1;
        _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, _scrollView.bounds.size.height);
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.alwaysBounceVertical = YES;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _scrollView;
}
+(UIView<JKPhotoBrowserStateProtocol> *)progressView {
    return _progressView;
}
+(void)setProgressView:(UIView<JKPhotoBrowserStateProtocol> *)progressView {
    if (!progressView)return;
    _progressView = progressView;
}

@end
