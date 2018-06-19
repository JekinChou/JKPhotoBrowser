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
#import "JKPhotoTransitionConfig.h"

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
 索引view 分页控件
 */
@property (nonatomic,strong,null_resettable) UIView<JKPhotoIndexPage>*pageView;
/**
 状态view 展示进度以及下载成功失败与否
 */
@property (nonatomic,weak,readwrite) UIView<JKPhotoBrowserStateProtocol,NSCopying> *stateView;

/**
 自定义容器处理view,顶部功能处理
 */
@property (nonatomic,strong,nullable) UIView *topFunctionView;
@property (nonatomic,strong,nullable) UIView *bottomFunctionView;
/**
 分页距离,defalut is 18
 */
@property (nonatomic,assign) CGFloat space;

/**
 是否自行处理手势结果(长按和点按),如果为YES,需实现代理方法 -photoBrowser:(JKPhotoBrowser *)browser longPressWithIndex:(NSInteger)index 以及 - (void)photoBrowser:(JKPhotoBrowser *)browser clickWithIndex:(NSInteger)index 如果为NO,上述两个代理方法将不发生回调,内部处理,默认为YES
 */
@property (nonatomic,assign) BOOL customGestureDeal;
#pragma mark - 转场相关管理类
@property (nonatomic,strong,readonly) JKPhotoTransitionConfig *transitionConfig;

#pragma mark - 缩放

/**
 是否需要自动计算缩放
 （默认是自动的，若改为NO，可用 JKImageBrowserModel 的 maximumZoomScale 设置希望当前图片的最大缩放比例）
 */
@property (nonatomic, assign) BOOL autoCountMaximumZoomScale;

/**
 图片填充类型
 */
@property (nonatomic, assign) JKImageBrowserImageViewFillType screenImageViewFillType;

#pragma mark - 其他
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
