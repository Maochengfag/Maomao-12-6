//
//  MBarFeedback.m
//  Maomao
//
//  Created by maochengfang on 13-10-20.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MFeedbackVC.h"
#import "MBackBtn.h"
#import "MRightBtn.h"
#import "JSON.h"
#import "MTitleView.h"

@interface MFeedbackVC ()

@end

@implementation MFeedbackVC

@synthesize feedBackInfo;
@synthesize sendRequest;

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
    titleView.titleName.text = @"意见反馈";
    self.navigationItem.titleView = titleView;

    [self.view setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.91 alpha:1.0]];

    MBackBtn *backBtn = [MBackBtn buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    MRightBtn *rightBtn = [MRightBtn buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"发送" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(sendFeedbackInfo) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [feedBackInfo becomeFirstResponder];
    
    if (!noiOS7) {
        for (UIView *view in self.view.subviews) {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+64, view.frame.size.width, view.frame.size.height)];
        }
    }
}

- (void)back
{
    [self.sendRequest clearDelegatesAndCancel];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendFeedbackInfo
{
    [feedBackInfo resignFirstResponder];

    hud = [[MBProgressHUD alloc] init];
    [hud setLabelText:@"正在提交..."];
    [hud show:YES];
    [self.view addSubview:hud];

    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    NSString *setUrl = [[NSString alloc] initWithFormat:@"%@/restful/feed/back?content=%@&user_id=%@",MM_URL, feedBackInfo.text, userid];
    NSLog(@"setUrl == %@",setUrl);
    
    [self sendRequestByUrlString:setUrl];
}

#pragma mark -  Custom Private Method
- (void)sendRequestByUrlString:(NSString *)urlString
{
    if (self.sendRequest != nil) {
        [self.sendRequest clearDelegatesAndCancel];
        self.sendRequest = nil;
    }
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    self.sendRequest = [ASIHTTPRequest requestWithURL:url];
    [self.sendRequest setTimeOutSeconds:kRequestTime];
    [self.sendRequest setDelegate:self];
    [self.sendRequest startAsynchronous];
}

#pragma mark - ASIRequestDelegate 

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString  = [request responseString];
    
    if(responseString == nil || [responseString JSONValue] == nil) {
        return;
    }
    
    NSDictionary *responseDict = [responseString JSONValue];
    NSLog(@"responseString == %@",responseString);
    
    NSInteger status = [[responseDict objectForKey:@"status"] intValue];
    
    if (status == 0) {
        [hud setLabelText:@"提交成功!"];
        [self back];
    } else {
        [hud setLabelText:@"提交失败!"];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"网络无法连接" delegate:self cancelButtonTitle:@"知道了 " otherButtonTitles: nil];
    [alertView show];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [feedBackInfo resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setFeedBackInfo:nil];
    [super viewDidUnload];
}

@end
