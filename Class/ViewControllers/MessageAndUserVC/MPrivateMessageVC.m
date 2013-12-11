//
//  MPrivateMessageVC.m
//  Maomao
//
//  Created by  zhao on 13-11-11.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MPrivateMessageVC.h"
#import "MBackBtn.h"
#import "MTitleView.h"
#import "MRightBtn.h"
#import "Utils.h"
#import "JSON.h"
#import "MPrivateMessageModel.h"
#import "MChatListVC.h"

@interface MPrivateMessageVC () <UITableViewDataSource, UITableViewDelegate>
{
    MBProgressHUD   *hud;
    GPPrompting     *prompting;
    NSMutableArray  *messageListSources;
    BOOL             isNetWork;
    int              currentIndex;
}

@end

@implementation MPrivateMessageVC

@synthesize sendRequest;
@synthesize sendClearMessageRequest;
@synthesize refreshHeaderView;
@synthesize lastUrlString;
@synthesize messageListTV;

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
    titleView.titleName.text = @"我的私信";
    self.navigationItem.titleView = titleView;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.91 alpha:1.0]];
    
    MBackBtn *backBtn = [MBackBtn buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    MRightBtn *rightBtn = [MRightBtn buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(clearConten) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"清空" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    messageListSources = [NSMutableArray arrayWithCapacity:0];
    currentIndex = 1;

    messageListTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416+(iPhone5?88:0)) style:UITableViewStylePlain];
    [self.view addSubview:messageListTV];
    
    [messageListTV setDelegate:self];
    [messageListTV setDataSource:self];
    [messageListTV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [messageListTV setBackgroundColor:[UIColor clearColor]];
    [messageListTV setBackgroundView:nil];
    [messageListTV setRowHeight:75.0f];
    
    hud = [[MBProgressHUD alloc] init];
    [hud setLabelText:@"加载中，请稍等！"];
    [self.view addSubview:hud];
    
    [self initWithRequestByUrl:lastUrlString];
    
    if (!noiOS7) {
        for (UIView *view in self.view.subviews) {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+64, view.frame.size.width, view.frame.size.height)];
        }
    }

}

- (void)back
{
    [self.sendRequest clearDelegatesAndCancel];
    [self.sendClearMessageRequest clearDelegatesAndCancel];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clearConten
{
    hud = [[MBProgressHUD alloc] init];
    [hud setLabelText:@"正在清除..."];
    [hud show:YES];
    
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];

    NSString *url = [NSString stringWithFormat:@"%@/restful/user/clear/message?user_id=%@",MM_URL ,userid];
    [self sendClearMessageRequestByUrlString:url];
}

- (void)sendClearMessageRequestByUrlString:(NSString *)urlString
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
    
    if (self.sendClearMessageRequest != nil) {
        [self.sendClearMessageRequest clearDelegatesAndCancel];
        self.sendClearMessageRequest = nil;
    }
    
    NSURL * url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    self.sendClearMessageRequest = [ASIHTTPRequest requestWithURL:url];
    [self.sendClearMessageRequest setTimeOutSeconds:kRequestTime];
    [self.sendClearMessageRequest setDelegate:self];
    [self.sendClearMessageRequest startAsynchronous];
}

- (void)initWithRequestByUrl:(NSString *)urlString
{
    [hud show:YES];
    
    if (refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -70.0f, messageListTV.frame.size.width,70.0f)];
        view.delegate = self;
        view.backgroundColor = [UIColor clearColor];
        [messageListTV addSubview:view];
        self.refreshHeaderView = view;
    }
    
    [messageListTV setContentOffset:CGPointMake(0, -65) animated:NO];
    [refreshHeaderView egoRefreshScrollViewDidScroll:messageListTV];
    [refreshHeaderView egoRefreshScrollViewDidEndDragging:messageListTV];
}

- (void)refaushTableViewData
{
    if(lastUrlString == nil)
    {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@&page=%d",lastUrlString, currentIndex];
    [self sendRequestByUrlString:url];
    NSLog(@"url === %@",url);
    
    NSLog(@"网络流量过去5秒的平均流量字节/秒 ==%lu",[ASIHTTPRequest averageBandwidthUsedPerSecond]);
}

#pragma mark - EGORefreshTableHeaderDelegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    currentIndex = 1;
    [messageListSources removeAllObjects];
    [messageListTV reloadData];
    [self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date];
}

