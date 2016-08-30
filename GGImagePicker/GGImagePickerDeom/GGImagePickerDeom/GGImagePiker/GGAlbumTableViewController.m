//
//  GGAlbumTableViewController.m
//  GGImagePickerDeom
//
//  Created by user on 16/8/30.
//  Copyright © 2016年 管祥祥. All rights reserved.
//

#import "GGAlbumTableViewController.h"
#import "GGAlbum.h"
#import "GGAlbumTableViewCell.h"

#define GGleftButtonWH 50
#define GGTableViewRowHeight 80

@interface GGAlbumTableViewController ()

@end

static NSString *const GGAlbumTableViewCellIdentifier = @"GGAlbumTableViewCellIdentifier";

@implementation GGAlbumTableViewController
{
    /**
     *  相册资源集合
     */
    NSArray<GGAlbum *> *_assetCollection;
    /**
     *  选中素材数组
     */
    NSMutableArray <PHAsset *> *_selectedAssets;
}

- (instancetype)initWithSelectedAssets:(NSMutableArray<PHAsset *> *)selectedAssets
{
    self = [super init];
    if (self)
    {
        _selectedAssets = selectedAssets;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(clickCloseButton)];
    
    // 获得相册
    [self fetchAssetCollectionWithCompletion:^(NSArray<GGAlbum *> *assetCollection, BOOL isDenied) {
        if (isDenied) {
            // 拒绝弹窗
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有权限访问相册,请先在设置程序中授权访问" preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            return ;
        }
        
        _assetCollection = assetCollection;
        
        [self.tableView reloadData];
        
    }];
    
    // 设置表格
    [self.tableView registerClass:[GGAlbumTableViewCell class] forCellReuseIdentifier:GGAlbumTableViewCellIdentifier];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = GGTableViewRowHeight;
}

#pragma mark - 加载相册
- (void)fetchAssetCollectionWithCompletion:(void(^)(NSArray<GGAlbum *> *, BOOL))completion
{
    // 判断授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    switch (status) {
        case PHAuthorizationStatusAuthorized:
            [self fetchResultWithComoletion:completion];
            break;
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status)
            {
              [self fetchResultWithComoletion:completion];
            }];
        }
            break;
            
        default:
            NSLog(@"拒绝访问相册");
            completion(nil, YES);
            break;
    }
    
}

// 加载相册
- (void)fetchResultWithComoletion:(void (^)(NSArray<GGAlbum *> *, BOOL))completion
{
    // 相机胶卷
    PHFetchResult *userLibrary = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    
    // 查找设置
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"localizedTitle" ascending:NO]];
    
    // 同步相册
    PHFetchResult *syncedAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:options];
    
    // 合并
    NSMutableArray *result = @[].mutableCopy;
    [userLibrary enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    
        [result addObject:[GGAlbum albumWithAssetCollection:obj]];
        
    }];
    [syncedAlbum enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [result addObject:[GGAlbum albumWithAssetCollection:obj]];
        
    }];
    
    // 线程延迟回调
    dispatch_async(dispatch_get_main_queue(), ^{ completion(result.copy, NO); });
}

- (void)clickCloseButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _assetCollection.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GGAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GGAlbumTableViewCellIdentifier forIndexPath:indexPath];
    
    // 设置cell
    cell.album = _assetCollection[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    HMAlbum *album = _assetCollection[indexPath.row];
//    HMImageGridViewController *grid = [[HMImageGridViewController alloc]
//                                       initWithAlbum:album
//                                       selectedAssets:_selectedAssets
//                                       maxPickerCount:_maxPickerCount];
//    
//    [self.navigationController pushViewController:grid animated:YES];
}


@end
