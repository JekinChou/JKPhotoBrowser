//
//  JKImageModel.h
//  JKPhotoBrowser
//
//  Created by zhangjie on 2018/5/23.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKPhotoModel.h"



@interface JKImageModel : NSObject<JKPhotoModel>

/**
 （setImageWithFileName:fileType: 若图片不在 Assets 中，尽量使用此方法以避免图片缓存过多导致内存飙升）

 @param fileName 图片名称
 @param type 图片类型
 @return 对应图片(非保存内存) 会用localImage引用
 */
- (UIImage *)setImageWithFileName:(NSString *)fileName fileType:(NSString *)type;
@end
