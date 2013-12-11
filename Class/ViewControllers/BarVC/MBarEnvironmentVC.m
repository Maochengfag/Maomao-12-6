//
//  MBarEnvironmentVC.m
//  Maomao
//
//  Created by  zhao on 13-10-17.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MBarEnvironmentVC.h"
#import "MBackBtn.h"
#import "Utils.h"
#import "JSON.h"
#import "UIButton+WebCache.h"
#import "MBarEnvironmentModel.h"
#import "MPictureVC.h"
#import "MTitleView.h"

@interface MBarEnvironmentVC ()

@end

@implementation MBarEnvironmentVC

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
    MTitleView *titleView = [[MTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    titleView.titleName.text = @"酒吧环境";
    self.navigationItem.titleView = titleView;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.91 alpha:1.0]];
    
    MBackBtn *backBtn = [MBackBtn buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    environmentSources = [NSMutableArray arrayWithCapacity:0];
    
    hud = [[MBProgressHUD alloc] init];
    [hud setLabelText:@"加载中，请稍等！"];
    [hud show:YES];
    [self.view addSubview:hud];
}

- (void) back
{
    [self.sendRequest clearDelegatesAndCancel];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark  Send Request Method

- (void)initWithRequestByUrl:(NSString *)urlString;
{
    isNetWork = [Utils checkCurrentNetWork];
    
    if (!isNetWork) {
        if (prompting != nil) {
            [prompting removeFromSuperview];
            prompting = nil;
        }
        prompting = [[GPPrompting alloc] initWithView:self.view Text:@"网络链接中断" Icon:nil];
        [self.view addSubview:prompting];
        [prompting show];
        return;
    }
    
    if (self.sendRequest != nil) {
        [self.sendRequest clearDelegatesAndCancel];
        self.sendRequest = nil;
    }
    
    NSURL * url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    self.sendRequest = [ASIHTTPRequest requestWithURL:url];
    [self.sendRequest setTimeOutSeconds:kRequestTime];
    [self.sendRequest setDelegate:self];
    [self.sendRequest startAsynchronous];
}

#pragma mark -
#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    
    if (response == nil || [response JSONValue] == nil) {
        return;
    }
    
    NSDictionary *responseDict = [response JSONValue];
    
    NSInteger status = [[responseDict objectForKey:@"status"] integerValue];
    NSArray *picList = [responseDict objectForKey:@"picture_list"];
    
    if (status == 0) {
        for (NSDictionary *picDict in picList) {
            MBarEnvironmentModel *model = [[MBarEnvironmentModel alloc] init];
            model.base_path = [picDict objectForKey:@"base_path"];
            model.cover = [picDict objectForKey:@"cover"];
            model.environmentid = [picDict objectForKey:@"id"];
            model.intro = [picDict objectForKey:@"intro"];
            model.latitude = [picDict objectForKey:@"latitude"];
            model.longitude = [picDict objectForKey:@"longitude"];
            model.name = [picDict objectForKey:@"name"];
            model.pic_name = [picDict objectForKey:@"pic_name"];
            model.pic_path = [picDict objectForKey:@"pic_path"];
            model.rel_path = [picDict objectForKey:@"rel_path"];
            
            model.thumbnail = [picDict objectForKey:@"thumbnail"];
            model.type_name = [picDict objectForKey:@"type_name"];
            model.upload_name = [picDict objectForKey:@"upload_name"];
            model.view_number = [picDict objectForKey:@"view_number"];

            [environmentSources addObject:model];
        }
    }
    
    [self setContent];
    [hud hide:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [hud hide:YES];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                       message:@"网络无法连接,请检查网络连接!"
                                                      delegate:self
                                             cancelButtonTitle:@"知道了"
                                             otherButtonTitles:nil];
    [alertView show];
}

- (void)setContent
{
    NSLog(@"count == %d",[environmentSources count]);
    NSInteger count = [environmentSources count];
    NSInteger row = 0;
    float xPoint;
    UIScrollView *scrollow = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 416+(iPhone5?88:0))];
    [scrollow setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:scrollow];
    
    for (int i = 0; i < count; i++) {
        MBarEnvironmentModel *model = [environmentSources objectAtIndex:i];
        switch (i % 4) {
            case 0:
                xPoint = 10.0f;
                (i == 0) ? (row = 0):(row++);
                break;
            case 1:
                xPoint = 10.0f + 77.0f;
                break;
            case 2:
                xPoint = 10.0f + 2 * 77.0f;
                break;
            case 3:
                xPoint = 10.0f + 3 * 77.0f;
                break;
            default:
                break;
        }
        
        NSString *imgUrl = [NSString stringWithFormat:@"%@%@",MM_URL ,model.pic_path];
        UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [imgBtn setImageWithURL:[NSURL URLWithString:imgUrl] forState:UIControlStateNormal];
        [imgBtn setTag:i];
        [imgBtn addTarget:self action:@selector(gotoPictVC:) forControlEvents:UIControlEventTouchUpInside];
        [imgBtn setFrame:CGRectMake(xPoint, 15 + (row * 75), 70, 70)];
    
        if ((!iPhone5 && row > 5) || (iPhone5 && row > 6)) {
            [scrollow addSubview:imgBtn];
        }  else {
            [self.view addSubview:imgBtn];
        }
    }

    if ((!iPhone5 && row > 5) || (iPhone5 && row > 6)) {
        [scrollow setContentSize:CGSizeMake(320, 15 + (row * 75))];
    }
    
    if (!noiOS7) {
        for (UIView *view in self.view.subviews) {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+64, view.frame.size.width, view.frame.size.height)];
        }
    }
}

- (void)gotoPictVC:(UIButton *)button
{
    NSInteger count = [environmentSources count];
    MPictureVC *pictureVC = [[MPictureVC alloc] init];
    pictureVC.models = environmentSources;
    NSLog(@"button.tag== %d",button.tag);
    [pictureVC currentPic:button.tag numbers:count];
    [self.navigationController pushViewController:pictureVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
