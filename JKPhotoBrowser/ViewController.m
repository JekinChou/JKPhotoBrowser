//
//  ViewController.m
//  JKPhotoBrowser
//
//  Created by zhangjie on 2018/5/23.
//  Copyright © 2018年 zhangjie. All rights reserved.
//

#import "ViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "JKPhotoBrowser.h"
#import "JKImageModel.h"
#import "JKPhotoMacro.h"
#import <YYWebImage/UIImage+YYWebImage.h>
#import <YYCache/YYCache.h>
#import "JKPhotoBrowserTopView.h"
#import "JKPhotoSavePhotoManger.h"
#define CELLSIZE CGSizeMake(JK_SCREEN_WIDTH/3, JK_SCREEN_WIDTH/3)
static int tagOfImageOfCell = 1000;
static int tagOfLabelOfCell = 1001;
static int tagOfLabelOfHeader = 2000;
static NSString * const kReuseIdentifierOfCell = @"UICollectionViewCell";
static NSString * const kReuseIdentifierOfHeader = @"UICollectionReusableViewHeader";

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,JKPhotoBrowserDataSouce,JKPhotoBrowserDelegate> {
    NSIndexPath *currentTouchIndexPath;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *dataArray0;
@property (nonatomic, copy) NSArray *dataArray1;

@end

@implementation ViewController

#pragma mark 图片浏览器使用案例 (image brower use case)

#pragma mark 方式一：使用数组配置数据源
- (void)A_showWithTouchIndexPath:(NSIndexPath *)indexPath {
    
    //配置数据源（图片浏览器每一张图片对应一个 JKImageModel 实例）
    NSMutableArray <JKImageModel *>*tempArr = (NSMutableArray <JKImageModel *>*)[NSMutableArray array];
    [self.dataArray0 enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JKImageModel *model = [JKImageModel  new];
        [model setImageWithFileName:obj fileType:@"jpeg"];
        model.sourceImageView = [self getImageViewOfCellByIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
        [tempArr addObject:model];
    }];
    JKPhotoBrowser *browser = [JKPhotoBrowser new];
    browser.delegate = self;
    JKPhotoBrowserTopView *view = [JKPhotoBrowserTopView new];
    view.backgroundColor = [UIColor clearColor];
    view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50);
    __weak typeof(browser)weakBrowser = browser;
    view.btnDidClick = ^{
        id<JKPhotoModel>model = weakBrowser.dataArray[weakBrowser.currentIndex];
        UIImage *image = model.localImage;
        if (!image)return;
        [JKPhotoSavePhotoManger judgeAlbumAuthorizationStatusSuccess:^{
            [JKPhotoSavePhotoManger saveImageToAlbumWithImage:image withCompletion:^(BOOL successful) {
              
            }];
        }];
    };
    browser.topFunctionView = view;
    browser.dataArray = tempArr.copy;
    browser.currentIndex = indexPath.row;

    //展示
    [browser showFromController:self];
}

#pragma mark 方式二、使用代理配置数据源

- (void)B_showWithTouchIndexPath:(NSIndexPath *)indexPath {

    JKPhotoBrowser *browser = [JKPhotoBrowser new];
 
    browser.dataSource = self;
    browser.delegate = self;
    browser.currentIndex = indexPath.row;

    JKPhotoBrowserTopView *view = [JKPhotoBrowserTopView new];
    view.backgroundColor = [UIColor clearColor];
    view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50);
    __weak typeof(browser)weakBrowser = browser;
    view.btnDidClick = ^{
        id<JKPhotoModel>model = weakBrowser.dataArray[weakBrowser.currentIndex];
        UIImage *image = model.localImage;
        if (!image)return;
        [JKPhotoSavePhotoManger judgeAlbumAuthorizationStatusSuccess:^{
            [JKPhotoSavePhotoManger saveImageToAlbumWithImage:image withCompletion:^(BOOL successful) {
                if (successful) {
                    NSLog(@"保存成功");
                }
                
            }];
        }];
    };
       browser.topFunctionView = view;
    //展示
    [browser showFromController:self];
}
/**
 长按
 
 @param browser browser description
 @param index index description
 */
