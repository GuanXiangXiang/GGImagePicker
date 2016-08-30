//
//  GGAlbumTableViewCell.m
//  GGImagePickerDeom
//
//  Created by user on 16/8/30.
//  Copyright © 2016年 管祥祥. All rights reserved.
//

#import "GGAlbumTableViewCell.h"
#import "GGAlbum.h"

@implementation GGAlbumTableViewCell

#pragma mark - 构造函数
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.numberOfLines = 0;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.contentView.bounds;
    CGFloat iconMargin = 8.0;
    CGFloat iconWH = rect.size.height - 2 * iconMargin;
    
    self.imageView.frame = CGRectMake(iconMargin, iconMargin, iconWH, iconWH);
    
    CGFloat labelMargin = 12.0;
    CGFloat labelX = iconMargin + iconWH + labelMargin;
    CGFloat labelW = rect.size.width - labelX - labelMargin;
    self.textLabel.frame = CGRectMake(labelX, iconMargin, labelW, iconWH);
}

- (void)setAlbum:(GGAlbum *)album {
    _album = album;

    self.textLabel.attributedText = album.desc;
    
    CGSize imageSize = CGSizeMake(80, 80);
    self.imageView.image = [album emptyImageWithSize:imageSize];
    
    [album requestThumbnailWithSize:imageSize completion:^(UIImage * thumbnail) {
        self.imageView.image = thumbnail;
    }];
}
@end
