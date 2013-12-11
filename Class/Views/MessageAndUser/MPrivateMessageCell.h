//
//  MBarPrivateMessageCell.h
//  Maomao
//
//  Created by maochengfang on 13-10-21.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPrivateMessageModel.h"

@interface MPrivateMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView  *friendIcon;
@property (weak, nonatomic) IBOutlet UILabel      *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel      *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel      *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel      *contentLabel;

- (void)setCellInfoWithModel:(MPrivateMessageModel *)model;

@end
