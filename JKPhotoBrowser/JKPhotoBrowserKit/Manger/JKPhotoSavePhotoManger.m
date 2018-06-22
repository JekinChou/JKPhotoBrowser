//
//  JKPhotoSavePhotoManger.m
//  JKPhotoBrowser
//
//  Created by zhangjie on 2018/6/19.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import "JKPhotoSavePhotoManger.h"
#import <Photos/PHPhotoLibrary.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@implementation JKPhotoSavePhotoManger
+(void)judgeAlbumAuthorizationStatusSuccess:(os_block_t)successful {
     PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied) {//明确拒绝了
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"请前往设置开通相册权限" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:controller animated:YES completion:nil];
    } else if(status == PHAuthorizationStatusNotDetermined){
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
            if (status == PHAuthorizationStatusAuthorized) {
                if (successful) successful();
            } else {//又点击拒绝了
               
            }
        }];
    } else if (status == PHAuthorizationStatusAuthorized){
        if (successful) successful();
    }
}
+(void)saveImageToAlbumWithImage:(UIImage *)image withCompletion:(void(^)(BOOL successful))completion {
    YYImageType type = 0;
     YYImageDecoder *decoder = [YYImageDecoder decoderWithData:image.yy_imageDataRepresentation scale:1];
    type = decoder.type;
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
   if(type != YYImageTypeUnknown){
       NSData *data = image.yy_imageDataRepresentation;
       [library writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
           if (!error) {
               if (completion) {
                   completion(YES);
               }
           } else {
               if (completion) {
                   completion(NO);
               }
           }
       }];
    }else {
        if (completion) {
            completion(NO);
        }
    }
}



@end
