//
//  GGImagePickerController.m
//  GGImagePickerDeom
//
//  Created by user on 16/8/30.
//  Copyright © 2016年 管祥祥. All rights reserved.
//

#import "GGImagePickerController.h"
#import "GGAlbumTableViewController.h"

NSString *const GGImagePickerDidSelectedNotification = @"GGImagePickerDidSelectedNotification";
NSString *const GGImagePickerDidSelectedAssetsKey = @"GGImagePickerDidSelectedAssetsKey";
NSString *const GGImagePickerBundleName = @"GGImagePicker.bundle";


// 默认选择图片尺寸
#define GGImagePickerDefaultSize CGSizeMake(600, 600)

@interface GGImagePickerController ()

@end

@implementation GGImagePickerController
{
    /**
     *  导航根控制器
     */
    GGAlbumTableViewController *_rootViewController;
    /**
     *  选择的照片资源数组
     */
    NSMutableArray <PHAsset *> *_selectedAssets;
}
-(instancetype)initWithSelectedAssets:(NSArray<PHAsset *> *)selectedAssets
{
    self = [super init];
    if (self) {
        
        if (selectedAssets == nil)
        {
            _selectedAssets = @[].mutableCopy;
        }
        else
        {
            _selectedAssets = [NSMutableArray arrayWithArray:selectedAssets];
        }
        
        _rootViewController = [[GGAlbumTableViewController alloc] initWithSelectedAssets:_selectedAssets];
        
        // 设置默认最多选择数量
        self.maxPickerCount = 9;
        
        [self pushViewController:_rootViewController animated:NO];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedSelectAssets:) name:GGImagePickerDidSelectedNotification object:nil];
    }
    return self;
}

- (instancetype)init {
    NSAssert(NO, @"请调用 `-initWithSelectedAssets:`");
    return nil;
}
#pragma mark - getter & setter 方法
- (CGSize)targetSize {
    if (CGSizeEqualToSize(_targetSize, CGSizeZero)) {
        _targetSize = GGImagePickerDefaultSize;
    }
    return _targetSize;
}

- (void)setMaxPickerCount:(NSInteger)maxPickerCount {
    _rootViewController.maxPickerCount = maxPickerCount;
}

- (NSInteger)maxPickerCount {
    return _rootViewController.maxPickerCount;
}
#pragma mark - 监听方法
- (void)didFinishedSelectAssets:(NSNotification *)notification {
    
    // 没有遵循代理
    if (![self.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishSelectedImages:selectedAssets:)] || _selectedAssets == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
        return;
    }
    
    // 通过图片集合获得图片数组中间使用了调度组 返回给代理方法
    [self requestImages:_selectedAssets completed:^(NSArray<UIImage *> *images) {
        [self.pickerDelegate imagePickerController:self didFinishSelectedImages:images selectedAssets:_selectedAssets.copy];
    }];
}
#pragma mark - 请求图像方法
/// 根据 PHAsset 数组，统一查询用户选中图像
///
/// @param selectedAssets 用户选中 PHAsset 数组
/// @param completed      完成回调，缩放后的图像数组在回调参数中
- (void)requestImages:(NSArray <PHAsset *> *)selectedAssets completed:(void (^)(NSArray <UIImage *> *images))completed {
    
    /// 图像请求选项
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 设置 resizeMode 可以按照指定大小缩放图像
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    // 设置 deliveryMode 为 HighQualityFormat 可以只回调一次缩放之后的图像，否则会调用多次
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    // 设置加载图像尺寸(以像素为单位)
    CGSize targetSize = self.targetSize;
    
    NSMutableArray <UIImage *> *images = [NSMutableArray array];
    dispatch_group_t group = dispatch_group_create();
    
    for (PHAsset *asset in selectedAssets) {
        // 调度组
        dispatch_group_enter(group);
        
        [[PHImageManager defaultManager]
         requestImageForAsset:asset
         targetSize:targetSize
         contentMode:PHImageContentModeAspectFill
         options:options
         resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
             
             [images addObject:result];
             dispatch_group_leave(group);
         }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        completed(images.copy);
    });
}


@end
