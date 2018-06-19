//
//  JKPhotoSavePhotoManger.h
//  JKPhotoBrowser
//
//  Created by zhangjie on 2018/6/19.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYImage.h>
@interface JKPhotoSavePhotoManger : NSObject
+(void)judgeAlbumAuthorizationStatusSuccess:(os_block_t)successful;
+(void)saveImageToAlbumWithImage:(UIImage *)image withCompletion:(void(^)(BOOL successful))completion;
@end
