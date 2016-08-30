//
//  ViewController.m
//  GGImagePickerDeom
//
//  Created by user on 16/8/30.
//  Copyright © 2016年 管祥祥. All rights reserved.
//

#import "ViewController.h"
#import "GGImagePickerController.h"

@interface ViewController () <GGImagePickerControllerDelegate>
/**
 *  选中照片数组
 */
@property (nonatomic) NSMutableArray *images;
/**
 *  选中资源素材数组，用于定位已经选择的照片
 */
@property (nonatomic) NSMutableArray *selectedAssets;
@end

@implementation ViewController

{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)didClickSelectPikerButton
{
    
    // 打开相册
    GGImagePickerController *picker = [[GGImagePickerController alloc] initWithSelectedAssets:self.selectedAssets];
    
    // 设置图像选择代理
    picker.pickerDelegate = self;
    // 设置目标图片尺寸
    picker.targetSize = CGSizeMake(600, 600);
    // 设置最大选择照片数量
    picker.maxPickerCount = 9;
    
    [self presentViewController:picker animated:YES completion:nil];
    

}
#pragma mark - 打开相册代理
- (void)imagePickerController:(GGImagePickerController *)picker
      didFinishSelectedImages:(NSArray<UIImage *> *)images
               selectedAssets:(NSArray<PHAsset *> *)selectedAssets {
    
    // 记录图像，方便在 CollectionView 显示
    self.images = images.mutableCopy;
    // 记录选中资源集合，方便再次选择照片定位
    self.selectedAssets = selectedAssets.mutableCopy;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
