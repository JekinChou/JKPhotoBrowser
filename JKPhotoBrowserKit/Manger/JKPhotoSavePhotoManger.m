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
#import <YYWebImage/YYWebImage.h>
//#import <YYWebImage/YYWebImageManager.h>


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

+(void)saveImageToAlbumWithUrl:(NSURL * _Nonnull)url withProgress:(void(^_Nonnull)(NSInteger receivedSize, NSInteger expectedSize))progress withResult:(void(^_Nonnull)(BOOL result, NSString *_Nonnull desc))result; {
    [[YYWebImageManager sharedManager] requestImageWithURL:url options :YYWebImageOptionShowNetworkActivity | YYWebImageOptionAllowInvalidSSLCertificates progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        progress(receivedSize,expectedSize);
    } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (stage != YYWebImageStageFinished) return;
        if (error != nil || image == nil) {
            result(false,@"图片下载失败,请稍后重试");
            return;
        };
        [self saveImageToAlbumWithImage:image withCompletion:^(BOOL successful) {      
            result(successful,successful == true ?  @"图片保存成功":  @"图片保存失败");
        }];
    }];
}

+(void)saveImageToAlbumWithImage:(UIImage *_Nonnull)image withCompletion:(void(^_Nonnull)(BOOL successful))completion {
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
