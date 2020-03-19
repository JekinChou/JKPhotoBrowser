//
//  JKPhotoSavePhotoManger.h
//  JKPhotoBrowser
//
//  Created by zhangjie on 2018/6/19.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYImage/YYImage.h>
@interface JKPhotoSavePhotoManger : NSObject
+(void)judgeAlbumAuthorizationStatusSuccess:(os_block_t _Nullable )successful;
+(void)saveImageToAlbumWithImage:(UIImage *_Nonnull)image withCompletion:(void(^_Nonnull)(BOOL successful))completion;
+(void)saveImageToAlbumWithUrl:(NSURL * _Nonnull)url withProgress:(void(^_Nonnull)(NSInteger receivedSize, NSInteger expectedSize))progress withResult:(void(^_Nonnull)(BOOL result, NSString *_Nonnull desc))result;
@end
