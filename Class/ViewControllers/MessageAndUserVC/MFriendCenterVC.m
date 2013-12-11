//
//  MpersonalCenter.m
//  Maomao
//
//  Created by maochengfang on 13-10-28.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MFriendCenterVC.h"
#import "MBackBtn.h"
#import "MTitleView.h"
#import "MChatListVC.h"
#import "MMyCollectVC.h"
#import "Utils.h"
#import "JSON.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

@interface MFriendCenterVC ()
{
    MBProgressHUD *hud;
}

@property (nonatomic, strong) NSString *friendName;

@end

@implementation MFriendCenterVC

@synthesize friendId;
@synthesize friendSign;
@synthesize ageLabel;
@synthesize areaLabel;
@synthesize iconImg;
@synthesize nameLabel;
@synthesize collectNumberLabel;
@synthesize formDataRequest;

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
    MTitleView *titleView = [[MTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    titleView.titleName.text = [NSString stringWithFormat:@"个性签名:%@",friendSign];
    [titleView.titleName setAdjustsFontSizeToFitWidth:YES];
    self.navigationItem.titleView = titleView;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.91 alpha:1.0]];
    
    MBackBtn *backBtn = [MBackBtn buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
   if (!noiOS7) {
       for (UIView *view in self.view.subviews) {
           [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+64, view.frame.size.width, view.frame.size.height)];
       }
   }
    
    hud = [[MBProgressHUD alloc] init];
    [hud setLabelText:@"加载中，请稍等！"];
    [hud show:YES];
    [self.view addSubview:hud];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self friendInfo];
}

- (void)back
{
    [self.formDataRequest clearDelegatesAndCancel];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)friendInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@/restful/user/user_info/%@" ,MM_URL, friendId];
    NSLog(@"usrlString == %@",urlString);
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    formDataRequest = [ASIFormDataRequest requestWithURL:url];
    
    [formDataRequest setDelegate:self];
    [formDataRequest setTimeOutSeconds:kRequestTime];
    [formDataRequest setDidFailSelector:@selector(requestDidFailed:)];
    [formDataRequest setDidFinishSelector:@selector(requestDidSuccess:)];
    [formDataRequest setRequestMethod:@"POST"];
    
    [formDataRequest startSynchronous];
}

- (void)requestDidFailed:(ASIFormDataRequest *)request
{
    [hud hide:YES];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络无法连接，请检查网络连接" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alertView show];
}

- (void)requestDidSuccess:(ASIFormDataRequest *)request
{
    [hud hide:YES];

    NSLog(@"code:%d",[request responseStatusCode]);
    NSString *responseString = [request responseString];
    if (responseString == nil || [responseString JSONValue] == nil)
    {
        return;
    }
    NSLog(@"responseString==%@",responseString);
    NSDictionary *respponseDict = [responseString JSONValue];
    NSInteger status = [[respponseDict objectForKey:@"status"] integerValue];
    
    if (status == 0) {
        
        NSDictionary *userDict = [respponseDict objectForKey:@"user"];
        NSString *userid = [userDict objectForKey:@"id"];
        NSString *nickName = [userDict objectForKey:@"nick_name"];
        NSString *loginName = [userDict objectForKey:LOGINNAME];
        NSString *loginType = [userDict objectForKey:LOGIN_TYPE];
        
        NSDictionary *userInfo = [respponseDict objectForKey:@"user_info"];
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
        
        ageLabel.text = [NSString stringWithFormat:@"%d 岁",dateComparisonComponents.year];
        /****************************************************************/
        
        areaLabel.text = [[[NSUserDefaults standardUserDefaults] stringForKey:kCounty] stringByReplacingOccurrencesOfString:@"$" withString:@""];
        NSString *path = [NSString stringWithFormat:@"%@%@",MM_URL, pic_path];
        [iconImg  setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"common_userHeadImg.png"]];
        friendName = nickName;
        nameLabel.text = friendName;
        
    } else if (status == 1) {
        NSString *message = [respponseDict objectForKey:@"message"];
        UIAlertView *OK = [[UIAlertView alloc] initWithTitle:@"重要提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [OK show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendPrivateMessage:(UIButton *)sender
{
    MChatListVC *chatListVC = [[MChatListVC alloc] init];
    chatListVC.senderId = friendId;
    chatListVC.nameString = friendName;
    [self.navigationController pushViewController:chatListVC animated:YES];
}

- (IBAction)gotoFriendCollectBar:(UIButton *)sender
{
    MMyCollectVC *friendCollectVC = [[MMyCollectVC alloc] init];
    friendCollectVC.isMyCollect = NO;
    friendCollectVC.collectId = friendId;
    friendCollectVC.titleNameString = friendName;
    [self.navigationController pushViewController:friendCollectVC animated:YES];
}

@end
