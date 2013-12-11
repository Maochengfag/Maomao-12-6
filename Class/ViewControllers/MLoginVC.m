//
//  MLoginVC.m
//  Maomao
//
//  Created by  zhao on 13-10-17.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MLoginVC.h"
#import "MMainVC.h"
#import "Utils.h"
#import "JSON.h"
#import "GPPrompting.h"

@interface MLoginVC () <UINavigationControllerDelegate>
{
    MMainVC                 *mainVC;
    NSString                *loginType;
    GPPrompting             *prompting;
}

@end

@implementation MLoginVC

@synthesize usernameTF;
@synthesize passwdTF;

@synthesize formDataRequest;
@synthesize navigat;
@synthesize registerVC;

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
	// Do any additional setup after loading the view.
    [usernameTF becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginAccount:(UIButton *)sender
{
    if ([self.usernameTF.text isEqualToString:@""]) {
        if (prompting != nil) {
            [prompting removeFromSuperview];
            prompting = nil;
        }
        prompting = [[GPPrompting alloc] initWithView:self.view Text:@"请输入昵称/邮箱/手机号" Icon:nil];
        [self.view addSubview:prompting];
        [prompting show];
        return;
    }
    
    if ([self.passwdTF.text isEqualToString:@""]) {
        if (prompting != nil) {
            [prompting removeFromSuperview];
            prompting = nil;
        }
        prompting = [[GPPrompting alloc] initWithView:self.view Text:@"密码不能为空" Icon:nil];
        [self.view addSubview:prompting];
        [prompting show];
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@/restful/user/login",MM_URL];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    formDataRequest = [ASIFormDataRequest requestWithURL:url];
    
    [formDataRequest setDelegate:self];
    [formDataRequest setTimeOutSeconds:kRequestTime];
    [formDataRequest setDidFailSelector:@selector(requestDidFailed:)];
    [formDataRequest setDidFinishSelector:@selector(requestDidSuccess:)];
    [formDataRequest setRequestMethod:@"POST"];
    
    loginType = [NSString stringWithFormat:@"0"];

    [formDataRequest addPostValue:loginType forKey:@"login_type"];
    [formDataRequest addPostValue:usernameTF.text forKey:@"user_name"];
    [formDataRequest addPostValue:passwdTF.text forKey:@"password"];

    [formDataRequest startAsynchronous];
}

- (IBAction)gotoRegister:(UIButton *)sender
{
    registerVC = [[MRegisterVC alloc] init];
    
    [self presentViewController:registerVC animated:NO completion:nil];
}

- (void)requestDidFailed:(ASIFormDataRequest *)request
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络无法连接，请检查网络连接" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alertView show];
}

- (void)requestDidSuccess:(ASIFormDataRequest *)request
{
    [usernameTF resignFirstResponder];
    [passwdTF resignFirstResponder];
    
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
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunchTag"]; //标记已登陆

        UIAlertView *OK = [[UIAlertView alloc] initWithTitle:@"重要提示" message:@"登陆成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [OK show];
        
        NSDictionary *userDict = [respponseDict objectForKey:@"user"];
        NSString *nickName = [userDict objectForKey:NICKNAME];
        NSString *loginName = [userDict objectForKey:LOGINNAME];
        NSString *userid = [userDict objectForKey:@"id"];
        [[NSUserDefaults standardUserDefaults] setObject:nickName forKey:NICKNAME];
        [[NSUserDefaults standardUserDefaults] setObject:loginName forKey:LOGINNAME];
        [[NSUserDefaults standardUserDefaults] setObject:loginType forKey:LOGIN_TYPE];
        [[NSUserDefaults standardUserDefaults] setObject:userid forKey:USERID];
        [[NSUserDefaults standardUserDefaults] setObject:passwdTF.text forKey:PASSWORD];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"nickName == %@",nickName);

        mainVC = [[MMainVC alloc] init];
        navigat = [[UINavigationController alloc] initWithRootViewController:mainVC];
        navigat.delegate = self;
        [navigat.navigationBar setBackgroundImage:[UIImage imageNamed:@"common_barBg_top.png"] forBarMetrics:UIBarMetricsDefault];
        
        [self presentViewController:navigat animated:NO completion:nil];
        
    } else if (status == 1) {
        NSString *message = [respponseDict objectForKey:@"message"];
        UIAlertView *OK = [[UIAlertView alloc] initWithTitle:@"重要提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [OK show];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == mainVC) {
        [navigationController setNavigationBarHidden:YES animated:YES];
    } else if ([navigationController isNavigationBarHidden]) {
        [navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [usernameTF resignFirstResponder];
    [passwdTF resignFirstResponder];
}

@end