- (void)photoBrowser:(JKPhotoBrowser *)browser longPressWithIndex:(NSInteger)index {
    if (browser.currentIndex == index) {
        NSString *url = @"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1584608172&di=822975e395815e0e4278461e14bec1f0&src=http://a3.att.hudong.com/68/61/300000839764127060614318218_950.jpg";
        [JKPhotoSavePhotoManger saveImageToAlbumWithUrl:[NSURL URLWithString:url] withProgress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } withResult:^(BOOL result, NSString *desc) {
            
        }];
    }
}

/**
 点按
 
 @param browser browser description
 @param index index description
 */
- (void)photoBrowser:(JKPhotoBrowser *)browser clickWithIndex:(NSInteger)index {
    if (browser.currentIndex == index) {
        NSLog(@"点按%ld",(long)index);
    }
}


/**
 返回点击的那个 UIImageView（用于做 JKImageBrowserAnimationMove 类型动效）
 
 @param imageBrowser 当前图片浏览器
 @return 点击的图片视图
 */
- (UIImageView * _Nullable)imageViewOfTouchForImageBrowser:(JKPhotoBrowser *)imageBrowser {
     return [self getImageViewOfCellByIndexPath:currentTouchIndexPath];
}

/**
 配置图片的数量
 
 @param imageBrowser 当前图片浏览器
 @return 图片数量
 */
- (NSInteger)numberInPhotoBrowser:(JKPhotoBrowser *)imageBrowser {
    return self.dataArray1.count;
}

/**
 返回当前 index 图片对应的数据模型
 
 @param browser 当前图片浏览器
 @param index 当前下标
 @return 数据模型
 */

- (id<JKPhotoModel>)photoBrowser:(JKPhotoBrowser *)browser modelForCellAtIndex:(NSInteger)index {
    JKImageModel *model = [JKImageModel new];
    model.url = [NSURL URLWithString:self.dataArray1[index]];
    model.sourceImageView = [self getImageViewOfCellByIndexPath:[NSIndexPath indexPathForRow:index inSection:1]];
    return model;
}

#pragma mark 其他业务模块（other business module）
- (UIImageView *)getImageViewOfCellByIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    if (!cell) return nil;
    return [cell.contentView viewWithTag:tagOfImageOfCell];
}

// life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
- (BOOL)prefersStatusBarHidden {
    return NO;
}
// UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataArray0.count;
    }
    return self.dataArray1.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseIdentifierOfCell forIndexPath:indexPath];
    UIImageView *imgView = [cell.contentView viewWithTag:tagOfImageOfCell];
    UILabel *label = [cell.contentView viewWithTag:tagOfLabelOfCell];
    if (!imgView) {
        CGFloat height = cell.contentView.bounds.size.height, width = cell.contentView.bounds.size.width;
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.layer.masksToBounds = YES;
        imgView.tag = tagOfImageOfCell;
        [cell.contentView addSubview:imgView];
        CGFloat labelWidth = 34, labelHeight = 25;
        label = [[UILabel alloc] initWithFrame:CGRectMake(width-labelWidth, height-labelHeight, labelWidth, labelHeight)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 5;   //测试用例，请不要在意此处的性能
        label.tag = tagOfLabelOfCell;
        [cell.contentView addSubview:label];
    }
    label.hidden = YES;
    if (indexPath.section == 0) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:self.dataArray0[indexPath.row] ofType:@"jpeg"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        UIImage *image = [UIImage imageWithData:data];
        if (image.size.width > 3500 || image.size.height > 3500) {
            label.hidden = NO;
            label.text = @"大图";
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *result = [image yy_imageByResizeToSize:CGSizeMake(800, image.size.height / image.size.width * 800) contentMode:UIViewContentModeScaleAspectFill];
                JK_MAINTHREAD_ASYNC(^{
                     imgView.image = result;
                })
            });
        } else {
            imgView.image = image;
        }
    } else {
        NSString *urlStr = self.dataArray1[indexPath.row];
        if ([urlStr hasSuffix:@".gif"]) {
            label.hidden = NO;
            label.text = @"gif";
        }
        [imgView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    }
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kReuseIdentifierOfHeader forIndexPath:indexPath];
        UILabel *label = [view viewWithTag:tagOfLabelOfHeader];
        if (!label) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, view.bounds.size.width - 40, view.bounds.size.height)];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor orangeColor];
            label.font = [UIFont boldSystemFontOfSize:17];
            label.tag = tagOfLabelOfHeader;
            [view addSubview:label];
        }
        label.text = indexPath.section?@"网络图片":@"本地图片";
        return view;
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(JK_SCREEN_WIDTH, 44);
}

// UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    currentTouchIndexPath = indexPath;
    if (indexPath.section == 0) {
        [self A_showWithTouchIndexPath:indexPath];
    } else {
        [self B_showWithTouchIndexPath:indexPath];
    }
}

// getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CELLSIZE;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, JK_SCREEN_WIDTH, JK_SCREEN_HEIGHT - 40) collectionViewLayout:layout];
        [_collectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kReuseIdentifierOfHeader];
        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:kReuseIdentifierOfCell];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}
- (NSArray *)dataArray0 {
    if (!_dataArray0) {
        _dataArray0 = @[@"localImage0", @"localImage1", @"localImage3", @"localImage2", @"localImage4", @"localImage5", @"localImage6", @"localImage8", @"localBigImage0"];
    }
    return _dataArray0;
}
- (NSArray *)dataArray1 {
    if (!_dataArray1) {
        _dataArray1 = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1527328684670&di=b3a69e9fec8e10555c43ea2ace62928a&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F0112a85874bd24a801219c7729e77d.jpg",
                        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1524118687954&di=d92e4024fe4c2e4379cce3d3771ae105&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201605%2F18%2F20160518181939_nCZWu.gif",
                        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1524118772581&di=29b994a8fcaaf72498454e6d207bc29a&imgtype=0&src=http%3A%2F%2Fimglf2.ph.126.net%2F_s_WfySuHWpGNA10-LrKEQ%3D%3D%2F1616792266326335483.gif",
                        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1524118803027&di=beab81af52d767ebf74b03610508eb36&imgtype=0&src=http%3A%2F%2Fe.hiphotos.baidu.com%2Fbaike%2Fpic%2Fitem%2F2e2eb9389b504fc2995aaaa1efdde71190ef6d08.jpg",
                        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1524118823131&di=aa588a997ac0599df4e87ae39ebc7406&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201605%2F08%2F20160508154653_AQavc.png",
                        @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=722693321,3238602439&fm=27&gp=0.jpg",
                        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1524118892596&di=5e8f287b5c62ca0c813a548246faf148&imgtype=0&src=http%3A%2F%2Fwx1.sinaimg.cn%2Fcrop.0.0.1080.606.1000%2F8d7ad99bly1fcte4d1a8kj20u00u0gnb.jpg",
                        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1524118914981&di=7fa3504d8767ab709c4fb519ad67cf09&imgtype=0&src=http%3A%2F%2Fimg5.duitang.com%2Fuploads%2Fitem%2F201410%2F05%2F20141005221124_awAhx.jpeg",
                        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1524118934390&di=fbb86678336593d38c78878bc33d90c3&imgtype=0&src=http%3A%2F%2Fi2.hdslb.com%2Fbfs%2Farchive%2Fe90aa49ddb2fa345fa588cf098baf7b3d0e27553.jpg",
                        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1524118984884&di=7c73ddf9d321ef94a19567337628580b&imgtype=0&src=http%3A%2F%2Fimg5q.duitang.com%2Fuploads%2Fitem%2F201506%2F07%2F20150607185100_XQvYT.jpeg"
                        ];
    }
    return _dataArray1;
}

// button event
- (IBAction)clickClearButton:(id)sender {
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
}

// device orientation
- (BOOL)shouldAutorotate {
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
