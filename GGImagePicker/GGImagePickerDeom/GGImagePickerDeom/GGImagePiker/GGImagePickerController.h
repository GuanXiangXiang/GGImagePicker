//
//  GGImagePickerController.h
//  GGImagePickerDeom
//
//  Created by user on 16/8/30.
//  Copyright © 2016年 管祥祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Photos;

@protocol GGImagePickerControllerDelegate;

@interface GGImagePickerController : UINavigationController

/**
 *  构造方法
 *
 *  @param selectedAssets 选中的素材数组，可以用于预览之前选择的图片集合
 *
 *  @return 图像选择控制器
 */
- (instancetype)initWithSelectedAssets:(NSArray <PHAsset *>*)selectedAssets;
/**
 *  图形选择代理
 */
@property (nonatomic, weak) id<GGImagePickerControllerDelegate> pickerDelegate;
/**
 *  加载图像尺寸(以像素为单位，默认大小 600 * 600)
 */
@property (nonatomic) CGSize targetSize;
/**
 *  最大选择图像数量，默认 9 张
 */
@property (nonatomic, assign) NSInteger maxPickerCount;

@end

/// 图像选择控制器协议
@protocol GGImagePickerControllerDelegate <NSObject>
@optional
/// 图像选择完成代理方法
///
/// @param picker         图像选择控制器
/// @param images         用户选中图像数组
/// @param selectedAssets 选中素材数组，方便重新定位图像

- (void)imagePickerController:(GGImagePickerController *)picker
      didFinishSelectedImages:(NSArray <UIImage *> *)images
               selectedAssets:(NSArray <PHAsset *> *)selectedAssets;
@end


