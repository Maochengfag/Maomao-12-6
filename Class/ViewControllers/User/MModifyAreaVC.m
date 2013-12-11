//
//  MBarAreaChoice.m
//  Maomao
//
//  Created by maochengfang on 13-10-25.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MModifyAreaVC.h"
#import "MBackBtn.h"
#import "MRightBtn.h"
#import "MTitleView.h"
#import "Utils.h"
#import "JSON.h"
#import "MAreaModel.h"

@interface MModifyAreaVC () <UITableViewDataSource, UITableViewDelegate>
{
    BOOL                isNetWork;
    NSMutableArray     *areaSource;
    UITableView        *areaTV;
}

@end

@implementation MModifyAreaVC

@synthesize sendRequest;
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
    titleView.titleName.text = @"地区选择";
    self.navigationItem.titleView = titleView;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.91 alpha:1.0]];
    
    MBackBtn *backBtn = [MBackBtn buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    areaSource = [NSMutableArray arrayWithCapacity:0];
    areaTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416+(iPhone5?88:0)+(noiOS7?0:64)) style:UITableViewStylePlain];
    [areaTV setDelegate:self];
    [areaTV setDataSource:self];
    [areaTV setRowHeight:32];
    [self.view addSubview:areaTV];
    
    hud = [[MBProgressHUD alloc] init];
    [hud setLabelText:@"加载中..."];
    [hud show:YES];
    [self.view addSubview:hud];

    NSString *url = [NSString stringWithFormat:@"%@/restful/area",MM_URL];
    [self sendRequest:url];
    
//    if (!noiOS7) {
//        for (UIView *view in self.view.subviews) {
//            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+64, view.frame.size.width, view.frame.size.height)];
//        }
//    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendRequest:(NSString *)urlString
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
    
    NSLog(@"response == %@",request);
    if (response == nil || [response JSONValue] == nil) {
        return;
    }
    
    NSDictionary *responseDict = [response JSONValue];
    
    NSArray *cityList = [responseDict objectForKey:@"list"];
    for (NSDictionary *dict in cityList) {
        MAreaModel *model = [[MAreaModel alloc] init];
        model.code = [dict objectForKey:@"code"];
        model.name = [dict objectForKey:@"name"];
        model.country = [dict objectForKey:@"country"];
        model.city_list = [dict objectForKey:@"city_list"];
        model.areaId = [dict objectForKey:@"id"];
        [areaSource addObject:model];
    }
    
    [areaTV reloadData];
    
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

#pragma mark - 
#pragma mark UITabelView Delegate DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [areaSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MAreaModel *model = [areaSource objectAtIndex:section];
    NSArray *citys = model.city_list;
    
    return [citys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    
    if (!noiOS7) {
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    MAreaModel *model = [areaSource objectAtIndex:indexPath.section];
    NSArray *citys = model.city_list;
    NSDictionary *city = [citys objectAtIndex:indexPath.row];
    
    NSString *name = [city objectForKey:@"name"];
    [cell.textLabel setText:name];
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    MAreaModel *model = [areaSource objectAtIndex:section];
    NSString *name = model.name;
    return name;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MAreaModel *model = [areaSource objectAtIndex:indexPath.section];
    NSInteger areaId = [model.areaId integerValue];
    NSArray *citys = model.city_list;
    NSDictionary *city = [citys objectAtIndex:indexPath.row];
    NSString *cityId = [city objectForKey:@"id"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    NSString *urlString = [NSString stringWithFormat:@"%@/restful/user/user_info/%@" ,MM_URL, userid];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    [hud setLabelText:@"保存中..."];
    [hud show:YES];

    formDataRequest = [ASIFormDataRequest requestWithURL:url];
    
    [formDataRequest setDelegate:self];
    [formDataRequest setTimeOutSeconds:kRequestTime];
    [formDataRequest setDidFailSelector:@selector(requestDidFailed:)];
    [formDataRequest setDidFinishSelector:@selector(requestDidSuccess:)];
    [formDataRequest setRequestMethod:@"POST"];
    
    NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:PASSWORD];
    ;
    
    [formDataRequest addPostValue:password forKey:@"password"];

    [formDataRequest addPostValue:model.areaId forKey:@"province_id"];
    
    if (areaId == 1 || areaId == 2 || areaId == 9 || areaId == 22) {
        [formDataRequest addPostValue:cityId forKey:@"county_id"];
    } else {
        [formDataRequest addPostValue:cityId forKey:@"city_id"];
    }
    
    [formDataRequest startAsynchronous];
    
}

- (void)requestDidFailed:(ASIFormDataRequest *)request
{
    [hud hide:YES];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络无法连接，请检查网络连接" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alertView show];
}

- (void) requestDidSuccess:(ASIFormDataRequest *)request
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
        
        NSDictionary *userInfo = [respponseDict objectForKey:@"user_info"];
        NSString *county = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"county"]];
        [[NSUserDefaults standardUserDefaults] setInteger:4 forKey:kModifyType];
        [[NSUserDefaults standardUserDefaults] setObject:county forKey:kCounty];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIAlertView *OK = [[UIAlertView alloc] initWithTitle:@"重要提示" message:@"城市设置成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
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
