//
//  MBarBirthday.m
//  Maomao
//
//  Created by maochengfang on 13-10-26.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MModifyBirthdayVC.h"
#import "MBackBtn.h"
#import "MRightBtn.h"
#import "MTitleView.h"
#import "Utils.h"
#import "JSON.h"
#import "GPPrompting.h"
#import "MBProgressHUD.h"

@interface MModifyBirthdayVC ()
{
    GPPrompting           *prompting;
    MBProgressHUD         *hud;
}

@end

@implementation MModifyBirthdayVC

@synthesize birthdayPicker;
@synthesize formDataRequest;

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
    titleView.titleName.text = @"生日设置";
    self.navigationItem.titleView = titleView;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.91 alpha:1.0]];
    
    MBackBtn *backBtn = [MBackBtn buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    MRightBtn *rightBtn = [MRightBtn buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(saveBirthday) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    hud = [[MBProgressHUD alloc] init];
    [hud setLabelText:@"保存中，请稍等！"];
    [self.view addSubview:hud];
    
    if (!noiOS7) {
        for (UIView *view in self.view.subviews) {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+64, view.frame.size.width, view.frame.size.height)];
        }
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveBirthday
{
    NSLog(@"birthday==%@",birthdayPicker.date);
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    NSString *urlString = [NSString stringWithFormat:@"%@/restful/user/user_info/%@" ,MM_URL, userid];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    formDataRequest = [ASIFormDataRequest requestWithURL:url];
    
    [formDataRequest setDelegate:self];
    [formDataRequest setTimeOutSeconds:kRequestTime];
    [formDataRequest setDidFailSelector:@selector(requestDidFailed:)];
    [formDataRequest setDidFinishSelector:@selector(requestDidSuccess:)];
    [formDataRequest setRequestMethod:@"POST"];
    
    NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:PASSWORD];
    ;
    
    [formDataRequest addPostValue:password forKey:@"password"];
    [formDataRequest addPostValue:birthdayPicker.date forKey:@"birthday"];
    
    [formDataRequest startAsynchronous];

}

- (void)requestDidFailed:(ASIFormDataRequest *)request
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络无法连接，请检查网络连接" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alertView show];
}

- (void) requestDidSuccess:(ASIFormDataRequest *)request
{
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
        
        NSDictionary *userInfo = [respponseDict objectForKey:@"user_info"];
        NSString *birthday = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"birthday"]];
        
        [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:kModifyType];
        [[NSUserDefaults standardUserDefaults] setObject:birthday forKey:kBirthday];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIAlertView *OK = [[UIAlertView alloc] initWithTitle:@"重要提示" message:@"个性签名成功保存！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [OK show];
        
    } else if (status == 1) {
        NSString *message = [respponseDict objectForKey:@"message"];
        UIAlertView *OK = [[UIAlertView alloc] initWithTitle:@"重要提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [OK show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self back];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
