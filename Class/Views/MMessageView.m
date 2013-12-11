//
//  MMessageView.m
//  Maomao
//
//  Created by  zhao on 13-11-6.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MMessageView.h"

@implementation MMessageView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.91 alpha:1.0]];

        UIImageView *topBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0+(noiOS7?0:20), 320, 44)];
        [topBar setImage:[UIImage imageNamed:@"common_topBar_blue.png"]];
        [topBar setUserInteractionEnabled:YES];
        [self addSubview:topBar];
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setFrame:CGRectMake(14, 10, 30, 24)];
        [leftBtn setImage:[UIImage imageNamed:@"common_btn_left.png"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(leftSlider) forControlEvents:UIControlEventTouchUpInside];
        [topBar addSubview:leftBtn];
        
        UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 180, 44)];
        [titleName setTextColor:[UIColor whiteColor]];
        [titleName setText:@"消 息"];
        [titleName setFont:[UIFont boldSystemFontOfSize:20]];
        [titleName setBackgroundColor:[UIColor clearColor]];
        [titleName setTextAlignment:NSTextAlignmentCenter];
        [topBar addSubview:titleName];
        
        UIButton *systemMessageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [systemMessageBtn setFrame:CGRectMake(0, 44+(noiOS7?0:20), 320, 42)];
        [systemMessageBtn addTarget:self action:@selector(gotoMessage:) forControlEvents:UIControlEventTouchUpInside];
        [systemMessageBtn setTag:111];
        [self addSubview:systemMessageBtn];
        
        UILabel *systemLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 120, 42)];
        [systemLable setBackgroundColor:[UIColor clearColor]];
        [systemLable setText:@"系统消息"];
        [systemLable setTextColor:[UIColor colorWithRed:0.20 green:0.40 blue:0.47 alpha:1.0]];
        [systemLable setFont:[UIFont systemFontOfSize:13]];
        [systemMessageBtn addSubview:systemLable];
        
        UIImageView *firstArrow = [[UIImageView alloc] initWithFrame:CGRectMake(300, 14, 10, 14)];
        [firstArrow setImage:[UIImage imageNamed:@"setting_img_greenArrow.png"]];
        [systemMessageBtn addSubview:firstArrow];
        
        UIImageView *firstLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 41, 320, 1)];
        [firstLine setImage:[UIImage imageNamed:@"common_img_longLine.png"]];
        [systemMessageBtn addSubview:firstLine];
        
        UIButton *privateMessageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [privateMessageBtn setFrame:CGRectMake(0, 44 + (noiOS7?0:20) + 42, 320, 42)];
        [privateMessageBtn addTarget:self action:@selector(gotoMessage:) forControlEvents:UIControlEventTouchUpInside];
        [privateMessageBtn setTag:222];
        [self addSubview:privateMessageBtn];
        
        UILabel *privateLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 120, 42)];
        [privateLable setBackgroundColor:[UIColor clearColor]];
        [privateLable setText:@"私信消息"];
        [privateLable setTextColor:[UIColor colorWithRed:0.20 green:0.40 blue:0.47 alpha:1.0]];
        [privateLable setFont:[UIFont systemFontOfSize:13]];
        [privateMessageBtn addSubview:privateLable];
        
        UIImageView *secondArrow = [[UIImageView alloc] initWithFrame:CGRectMake(300, 14, 10, 14)];
        [secondArrow setImage:[UIImage imageNamed:@"setting_img_greenArrow.png"]];
        [privateMessageBtn addSubview:secondArrow];
        
        UIImageView *secondLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 41, 320, 1)];
        [secondLine setImage:[UIImage imageNamed:@"common_img_longLine.png"]];
        [privateMessageBtn addSubview:secondLine];
    }
    return self;
}

- (void)leftSlider
{
    [delegate messageLeftSlider];
}

- (void)gotoMessage:(UIButton *)button
{
    [delegate gotoMessageDetails:button.tag];
}

@end
