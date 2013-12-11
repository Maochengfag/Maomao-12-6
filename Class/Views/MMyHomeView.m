//
//  MMyHomeView.m
//  Maomao
//
//  Created by zhao on 13-11-18.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MMyHomeView.h"
#import "UIImageView+WebCache.h"

@implementation MMyHomeView

@synthesize delegate;
@synthesize ageLabel;
@synthesize areaLabel;
@synthesize iconImg;
@synthesize nameLabel;
@synthesize signLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.91 alpha:1.0]];
        
        UIImageView *topBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0+(noiOS7?0:20), 320, 44)];
        [topBar setImage:[UIImage imageNamed:@"common_barBg_top.png"]];
        [topBar setUserInteractionEnabled:YES];
        [self addSubview:topBar];
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setFrame:CGRectMake(14, 10, 30, 24)];
        [leftBtn setImage:[UIImage imageNamed:@"common_btn_left.png"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(leftSlider) forControlEvents:UIControlEventTouchUpInside];
        [topBar addSubview:leftBtn];
        
        UIImageView *topImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44+(noiOS7?0:20), 320, 248)];
        [topImg setImage:[UIImage imageNamed:@"friends_black_big.png"]];
        [self addSubview:topImg];
        
        UIImageView *leftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(25,44+43+(noiOS7?0:20), 29, 28)];
        [leftIcon setImage:[UIImage imageNamed:@"friends_male.png"]];
        [self addSubview:leftIcon];
        
        //顶部个性签名
        signLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 180, 44)];
        [signLabel setTextColor:[UIColor whiteColor]];
        signLabel.text = [NSString stringWithFormat:@"个性签名：%@",[[NSUserDefaults standardUserDefaults] stringForKey:kSignature]];
