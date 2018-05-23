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
@interface JKPhotoBrowser : UIViewController<UITableViewDataSource>
/**
 图片数组,赋值此处优先级大于代理
 */
@property (nonatomic,copy,null_resettable) NSArray<JKPhotoModel> *dataArray;
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
@property (nonatomic,assign,readonly)NSUInteger currentIndex;

#pragma mark - 视图相关
/**
 索引view
 */
@property (nonatomic,strong,null_resettable) UIView<JKPhotoIndexPage>*pageView;
/**
 状态view 
 */
@property (nonatomic,strong,null_resettable) UIView<JKPhotoBrowserStateProtocol> *stateView;

#pragma mark - 转场相关管理类
@property (nonatomic,strong,readonly) JKPhotoTransitionManger *transitionManger;







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
