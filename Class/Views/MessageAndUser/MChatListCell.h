//
//  MChatListCell.h
//  Maomao
//
//  Created by zhao on 13-11-29.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MChatListModel.h"

@interface MChatListCell : UITableViewCell

@property (nonatomic, strong) UIImageView     *iconImg;
@property (nonatomic, strong) UIImageView     *chatBgImg;
@property (nonatomic, strong) UILabel         *chatContentLabel;
@property (nonatomic, strong) UIImageView     *timeIcon;
@property (nonatomic, strong) UILabel         *timeLabel;

- (void)setCellContent:(MChatListModel *)model;

@end
