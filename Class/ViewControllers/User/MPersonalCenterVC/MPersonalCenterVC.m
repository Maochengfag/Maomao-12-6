//
//  MPersonalCenterVC.m
//  Maomao
//
//  Created by maochengfang on 13-12-3.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MPersonalCenterVC.h"
#import "UIImageView+WebCache.h"
#import "MUserSettingVC.h"

@implementation MPersonalCenterVC

@synthesize delegate;
@synthesize areaLabel;
@synthesize Icon;
@synthesize nameLabel;
@synthesize signalLabel;
@synthesize ExperienceLabel;
@synthesize ExperienceTagLabel;
@synthesize IntegrationLabel;
@synthesize genderIcon;
@synthesize ageLabel;


/***********邀约，礼物，传情，私信,我的收藏，我的活动**********************/
@synthesize inviteNumLabel;
@synthesize inviteNotice;
@synthesize giftNumLabel;
@synthesize giftNotice;
@synthesize teaserNumLabel;
@synthesize teaserNotice;
@synthesize privateMsgNumLabel;
@synthesize privateMsgNotice;
@synthesize collectionNumLabel;
@synthesize activityNumLabel;
/****************************************************/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithRed:0.87 green:0.87 blue:0.89 alpha:1.0]];
    UIImageView *topBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0+(noiOS7?0:20), 320, 44)];
    [topBar setImage:[UIImage imageNamed:@"common_topBar_blue.png"]];
    [topBar setUserInteractionEnabled:YES];
    [self.view addSubview:topBar];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(14, 10, 30, 24)];
    [leftBtn setImage:[UIImage imageNamed:@"personal_choice_btn.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftSlider) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:leftBtn];
    
    UIButton *settingBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
    [settingBtn setFrame:CGRectMake(287, 15, 20, 20)];
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"personal_setting_btn.png"] forState:UIControlStateNormal];
    [settingBtn setTag:20];
    [settingBtn addTarget:self action:@selector(gotoSettingUserInfo1:) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:settingBtn];
    
    ///////////////////////////////////////////////
    
    NSString *headImgPath = [[NSUserDefaults standardUserDefaults] stringForKey:kPic_path];
    NSString *path = [NSString stringWithFormat:@"%@%@",MM_URL, headImgPath];

    signalLabel.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:kSignature]];
    
    /****************设置年龄******************/
    
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
    
    ageLabel.text = [NSString stringWithFormat:@"%ld",(long)dateComparisonComponents.year];
    
    areaLabel.text = [[[NSUserDefaults standardUserDefaults] stringForKey:kCounty]
                      stringByReplacingOccurrencesOfString:@"$" withString:@""];
    
    [Icon setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"common_userHeadImg.png"]];
    
    nameLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:NICKNAME];
    if (!noiOS7) {
        for (UIView *view in self.view.subviews) {
            if (![view isEqual: topBar]) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+64, view.frame.size.width, view.frame.size.height)];
            }
            
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)leftSlider
{
    [delegate personalCenterLeftSlider];
}

- (void)gotoSettingUserInfo1:(UIButton *)sender
{
    [delegate mPersonalCenterGotoNext:sender.tag];
}

- (IBAction)gotoNextVC:(UIButton *)sender
{
    [delegate mPersonalCenterGotoNext:sender.tag];
}

#pragma mark - MMyCollectionDelegate
- (void)numberofCollection:(NSInteger)num
{
    NSLog(@"num == %d",num);
}
@end
