//
//  JKPhotoBrowser.h
//  JKPhotoBrowser
//
//  Created by zhangjie on 2018/5/23.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKPhotoModel.h"
#import "JKPhotoBrowserDataSouce.h"
#import "JKPhotoBrowserDelegate.h"
#import "JKPhotoIndexPage.h"
#import "JKPhotoBrowserStateProtocol.h"
#import "JKPhotoTransitionManger.h"

NS_ASSUME_NONNULL_BEGIN
@interface JKPhotoBrowser : UIViewController
/**
 图片数组,赋值此处优先级大于代理
 */
@property (nonatomic,copy,nullable) NSArray<JKPhotoModel> *dataArray;
/**
 数据源
 */
@property (nonatomic,weak) id<JKPhotoBrowserDataSouce>dataSource;

/**
 代理
 */
@property (nonatomic,weak) id<JKPhotoBrowserDelegate> delegate;
/**
 当前下标
 */
@property (nonatomic,assign)NSUInteger currentIndex;

#pragma mark - 视图相关
/**
 索引view
 */
@property (nonatomic,strong,null_resettable) UIView<JKPhotoIndexPage>*pageView;
/**
 状态view 
 */
@property (nonatomic,strong,readwrite) UIView<JKPhotoBrowserStateProtocol> *stateView;

/**
 分页距离
 */
@property (nonatomic,assign) CGFloat space;

/**
 是否自行处理手势结果(长按和点按),如果为YES,需实现代理方法 -photoBrowser:(JKPhotoBrowser *)browser longPressWithIndex:(NSInteger)index 以及 - (void)photoBrowser:(JKPhotoBrowser *)browser clickWithIndex:(NSInteger)index 如果为NO,上述两个代理方法将不发生回调,内部处理,默认为YES
 */
@property (nonatomic,assign) BOOL customGestureDeal;
#pragma mark - 转场相关管理类
@property (nonatomic,strong,readonly) JKPhotoTransitionManger *transitionManger;

/**
 转场动画持续时间
 */
@property (nonatomic, assign) NSTimeInterval transitionDuration;

/**
 取消拖拽图片的动画效果
 */
@property (nonatomic, assign) BOOL cancelDragImageViewAnimation;

/**
 拖拽图片动效触发出场的比例（拖动距离/屏幕高度 默认0.15）
 */
@property (nonatomic, assign) CGFloat outScaleOfDragImageViewAnimation;

/**
 入场动画类型
 */
@property (nonatomic, assign) JKImageBrowserAnimation inAnimation;

/**
 出场动画类型
 */
@property (nonatomic, assign) JKImageBrowserAnimation outAnimation;

#pragma mark - 缩放


/**
 是否需要自动计算缩放
 （默认是自动的，若改为NO，可用 YBImageBrowserModel 的 maximumZoomScale 设置希望当前图片的最大缩放比例）
 */
@property (nonatomic, assign) BOOL autoCountMaximumZoomScale;

/**
 纵屏时候图片填充类型
 */
@property (nonatomic, assign) JKImageBrowserImageViewFillType verticalScreenImageViewFillType;

/**
 横屏时候图片填充类型
 */
@property (nonatomic, assign) JKImageBrowserImageViewFillType horizontalScreenImageViewFillType;


#pragma mark - 其他
/**
 最大显示pt（超过这个数量框架会自动做压缩和裁剪，默认为3500）
 */
@property (class, assign) CGFloat maxDisplaySize;

/**
 显示状态栏
 */
@property (class, assign) BOOL showStatusBar;

/**
 进入图片浏览器之前状态栏是否隐藏（进入框架内部会判断，若在图片浏览器生命周期之间外部的状态栏显示与否发生改变，你需要改变该属性的值）
 */
@property (class, assign) BOOL statusBarIsHideBefore;

/**
 状态栏是否是控制器优先
 */
@property (class, assign, readonly) BOOL isControllerPreferredForStatusBar;


#pragma mark - Method
- (void)show;
- (void)showFromController:(UIViewController *)controller;
- (void)dismiss;
@end
NS_ASSUME_NONNULL_END