//        [signLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [signLabel setAdjustsFontSizeToFitWidth:YES];
        [signLabel setBackgroundColor:[UIColor clearColor]];
        [signLabel setTextAlignment:NSTextAlignmentCenter];
        [topBar addSubview:signLabel];
        
        //头像
        iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(111, 44+28+(noiOS7?0:20), 166, 166)];
        [iconImg setUserInteractionEnabled:YES];
        NSString *headImgPath = [[NSUserDefaults standardUserDefaults] stringForKey:kPic_path];
        NSString *path = [NSString stringWithFormat:@"%@%@",MM_URL, headImgPath];
        [iconImg setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"friends_circle_Icon.png"]];
        [self addSubview:iconImg];
        
        //头像背景
        UIImageView *iconBG = [[UIImageView alloc] initWithFrame:CGRectMake(75, 44+6+(noiOS7?0:20), 240, 238)];
        [iconBG setImage:[UIImage imageNamed:@"friends_green_square.png"]];
        [self addSubview:iconBG];
        
        //年龄
        ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 44+100+(noiOS7?0:20), 68, 21)];
        [ageLabel setBackgroundColor:[UIColor clearColor]];
        [ageLabel setFont:[UIFont systemFontOfSize:13]];
        [ageLabel setTextColor:[UIColor whiteColor]];
        
        /****************设置年龄*****************************************/

        NSDate *current = [NSDate date];  //当前时间
        
        //格式化后台获取时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat : @"yyyy-MM-dd HH:mm:ss"];

        NSString *stringTime = [[NSUserDefaults standardUserDefaults] stringForKey:kBirthday];
        NSDate *birthday = [formatter dateFromString:stringTime];
        
        //计算年龄
        NSCalendar *systeCalendar = [NSCalendar currentCalendar];
        unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        NSDateComponents *dateComparisonComponents = [systeCalendar components:unitFlags fromDate:birthday toDate:current options:NSWrapCalendarComponents];
        
        [ageLabel setText:[NSString stringWithFormat:@"%d 岁",dateComparisonComponents.year]];
        [ageLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:ageLabel];
        
        /****************************************************************/

        //地区
        areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 44+130+(noiOS7?0:20), 68, 57)];
        [areaLabel setBackgroundColor:[UIColor clearColor]];
        [areaLabel setFont:[UIFont systemFontOfSize:13]];
        [areaLabel setNumberOfLines:0];
        [areaLabel setTextColor:[UIColor whiteColor]];
        areaLabel.text = [[[NSUserDefaults standardUserDefaults] stringForKey:kCounty] stringByReplacingOccurrencesOfString:@"$" withString:@""];
        [self addSubview:areaLabel];
        
        //姓名
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(117, 44+203+(noiOS7?0:20), 166, 20)];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setFont:[UIFont systemFontOfSize:15]];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [nameLabel setTextColor:[UIColor whiteColor]];
        [nameLabel setText:[[NSUserDefaults standardUserDefaults] stringForKey:NICKNAME]];
        [self addSubview:nameLabel];
        
        //设置
        UIImageView *settingImg = [[UIImageView alloc] initWithFrame:CGRectMake(287, 44+27+(noiOS7?0:20), 20, 20)];
        [settingImg setImage:[UIImage imageNamed:@"leftMenu_icon_setting.png"]];
        [self addSubview:settingImg];
        
        UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [settingBtn setFrame:CGRectMake(269, 44+20+(noiOS7?0:20), 46, 43)];
        [settingBtn addTarget:self action:@selector(gotoSettingUserInfo:) forControlEvents:UIControlEventTouchUpInside];
        [settingBtn setTag:11];
        [self addSubview:settingBtn];
        
        //收藏
        UIImageView *collectIcon = [[UIImageView alloc] initWithFrame:CGRectMake(25, 44+259+(noiOS7?0:20), 29, 29)];
        [collectIcon setImage:[UIImage imageNamed:@"leftMenu_icon_collect.png"]];
        [self addSubview:collectIcon];
        
        UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [collectBtn setFrame:CGRectMake(0, 44+252+(noiOS7?0:20), 320, 44)];
        [collectBtn addTarget:self action:@selector(gotoMyCollect:) forControlEvents:UIControlEventTouchUpInside];
        [collectBtn setTag:12];
        [self addSubview:collectBtn];
        
        UILabel *collectLabel = [[UILabel alloc] init];
        [collectLabel setBackgroundColor:[UIColor clearColor]];
        [collectLabel setText:@"我的收藏"];
        [collectLabel setFrame:CGRectMake(75, 0, 106, 44)];
        [collectLabel setFont:[UIFont systemFontOfSize:16]];
        [collectBtn addSubview:collectLabel];
        
        UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44+292+(noiOS7?0:20), 320, 3)];
        [lineImg setImage:[UIImage imageNamed:@"bar_detail_line.png"]];
        [self addSubview:lineImg];
        
        //私信
        UIImageView *messageIcon = [[UIImageView alloc] initWithFrame:CGRectMake(25, 44+259+44+(noiOS7?0:20), 29, 29)];
        [messageIcon setImage:[UIImage imageNamed:@"leftMenu_icon_message.png"]];
        [self addSubview:messageIcon];
        
        UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [messageBtn setFrame:CGRectMake(0, 44+252+44+(noiOS7?0:20), 320, 44)];
        [messageBtn addTarget:self action:@selector(gotoMyMessage:) forControlEvents:UIControlEventTouchUpInside];
        [messageBtn setTag:13];
        [self addSubview:messageBtn];
        
        UILabel *messageLabel = [[UILabel alloc] init];
        [messageLabel setBackgroundColor:[UIColor clearColor]];
        [messageLabel setText:@"我的私信"];
        [messageLabel setFrame:CGRectMake(75, 0, 106, 44)];
        [messageLabel setFont:[UIFont systemFontOfSize:16]];
        [messageBtn addSubview:messageLabel];
        
        UIImageView *lineImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44+292+44+(noiOS7?0:20), 320, 3)];
        [lineImg2 setImage:[UIImage imageNamed:@"bar_detail_line.png"]];
        [self addSubview:lineImg2];
    }
    return self;
}

- (void)leftSlider
{
    [delegate myHomeLeftSlider];
}

- (void)gotoSettingUserInfo:(UIButton *)sender
{
    [delegate myHomeGotoNext:sender.tag];
}

- (void)gotoMyCollect:(UIButton *)sender
{
    [delegate myHomeGotoNext:sender.tag];
}

- (void)gotoMyMessage:(UIButton *)sender
{
    [delegate myHomeGotoNext:sender.tag];
}

@end
