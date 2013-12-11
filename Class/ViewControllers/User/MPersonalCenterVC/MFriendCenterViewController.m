//
//  MFriendCenterViewController.m
//  Maomao
//
//  Created by maochengfang on 13-12-5.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MFriendCenterViewController.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "JSON.h"
#import "MMyCollectVC.h"
#import "MChatListVC.h"

@interface MFriendCenterViewController ()
{
    MBProgressHUD *hud;
}
@property (nonatomic, copy) NSString *friendName;
@end

@implementation MFriendCenterViewController

@synthesize delegate;
@synthesize friendAgeLabel;
@synthesize friendLocationLabel;
@synthesize friendExpTagLabel;
@synthesize friendAreaLabel;
@synthesize genderLabel;
@synthesize numofGift;
@synthesize friendScrollView;
@synthesize friendIntegrationLabel;
@synthesize friendNameLabel;
@synthesize friendSignLabel;
@synthesize friendId;
@synthesize formDataReuqest;
@synthesize friendIcon;

@synthesize friendName;
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
//    UIImageView *topBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0+(noiOS7?0:20), 320, 44)];
//    [topBar setImage:[UIImage imageNamed:@"common_barBg_top.png"]];
//    [topBar setUserInteractionEnabled:YES];
//    [self.view addSubview:topBar];

    
    UIButton   *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(14, 10, 30, 24)];
    [leftBtn setImage:[UIImage imageNamed:@"personal_choice_btn.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setFrame:CGRectMake(287, 0, 20, 30)];
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [moreBtn setTintColor:[UIColor whiteColor]];
    [moreBtn addTarget:self action:@selector(moreList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    
    if (!noiOS7) {
        for (UIView *view in self.view.subviews) {
            //if (![view isEqual: topBar]) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+64, view.frame.size.width, view.frame.size.height)];
            //}
            
        }
    }
    
    hud = [[MBProgressHUD alloc] init];
    [hud setLabelText:@"加载中请稍后!"];
    [hud show:YES];
    [self.view addSubview:hud];

}

- (void)back
{
    [self.formDataReuqest clearDelegatesAndCancel];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self friendInfo];
    
}

- (void)friendInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@/restful/user/user_info/%@",MM_URL,friendId];
    NSLog(@"urlString == %@",urlString);
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    formDataReuqest = [ASIFormDataRequest requestWithURL:url];
    [formDataReuqest setDelegate:self];
    [formDataReuqest setTimeOutSeconds:kRequestTime];
    [formDataReuqest setDidFailSelector:@selector(requestDidFailed:)];
    [formDataReuqest setDidFinishSelector:@selector(requestDidSuccess:)];
    [formDataReuqest setRequestMethod:@"POST"];

    [formDataReuqest startSynchronous];
    
}

- (void)requestDidFailed:(ASIFormDataRequest *)request
{
    [hud hide:YES];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络无法连接，请检查网络" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alertView show];
}

- (void)requestDidSuccess:(ASIFormDataRequest *)request
{
    [hud hide:YES];
    
    NSLog(@"code:%d",[request responseStatusCode]);
    NSString *responseString = [request responseString];
    if (responseString == nil || [responseString JSONValue] == nil) {
        return;
    }
    NSDictionary *responseDict = [responseString JSONValue];
    NSInteger status = [[responseDict objectForKey:@"status"] integerValue];
    NSLog(@"status ==%d",status);
    if (status ==0) {
        NSDictionary *userDict = [responseDict objectForKey:@"user"];
        NSString *userid = [userDict objectForKey:@"id"];
        NSString *nickName = [userDict objectForKey:@"nick_name"];
        NSString *loginName = [userDict objectForKey:LOGINNAME];
        NSString *loginType = [userDict objectForKey:LOGIN_TYPE];
        
        NSDictionary *userInfo = [responseDict objectForKey:@"user_info"];
        NSString *tel = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"tel"]];
        NSString *city_id = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"city_id"]];
        NSString *sex = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"sex"]];
        NSString *county = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"county"]];
        NSString *street = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"street"]];
        NSString *county_id = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"county_id"]];
        NSString *ethnicity_id = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"ethnicity_id"]];
        NSString *upload_name = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"upload_name"]];
        NSString *email = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"email"]];
        NSString *company = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"company"]];
        NSString *base_path = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"base_path"]];
        NSString *job = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"job"]];
        NSString *birthday = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"birthday"]];
        NSString *rel_path = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"rel_path"]];
        NSString *province_id = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"province_id"]];
        NSString *pic_path = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"pic_path"]];
        NSString *birthday_type = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"birthday_type"]];
        NSString *mobile = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"mobile"]];
        NSString *real_name = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"real_name"]];
        NSString *intro = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"intro"]];
        NSString *signature = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"signature"]];
        NSString *pic_name = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"pic_name"]];
        
        /****************设置年龄******************/
        
        NSDate *current = [NSDate date];  //当前时间
        //格式化后台获取时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat : @"yyyy-MM-dd HH:mm:ss"];
        
        NSDate *birthdayDate = [formatter dateFromString:birthday];
        
        //计算年龄
        NSCalendar *systeCalendar = [NSCalendar currentCalendar];
        unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        NSDateComponents *dateComparisonComponents = [systeCalendar components:unitFlags fromDate:birthdayDate toDate:current options:NSWrapCalendarComponents];
        friendAgeLabel.text = [NSString stringWithFormat:@"%d",dateComparisonComponents.year];
        friendAreaLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:kCounty];
        NSString *path = [NSString stringWithFormat:@"%@%@",MM_URL,pic_path];
        [friendIcon setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"common_userHeadImg.png"]];
        friendName = nickName;
        friendNameLabel.text = friendName;
        NSLog(@"friendNameLabel.text==%@",friendNameLabel.text);
        
    }
    else if (status == 1) {
        NSString *message = [responseDict objectForKey:@"message"];
        UIAlertView *OK = [[UIAlertView alloc] initWithTitle:@"重要提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [OK show];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftSlider
{
    [delegate friendCenterLeftSlider];
}

- (void)moreList
{
    //待实现
    NSLog(@"屏蔽该好友，举报检举，取消");
}


- (IBAction)gotoClink:(UIButton *)sender
{
    //待实现
    NSLog(@"goto Clink.");
}

- (IBAction)haveTeaser:(UIButton *)sender
{
    //待实现
    NSLog(@" have Teaser.");
}

- (IBAction)sendGift:(UIButton *)sender
{
    //待实现
    NSLog(@"send gift");
    
    
}

- (IBAction)sendMsg:(UIButton *)sender
{
    MChatListVC *chatListVC = [[MChatListVC alloc] init];
    chatListVC.senderId = friendId;
    chatListVC.nameString = friendName;
    [self.navigationController pushViewController:chatListVC animated:YES];

}

- (IBAction)showGift:(UIButton *)sender
{
    //判断有没有礼物，如果有礼物， 将礼物图片显示在礼物按钮下方每一行五张图片，并且那么酒吧收藏按钮往下平移到离最后一行图片底部14像素
}
- (IBAction)barCollection:(UIButton *)sender
{
    MMyCollectVC *friendCollectVC = [[MMyCollectVC alloc] init];
    friendCollectVC.isMyCollect = NO;
    friendCollectVC.collectId = friendId;
    friendCollectVC.titleNameString = friendName;
    [self.navigationController pushViewController:friendCollectVC animated:YES];
}
@end
