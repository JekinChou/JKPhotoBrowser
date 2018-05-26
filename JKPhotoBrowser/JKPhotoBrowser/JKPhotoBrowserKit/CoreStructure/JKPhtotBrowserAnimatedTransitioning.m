//
//  JKPhtotBrowserAnimatedTransitioning.m
//  JKPhotoBrowser
//
//  Created by zhangjie on 2018/5/24.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import "JKPhtotBrowserAnimatedTransitioning.h"
#import "JKPhotoBrowserCell.h"
#import "JKPhotoBrowserView.h"
@interface JKPhtotBrowserAnimatedTransitioning () {
    __weak JKPhotoBrowser *browser;
}
@property (nonatomic, strong) UIImageView *animateImageView;
@end
@implementation JKPhtotBrowserAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return browser.transitionDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = fromController.view;
    UIView *toView = toController.view;
    
    //入场动效
    if (toController.isBeingPresented) {
        [containerView addSubview:toView];
        switch (browser.inAnimation) {
            case JKImageBrowserAnimationMove: {
                [self inAnimation_moveWithContext:transitionContext containerView:containerView toView:toView];
            }
                break;
            case JKImageBrowserAnimationFade: {
                [self inAnimation_fadeWithContext:transitionContext containerView:containerView toView:toView];
            }
                break;
            default:
                [self inAnimation_noWithContext:transitionContext];
                break;
        }
    }
    
    //出场动效
    if (fromController.isBeingDismissed) {
        switch (browser.outAnimation) {
            case JKImageBrowserAnimationMove: {
                [self outAnimation_moveWithContext:transitionContext containerView:containerView fromView:fromView];
            }
                break;
            case JKImageBrowserAnimationFade: {
                [self outAnimation_fadeWithContext:transitionContext containerView:containerView fromView:fromView];
            }
                break;
            default:
                [self outAnimation_noWithContext:transitionContext];
                break;
        }
    }
}

#pragma mark private

- (void)completeTransition:(id <UIViewControllerContextTransitioning>)transitionContext isIn:(BOOL)isIn {
    if (_animateImageView && _animateImageView.superview) [_animateImageView removeFromSuperview];
    if (isIn && !JKPhotoBrowser.isControllerPreferredForStatusBar)  [[UIApplication sharedApplication] setStatusBarHidden:!JKPhotoBrowser.showStatusBar];
    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
}

#pragma mark animation -- no

- (void)inAnimation_noWithContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    [self completeTransition:transitionContext isIn:YES];
}

- (void)outAnimation_noWithContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIImageView *fromImageView = [self getCurrentImageViewFromBrowser:browser];
    if (fromImageView) fromImageView.hidden = YES;
    [self completeTransition:transitionContext isIn:NO];
}

#pragma mark animation -- fade

- (void)inAnimation_fadeWithContext:(id <UIViewControllerContextTransitioning>)transitionContext containerView:(UIView *)containerView toView:(UIView *)toView {
    
    __block UIImage *image = nil;
    [self in_getShowInfoFromBrowser:browser complete:^(CGRect _fromFrame, UIImage *_fromImage) {
        image = _fromImage;
    }];
    if (!image) {
        [self completeTransition:transitionContext isIn:YES];
        return;
    }
    __block CGRect toFrame = CGRectZero;
    [JKPhotoBrowserCell countWithContainerSize:containerView.bounds.size image:image screenOrientation:JKImageBrowserScreenOrientationVertical verticalFillType:browser.verticalScreenImageViewFillType completed:^(CGRect imageFrame, CGSize contentSize, CGFloat minimumZoomScale, CGFloat maximumZoomScale) {
        toFrame = imageFrame;
    }];
    
    self.animateImageView.image = image;
    self.animateImageView.frame = toFrame;
    [containerView addSubview:self.animateImageView];
    toView.alpha = 0;
    self.animateImageView.alpha = 0;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toView.alpha = 1;
        self.animateImageView.alpha = 1;
    } completion:^(BOOL finished) {
        [self completeTransition:transitionContext isIn:YES];
    }];
}

- (void)outAnimation_fadeWithContext:(id <UIViewControllerContextTransitioning>)transitionContext containerView:(UIView *)containerView fromView:(UIView *)fromView {
    
    UIImageView *fromImageView = [self getCurrentImageViewFromBrowser:browser];
    if (!fromImageView) {
        [self completeTransition:transitionContext isIn:NO];
        return;
    }
    
    self.animateImageView.image = fromImageView.image;
    self.animateImageView.frame = [self getFrameInWindowWithView:fromImageView];
    [containerView addSubview:self.animateImageView];
    
    fromView.alpha = 1;
    self.animateImageView.alpha = 1;
    //因为可能是拖拽动画的视图，索性隐藏掉
    fromImageView.hidden = YES;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromView.alpha = 0;
        self.animateImageView.alpha = 0;
    } completion:^(BOOL finished) {
        [self completeTransition:transitionContext isIn:NO];
    }];
}


#pragma mark animation -- move

