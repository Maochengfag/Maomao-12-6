//
//  MRegisterVC.m
//  Maomao
//
//  Created by zhao on 13-11-14.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MRegisterVC.h"
#import "MMainVC.h"
#import "Utils.h"
#import "JSON.h"
#import "MRegisterProtocolVC.h"
#import "GPPrompting.h"

@interface MRegisterVC () <UINavigationControllerDelegate>
{
    MMainVC         *mainVC;
    BOOL             isAgree;
    GPPrompting     *prompting;
}

@end

@implementation MRegisterVC

@synthesize nicknameTF;
@synthesize emailTF;
@synthesize passwordTF;
@synthesize navigat;
@synthesize selectImg;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectProtocol:(UIButton *)sender
{
    if (isAgree == YES) {
        [self.selectImg setImage:[UIImage imageNamed:@"regester_unselect.png"]];
        isAgree = NO;
    } else {
        [self.selectImg setImage:[UIImage imageNamed:@"regester_selected.png"]];
        isAgree = YES;
    }
}

- (IBAction)lookProtocol:(UIButton *)sender
{
    MRegisterProtocolVC *registerProtocolVC = [[MRegisterProtocolVC alloc] init];
    [self presentViewController:registerProtocolVC animated:YES completion:nil];
}

- (IBAction)registerAccount:(UIButton *)sender
{
    if ([self.nicknameTF.text isEqualToString:@""]) {
        if (prompting != nil) {
            [prompting removeFromSuperview];
            prompting = nil;
        }
        prompting = [[GPPrompting alloc] initWithView:self.view Text:@"请输入昵称" Icon:nil];
        [self.view addSubview:prompting];
        [prompting show];
        return;
    }
    
    if ([self.emailTF.text isEqualToString:@""]) {
        if (prompting != nil) {
            [prompting removeFromSuperview];
            prompting = nil;
        }
        prompting = [[GPPrompting alloc] initWithView:self.view Text:@"请输入邮箱地址" Icon:nil];
        [self.view addSubview:prompting];
        [prompting show];
        return;
    }
    
    if ([self.passwordTF.text isEqualToString:@""]) {
        if (prompting != nil) {
            [prompting removeFromSuperview];
            prompting = nil;
        }
        prompting = [[GPPrompting alloc] initWithView:self.view Text:@"密码不能为空" Icon:nil];
        [self.view addSubview:prompting];
        [prompting show];
        return;
    }

    if (isAgree == NO) {
        if (prompting != nil) {
            [prompting removeFromSuperview];
            prompting = nil;
        }
        prompting = [[GPPrompting alloc] initWithView:self.view Text:@"阅读并同意《冒冒用户使用协议》，才能注册" Icon:nil];
        [self.view addSubview:prompting];
        [prompting show];
        return;
    }

    NSString *urlString = [NSString stringWithFormat:@"%@/restful/user/register",MM_URL];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    formDataRequest = [ASIFormDataRequest requestWithURL:url];
    
    [formDataRequest setDelegate:self];
    [formDataRequest setTimeOutSeconds:kRequestTime];
    [formDataRequest setDidFailSelector:@selector(requestDidFailed:)];
    [formDataRequest setDidFinishSelector:@selector(requestDidSuccess:)];
    [formDataRequest setRequestMethod:@"POST"];
    
    NSString *loginType = @"0";
    
    [formDataRequest addPostValue:loginType forKey:@"login_type"];
    [formDataRequest addPostValue:emailTF.text forKey:@"login_name"];
    [formDataRequest addPostValue:nicknameTF.text forKey:@"nick_name"];
    [formDataRequest addPostValue: passwordTF.text forKey:@"password"];
    
    [formDataRequest startAsynchronous];
}

- (void)requestDidFailed:(ASIFormDataRequest *)request
{
    NSLog(@"error");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络无法连接，请检查网络连接" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alertView show];
}

- (void)requestDidSuccess:(ASIFormDataRequest *)request
{
    [nicknameTF resignFirstResponder];
    [emailTF resignFirstResponder];
    [passwordTF  resignFirstResponder];
    
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
        NSString *nickName = [userDict objectForKey:NICKNAME];
        NSString *loginName = [userDict objectForKey:LOGINNAME];
        NSString *userid = [userDict objectForKey:@"id"];
        [[NSUserDefaults standardUserDefaults] setObject:nickName forKey:NICKNAME];
        [[NSUserDefaults standardUserDefaults] setObject:loginName forKey:LOGINNAME];
        [[NSUserDefaults standardUserDefaults] setObject:userid forKey:USERID];
        [[NSUserDefaults standardUserDefaults] setObject:passwordTF.text forKey:PASSWORD];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        mainVC = [[MMainVC alloc] init];
        navigat = [[UINavigationController alloc] initWithRootViewController:mainVC];
        navigat.delegate = self;
        [navigat.navigationBar setBackgroundImage:[UIImage imageNamed:@"common_barBg_top.png"] forBarMetrics:UIBarMetricsDefault];
        
        [self presentViewController:navigat animated:NO completion:nil];
        
        UIAlertView *OK = [[UIAlertView alloc] initWithTitle:@"重要提示" message:@"登陆成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [OK show];
        
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
    [nicknameTF resignFirstResponder];
    [emailTF resignFirstResponder];
    [passwordTF  resignFirstResponder];
}

@end
