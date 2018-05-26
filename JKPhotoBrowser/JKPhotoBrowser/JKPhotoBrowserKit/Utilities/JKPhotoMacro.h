//
//  JKPhotoMacro.h
//  JKPhotoBrowser
//
//  Created by zhangjie on 2018/5/23.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#ifndef JKPhotoMacro_h
#define JKPhotoMacro_h
#define JK_READIMAGE_FROMFILE(fileName, fileType) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:fileType]]
#define JK_MAINTHREAD_SYNC(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}
#define JK_MAINTHREAD_ASYNC(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

#define JK_STATUSBAR_ORIENTATION [UIApplication sharedApplication].statusBarOrientation
#define JK_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define JK_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//屏幕旋转后经过条件判断的通知
static NSString *const JKPhotoBrowserOrientationDidChangeNotification = @"JKPhotoBrowserOrientationDidChangeNotification";
static NSString *const JKPhtotBrowserViewWillShowWithTimeIntervalNotification = @"JKPhtotBrowserViewWillShowWithTimeIntervalNotification";
static NSString *const JKPhtotBrowserViewDidShowWithTimeIntervalNotification = @"JKPhtotBrowserViewDidShowWithTimeIntervalNotification";
static NSString *const JKPhtotBrowserChangeAlphaNotification = @"JKPhtotBrowserChangeAlphaNotification";
static NSString *const JKPhotoBrowserShouldHideNotification = @"JKPhotoBrowserShouldHideNotification";
//图片浏览器消失回调
static NSString *const JKPhtotBrowserWillDismissNotification = @"JKPhtotBrowserWillDismissNotification";
typedef NS_ENUM(NSUInteger, JKImageBrowserImageViewFillType) {
    JKImageBrowserImageViewFillTypeFullWidth,   //宽度抵满屏幕宽度，高度不定
    JKImageBrowserImageViewFillTypeCompletely   //保证图片完整显示情况下最大限度填充
};
typedef NS_ENUM(NSUInteger, JKImageBrowserScreenOrientation) {
    JKImageBrowserScreenOrientationUnknown, //未知
    JKImageBrowserScreenOrientationVertical, //屏幕竖直方向展示
    JKImageBrowserScreenOrientationHorizontal   //屏幕水平方向展示
};

typedef NS_ENUM(NSUInteger, JKImageBrowserAnimation) {
    JKImageBrowserAnimationNone,    //无动画
    JKImageBrowserAnimationFade,    //渐隐
    JKImageBrowserAnimationMove     //移动
};

#endif /* JKPhotoMacro_h */
