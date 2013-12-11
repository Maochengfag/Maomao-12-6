//
//  MChatListCell.m
//  Maomao
//
//  Created by zhao on 13-11-29.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MChatListCell.h"
#import "UIImageView+WebCache.h"

@implementation MChatListCell

@synthesize iconImg;
@synthesize chatBgImg;
@synthesize chatContentLabel;
@synthesize timeIcon;
@synthesize timeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        iconImg = [[UIImageView alloc] init];
        [self addSubview:iconImg];
        
        chatBgImg = [[UIImageView alloc] init];
        [self addSubview:chatBgImg];
        
        chatContentLabel = [[UILabel alloc] init];
        [chatContentLabel setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:chatContentLabel];
        
        timeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(100, 75, 10, 10)];
        [timeIcon setImage:[UIImage imageNamed:@"user_icon_time.png"]];
        [self addSubview:timeIcon];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(119, 72, 117, 15)];
        [timeLabel setFont:[UIFont systemFontOfSize:10]];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [timeLabel setTextColor:[UIColor blackColor]];
        [self addSubview:timeLabel];
        
    }
    return self;
}

- (void)setCellContent:(MChatListModel *)model;
{
    NSInteger userid = [[[NSUserDefaults standardUserDefaults] stringForKey:USERID] integerValue];
    NSInteger chatId = [model.chatId integerValue];
    
    NSString *content = [NSString stringWithFormat:@"%@",model.content];
    NSInteger lenth = [content length];
    
    NSRange range = [content rangeOfString:@"[edu0"];
    
    UIImageView *faceImg;
    
    if (range.location == NSNotFound) {
        [chatContentLabel setText:content];
    } else {
        NSArray *allContent = [content componentsSeparatedByString:@"]"];
        NSMutableArray *isNewContent = [NSMutableArray arrayWithCapacity:0];
        NSInteger xPiont = 0;
        
        for (int i = 0; i < [allContent count]; i++) {
            NSString *subContent = [allContent objectAtIndex:i];
            NSLog(@"subContent == %@",subContent);
            NSString *imgName = [subContent substringWithRange:NSMakeRange([subContent length] - 7, 7)];
            NSLog(@"imgName == %@",imgName);
            NSString *subContentStr = [subContent stringByReplacingOccurrencesOfString:imgName withString:@"    "];
            [isNewContent addObject:subContentStr];
            
            NSString *imgNumber = [imgName substringFromIndex:5];
            faceImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"ic_face_0%@.png",imgNumber]]];
            
            [faceImg setContentMode:UIViewContentModeScaleAspectFit];
            
            xPiont = [subContentStr length]*13 + xPiont - 49;
            
            [faceImg setFrame:CGRectMake(xPiont, 5, 15, 15)];
            [chatContentLabel addSubview:faceImg];
        }
        
        NSString *lastContent = @"";
        for (int i = 0; i < [isNewContent count]; i++) {
            lastContent = [lastContent stringByAppendingString:[isNewContent objectAtIndex:i]];
        }
        lenth = [lastContent length];
        [chatContentLabel setText:lastContent];

//        lenth = lenth - 5;
//        NSString *suContent = [content stringByReplacingOccurrencesOfString:[content substringWithRange:NSMakeRange(range.location, range.length+3)] withString:@"   "];
//        [chatContentLabel setText:suContent];
//        
//        NSString *imgPath = [content substringWithRange:NSMakeRange(range.location, range.length+3)];
//        
//        UIImageView *faceImg = [UIImageView alloc] initWithImage
    }
    
    NSInteger with = lenth *13;
    NSInteger row = (ceil([content length]/16.0));
    NSLog(@"row == %d",row);
    NSInteger high = row * 16;
    NSInteger yNumber;
    if (row == 1) {
        high = 20;
        yNumber = 19+15;
    } else if (row == 2) {
        high = 40;
        yNumber = 19+5;
    } else {
        yNumber = 19;
    }
    
    if (userid != chatId) {
        [iconImg setFrame:CGRectMake(10, 19, 50, 50)];
        [chatBgImg setFrame:CGRectMake(65, yNumber, with+20, high+2)];
        [chatBgImg setImage:[UIImage imageNamed:@"message_content_recieve.png"]];
        [chatContentLabel setFrame:CGRectMake(79, yNumber + 2, with, high)];
    } else {
        [iconImg setFrame:CGRectMake(260, 19, 50, 50)];
        [chatBgImg setFrame:CGRectMake(320-60-15-with-10, yNumber, with+20, high+2)];
        [chatBgImg setImage:[UIImage imageNamed:@"message_content_sent.png"]];
        [chatContentLabel setFrame:CGRectMake(320-60-15-with, yNumber + 2, with, high)];
    }
    
    [iconImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MM_URL, model.pic_path]] placeholderImage:[UIImage imageNamed:@"personalCenter_icon.png"]];
    [timeLabel setText:model.time];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