- (void)inAnimation_moveWithContext:(id <UIViewControllerContextTransitioning>)transitionContext containerView:(UIView *)containerView toView:(UIView *)toView {
    
    __block CGRect fromFrame = CGRectZero;
    __block UIImage *image = nil;
    [self in_getShowInfoFromBrowser:browser complete:^(CGRect _fromFrame, UIImage *_fromImage) {
        fromFrame = _fromFrame;
        image = _fromImage;
    }];
    if (CGRectEqualToRect(fromFrame, CGRectZero) || !image) {
        [self inAnimation_fadeWithContext:transitionContext containerView:containerView toView:toView];
        return;
    }
    __block CGRect toFrame = CGRectZero;
    [JKPhotoBrowserCell countWithContainerSize:containerView.bounds.size image:image screenOrientation:JKImageBrowserScreenOrientationVertical verticalFillType:browser.verticalScreenImageViewFillType  completed:^(CGRect imageFrame, CGSize contentSize, CGFloat minimumZoomScale, CGFloat maximumZoomScale) {
        toFrame = imageFrame;
    }];
    
    [containerView addSubview:toView];
    self.animateImageView.image = image;
    self.animateImageView.frame = fromFrame;
    [containerView addSubview:self.animateImageView];
    
    toView.alpha = 0;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toView.alpha = 1;
        self.animateImageView.frame = toFrame;
    } completion:^(BOOL finished) {
        [self completeTransition:transitionContext isIn:YES];
    }];
}

- (void)outAnimation_moveWithContext:(id <UIViewControllerContextTransitioning>)transitionContext containerView:(UIView *)containerView fromView:(UIView *)fromView {
    CGRect toFrame = [self getFrameInWindowWithView:[self getCurrentModelFromBrowser:browser].sourceImageView];
    UIImageView *fromImageView = [self getCurrentImageViewFromBrowser:browser];
    if (CGRectEqualToRect(toFrame, CGRectZero) || !fromImageView) {
        [self outAnimation_fadeWithContext:transitionContext containerView:containerView fromView:fromView];
        return;
    }
    
    self.animateImageView.image = fromImageView.image;
    self.animateImageView.frame = [self getFrameInWindowWithView:fromImageView];
    [containerView addSubview:self.animateImageView];
    
    fromImageView.hidden = YES;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromView.alpha = 0;
        self.animateImageView.frame = toFrame;
    } completion:^(BOOL finished) {
        [self completeTransition:transitionContext isIn:NO];
    }];
    
}

#pragma mark public

- (void)setInfoWithImageBrowser:(JKPhotoBrowser *)browser {
    if (!browser) return;
    self->browser = browser;
}

#pragma mark get info from browser

//从图片浏览器拿到初始化过后首先显示的数据
- (BOOL)in_getShowInfoFromBrowser:(JKPhotoBrowser *)browser complete:(void(^)(CGRect fromFrame, UIImage *fromImage))complete {
    
    CGRect _fromFrame = CGRectZero;
    UIImage *_fromImage = nil;
    
    id<JKPhotoModel> firstModel;
    NSArray *models = browser.dataArray;
    NSUInteger index = browser.currentIndex;
    
    if (models && models.count > browser.currentIndex) {
        
        //用户设置了数据源数组
        firstModel = models[index];
        _fromFrame = firstModel.sourceImageView ? [self getFrameInWindowWithView:firstModel.sourceImageView] : CGRectZero;
        _fromImage = [self in_getPosterImageWithModel:firstModel preview:NO];
        
    } else if (browser.dataSource) {
        
        //用户使用了数据源代理
        UIImageView *tempImageView = [browser.dataSource respondsToSelector:@selector(imageViewOfTouchForImageBrowser:)] ? [browser.dataSource imageViewOfTouchForImageBrowser:browser] : nil;
        _fromFrame = tempImageView ? [self getFrameInWindowWithView:tempImageView] : CGRectZero;
        _fromImage = tempImageView.image;
        
    } else {
       ;
        return NO;
    }
    
    if (complete) complete(_fromFrame, _fromImage);
    return YES;
}

//从 model 将要显示的图里面拿到入场动画的图片
- (UIImage *)in_getPosterImageWithModel:(id<JKPhotoModel>)model preview:(BOOL)preview {
    if (!preview && model.sourceImageView && model.sourceImageView.image) {
        return model.sourceImageView.image;
    }
    if (model.localImage) {
        return model.localImage;
    } else if (model.briefImage) {
        return model.briefImage;
    }
    return nil;
}

//拿到 view 基于屏幕的 frame
- (CGRect)getFrameInWindowWithView:(UIView *)view {
    return view ? [view convertRect:view.bounds toView:[UIApplication sharedApplication].keyWindow] : CGRectZero;
}

//从图片浏览器拿到当前显示的 model
- (id<JKPhotoModel>)getCurrentModelFromBrowser:(JKPhotoBrowser *)browser {
    JKPhotoBrowserCell *cell = [self getCurrentCellFromBrowser:browser];
    if (!cell) return nil;
    return cell.model;
}

//从图片浏览器拿到当前显示的 imageView （若是手势动画请求的隐藏，应该做动画视图的效果）
- (UIImageView *)getCurrentImageViewFromBrowser:(JKPhotoBrowser *)browser {
    JKPhotoBrowserCell *cell = [self getCurrentCellFromBrowser:browser];
    if (!cell) return nil;
    return cell.animateImageView.superview ? cell.animateImageView : cell.imageView;
}

//从图片浏览器拿到当前显示的 cell
- (JKPhotoBrowserCell *)getCurrentCellFromBrowser:(JKPhotoBrowser *)browser {
    if (!browser) return nil;
    JKPhotoBrowserView *browserView = [browser valueForKey:@"browserView"];
    if (!browserView) return nil;
    JKPhotoBrowserCell *cell = (JKPhotoBrowserCell *)[browserView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:browserView.currentIndex inSection:0]];
    return cell;
}

#pragma mark getter

- (UIImageView *)animateImageView {
    if (!_animateImageView) {
        _animateImageView = [UIImageView new];
        _animateImageView.contentMode = UIViewContentModeScaleAspectFill;
        _animateImageView.layer.masksToBounds = YES;
    }
    return _animateImageView;
}

@end
