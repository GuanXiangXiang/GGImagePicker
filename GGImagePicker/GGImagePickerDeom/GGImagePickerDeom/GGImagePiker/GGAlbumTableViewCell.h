//
//  GGAlbumTableViewCell.h
//  GGImagePickerDeom
//
//  Created by user on 16/8/30.
//  Copyright © 2016年 管祥祥. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GGAlbum;
// 相册列表单元格
@interface GGAlbumTableViewCell : UITableViewCell
/**
 *  相册模型
 */
@property (nonatomic) GGAlbum *album;

@end
