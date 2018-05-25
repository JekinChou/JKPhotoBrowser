//
//  JKImageModel.m
//  JKPhotoBrowser
//
//  Created by zhangjie on 2018/5/23.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import "JKImageModel.h"
#import <YYWebImage/YYWebImage.h>
#import "JKPhotoMacro.h"
@interface JKImageModel () {
    YYWebImageOperation *_currentOperation;
}

@end
@implementation JKImageModel
@synthesize briefImage = _briefImage,gifName = _gifName,localImage = _localImage,url = _url,progress = _progress,animatedImage = _animatedImage,errorImage = _errorImage,maximumZoomScale = _maximumZoomScale,downState = _downState,sourceImageView = _sourceImageView;
#pragma mark - initialize
- (instancetype)init {
    if (self = [super init]) {
        _maximumZoomScale = 4;
    }
    return self;
}
- (void)dealloc {
    //停止下载
    [_currentOperation cancel];
}



//本地图片处理
- (UIImage *)setImageWithFileName:(NSString *)fileName fileType:(NSString *)type {
    UIImage *image = JK_READIMAGE_FROMFILE(fileName, type);
    self.localImage = image;
    return image;
}
//网络图片下载处理
- (void)setUrlWithDownloadInAdvance:(NSURL *)url progress:(JKWebImageProgressBlock)progress successful:(os_block_t)successful fail:(void(^)(NSError *))errorCallback {
    if (!self.url||self.localImage)return;
    self.downState = JKDownLoadStateUnderway;
    __weak typeof(self)weakself = self;
    _currentOperation = [[YYWebImageManager sharedManager]requestImageWithURL:url options:YYWebImageOptionShowNetworkActivity  progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        weakself.progress = receivedSize/expectedSize;
        progress(receivedSize,expectedSize);
    } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        JK_MAINTHREAD_SYNC(^{
            if (stage != YYWebImageStageFinished)return;
            if (error&&errorCallback&&!image) {
                weakself.downState = JKDownLoadStateFail;
                errorCallback(error);
                return ;
            }else if (image){
                weakself.localImage = image;
                successful();
            }else {
                weakself.downState = JKDownLoadStateFail;
                NSError *error = [NSError errorWithDomain:@"未知错误" code:-9999 userInfo:nil];
                errorCallback(error);
            }
        });
        
    }];
}


#pragma mark -SET/GET
- (void)setUrl:(NSURL *)url {
    _url = url;
    self.downState = JKDownLoadStateUnLoad;
}


@end
