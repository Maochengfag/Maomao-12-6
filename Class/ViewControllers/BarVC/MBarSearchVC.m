//
//  MBarSearch.m
//  Maomao
//
//  Created by maochengfang on 13-10-28.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MBarSearchVC.h"
#import "MBackBtn.h"
#import "Utils.h"
#import "JSON.h"
#import "MBarListModel.h"
#import "UIButton+WebCache.h"
#import "MBarDetailsVC.h"
#import "MBarListVC.h"
#import "MTitleView.h"

@interface MBarSearchVC ()
{
    MBProgressHUD   *hud;
    GPPrompting     *prompting;
    BOOL             isNetWork;
}

@end

@implementation MBarSearchVC

@synthesize searchContentTF;
@synthesize sendRequest;
@synthesize sendSearchRequest;

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
    titleView.titleName.text = @"酒吧搜索";
    self.navigationItem.titleView = titleView;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.91 alpha:1.0]];
    
    MBackBtn *backBtn = [MBackBtn buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    searchArray = [NSMutableArray arrayWithCapacity:0];
    
    hud = [[MBProgressHUD alloc] init];
    [hud setLabelText:@"加载中，请稍等！"];
    [hud show:YES];
    [self.view addSubview:hud];
    
    NSString *url = [NSString stringWithFormat:@"%@/restful/pub/search/view",MM_URL];
    NSLog(@"url == %@",url);
    [self initWithRequestByUrl:url];
}

- (void)back
{
    [self.sendRequest clearDelegatesAndCancel];
    [self.sendSearchRequest clearDelegatesAndCancel];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchHotBar:(UIButton *)sender
{
    MBarListVC *barListVC = [[MBarListVC alloc] init];
    barListVC.isNoBarList = YES;
    [self.navigationController pushViewController:barListVC animated:YES];
    MTitleView *titleView = [[MTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    titleView.titleName.text = @"搜索酒吧列表";
    barListVC.navigationItem.titleView = titleView;
    NSString *url = [NSString stringWithFormat:@"%@/restful/pub/search?content=%@",MM_URL, searchContentTF.text];
    [barListVC initWithRequestByUrl:url];
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

- (void)sendSearchResultRequestByUrl:(NSString *)urlString;
{
    [hud setLabelText:@"搜索中，请稍等！"];
    [hud show:YES];

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
    
    if (self.sendSearchRequest != nil) {
        [self.sendSearchRequest clearDelegatesAndCancel];
        self.sendSearchRequest = nil;
    }
    
    NSURL * url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    self.sendSearchRequest = [ASIHTTPRequest requestWithURL:url];
    [self.sendSearchRequest setTimeOutSeconds:kRequestTime];
    [self.sendSearchRequest setDelegate:self];
    [self.sendSearchRequest startAsynchronous];
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
    
    if (request == sendRequest) {
        NSInteger status = [[responseDict objectForKey:@"status"] integerValue];
        NSArray *pubList = [responseDict objectForKey:@"pub_list"];

        if (status == 0) {
            for (NSDictionary *dict in pubList) {
                MBarListModel *model = [[MBarListModel alloc] init];
                
                model.city_id = [dict objectForKey:@"city_id"];
                model.county_id = [dict objectForKey:@"county_id"];
                model.email = [dict objectForKey:@"email"];
                model.fax = [dict objectForKey:@"fax"];
                model.barListId = [dict objectForKey:@"id"];
                model.intro = [dict objectForKey:@"intro"];
                model.latitude = [dict objectForKey:@"latitude"];
                model.longitude = [dict objectForKey:@"longitude"];
                model.mobile_list = [dict objectForKey:@"mobile_list"];
                model.name = [dict objectForKey:@"name"];
                
                model.pic_path = [dict objectForKey:@"pic_path"];
                model.province_id = [dict objectForKey:@"province_id"];
                model.recommend = [[dict objectForKey:@"recommend"] boolValue];
                model.street = [dict objectForKey:@"street"];
                model.tel_list = [dict objectForKey:@"tel_list"];
                model.type_name = [dict objectForKey:@"type_name"];
                model.view_number = [dict objectForKey:@"view_number"];
                model.web_url = [dict objectForKey:@"web_url"];
                
                [searchArray addObject:model];
            }
        }
        
        [self setKeywords];
        
        [hud hide:YES];
    }
    
    if (request == sendSearchRequest) {
        NSInteger status = [[responseDict objectForKey:@"status"] integerValue];
        
        if (status == 0) {
            
        }
        
        [hud hide:YES];
    }
    
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

- (void)setKeywords
{
    NSInteger count = [searchArray count];
    NSInteger row = 0;
    float xPoint;
    
    for (int i = 0; i < 3; i++) {
        MBarListModel *model = [searchArray objectAtIndex:i];
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
        
        UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [imgBtn setTitle:model.name forState:UIControlStateNormal];
        [imgBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [imgBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [imgBtn.titleLabel setAdjustsFontSizeToFitWidth:YES];
        [imgBtn.titleLabel setMinimumFontSize:8];
        [imgBtn setTag:[model.barListId integerValue]];
        [imgBtn addTarget:self action:@selector(gotoBarDetails:) forControlEvents:UIControlEventTouchUpInside];
        [imgBtn setFrame:CGRectMake(xPoint, 131 + (row * 30), 70, 21)];
        
        [self.view addSubview:imgBtn];
    }
    
    if (!noiOS7) {
        for (UIView *view in self.view.subviews) {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+64, view.frame.size.width, view.frame.size.height)];
        }
    }

}

- (void)gotoBarDetails:(UIButton *)button
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    MBarDetailsVC *detailsVC = [[MBarDetailsVC alloc] init];
    MTitleView *titleView = [[MTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    titleView.titleName.text = button.titleLabel.text;
    detailsVC.navigationItem.titleView = titleView;
    NSString *url = [NSString stringWithFormat:@"%@/restful/pub/detail?pub_id=%d&user_id=%@", MM_URL, button.tag, userid];
    [detailsVC initWithRequestByUrl:url];
    [self.navigationController pushViewController:detailsVC animated:YES];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [searchContentTF resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [searchContentTF resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
