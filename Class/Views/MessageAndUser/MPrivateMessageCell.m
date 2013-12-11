//
//  MBarPrivateMessageCell.m
//  Maomao
//
//  Created by maochengfang on 13-10-21.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MPrivateMessageCell.h"
#import "UIImageView+WebCache.h"

@implementation MPrivateMessageCell

@synthesize friendIcon;
@synthesize ageLabel;
@synthesize nicknameLabel;
@synthesize timeLabel;
@synthesize contentLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellInfoWithModel:(MPrivateMessageModel *)model
{
    [friendIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", MM_URL, model.pic_path]] placeholderImage:[UIImage imageNamed:@"message_content_usrIcon.png"]];
    ageLabel.text = [NSString stringWithFormat:@"%@岁",model.age];
    nicknameLabel.text = [NSString stringWithFormat:@"%@",model.nick_name];
    timeLabel.text = [NSString stringWithFormat:@"%@",model.time];
    contentLabel.text = [NSString stringWithFormat:@"%@",model.content];
}

@end