/**
 *	@brief	 开始下拉刷新
 */
- (void)reloadTableViewDataSource
{
    [self refaushTableViewData];
	reloading = YES;
}

/**
 *	@brief	结束下拉刷新
 */
- (void)doneLoadingTableViewData
{
	reloading = NO;
	[refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:messageListTV];
}

- (void)drawRect:(CGRect)rect
{
    [super.view drawRect:rect];
    /***************** 下拉刷新 *****************/
    
    
    // Drawing code
}

/************************************   下拉刷新部分 *****************************************/
#pragma mark - UITableView -> UIScrollviewDelegate
/**
 *	@brief	表格滚动时自动调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

/**
 *	@brief	结束拖拽时自动调用
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - Custom Private Method

- (void)sendRequestByUrlString:(NSString *)urlString
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
    if (request == sendRequest) {
        [self doneLoadingTableViewData];
        
        NSString *response = [request responseString];
        if (response == nil || [response JSONValue] == nil) {
            return;
        }
        
        NSDictionary *responseDict = [response JSONValue];
        
        NSInteger status = [[responseDict objectForKey:@"status"] integerValue];
        NSArray *list = [responseDict objectForKey:@"list"];
        if (status == 0) {
            for (NSDictionary *dict in list) {
                MPrivateMessageModel *model = [[MPrivateMessageModel alloc] init];
                
                model.receiver_id = [dict objectForKey:@"receiver_id"];
                model.open_id = [dict objectForKey:@"open_id"];
                model.admin = [dict objectForKey:@"admin"];
                model.sender_id = [dict objectForKey:@"sender_id"];
                model.age = [dict objectForKey:@"age"];
                model.time = [dict objectForKey:@"time"];
                model.sex = [dict objectForKey:@"sex"];
                model.sign_up_date = [dict objectForKey:@"sign_up_date"];
                model.login_name = [dict objectForKey:@"login_name"];
                model.content = [dict objectForKey:@"content"];
                
                model.nick_name = [dict objectForKey:@"nick_name"];
                model.send_time = [dict objectForKey:@"send_time"];
                model.login_type = [dict objectForKey:@"login_type"];
                model.pic_path = [dict objectForKey:@"pic_path"];
                model.system_message_time = [dict objectForKey:@"system_message_time"];
                model.password = [dict objectForKey:@"password"];
                model.friendId = [dict objectForKey:@"id"];
                
                [messageListSources addObject:model];
            }
            
            currentIndex++;
            [messageListTV reloadData];
        }
        
        [hud hide:YES];
    }
    
    if (request == sendClearMessageRequest) {
        NSLog(@"清空");
        
        [messageListSources removeAllObjects];
        [messageListTV reloadData];
        [hud hide:YES];

        if (prompting != nil) {
            [prompting removeFromSuperview];
            prompting = nil;
        }
        prompting = [[GPPrompting alloc] initWithView:self.view Text:@"私信已清空" Icon:nil];
        [self.view addSubview:prompting];
        [prompting show];
        return;
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [hud hide:YES];
    
    [self doneLoadingTableViewData];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                       message:@"网络无法连接,请检查网络连接!"
                                                      delegate:self
                                             cancelButtonTitle:@"知道了"
                                             otherButtonTitles:nil];
    [alertView show];
}

#pragma mark -
#pragma mark UITabelView Delegate DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [messageListSources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cell";
    MPrivateMessageCell *cell = (MPrivateMessageCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"MPrivateMessageCell" owner:self options:nil];
        cell = privateMessageCell;
    }
    
    if (!noiOS7) {
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    if ([messageListSources count] > 0 && indexPath.row == [messageListSources count]-1) {
        
        NSString *url = [NSString stringWithFormat:@"%@&page=%d",lastUrlString, currentIndex];
        [self sendRequestByUrlString:url];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    MPrivateMessageModel *model = [messageListSources objectAtIndex:indexPath.row];
    [cell setCellInfoWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPrivateMessageModel *model = [messageListSources objectAtIndex:indexPath.row];
    MChatListVC *chatListVC = [[MChatListVC alloc] init];
    chatListVC.senderId = [NSString stringWithFormat:@"%@",model.friendId];
    chatListVC.nameString = [NSString stringWithFormat:@"%@",model.nick_name];
    [self.navigationController pushViewController:chatListVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
