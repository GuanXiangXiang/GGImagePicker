//
//  GGAlbumTableViewController.h
//  GGImagePickerDeom
//
//  Created by user on 16/8/30.
//  Copyright © 2016年 管祥祥. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Photos;

// 相册列表控制器
@interface GGAlbumTableViewController : UITableViewController
/**
 *  构造函数
 *
 *  @param selectedAssets 选中素材数组
 *
 *  @return 相册列表控制器
 */
- (instancetype)initWithSelectedAssets:(NSMutableArray <PHAsset *> *)selectedAssets;
/**
 *  最大选择图片数量 默认9张
 */
@property (nonatomic, assign) NSInteger maxPickerCount;

@end
