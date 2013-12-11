//
//  MMyCollectVC.m
//  Maomao
//
//  Created by zhao on 13-11-15.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MMyCollectVC.h"
#import "Utils.h"
#import "JSON.h"
#import "MBarDetailsVC.h"
#import "MBackBtn.h"
#import "MTitleView.h"
#import "MPersonalCenterVC.h"

@interface MMyCollectVC ()
{
    MPersonalCenterVC *personalCenter;
}
@end

@implementation MMyCollectVC

@synthesize isMyCollect;
@synthesize titleNameString;
@synthesize collectId;
@synthesize sendRequest;
@synthesize refreshHeaderView;
@synthesize barListTV;
@synthesize delegate;

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
    
    MTitleView *myCollectTitleView = [[MTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    
    self.navigationItem.titleView = myCollectTitleView;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.91 alpha:1.0]];
    
    MBackBtn *backBtn = [MBackBtn buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    barListSources = [NSMutableArray arrayWithCapacity:0];
    currentIndex = 1;
    
    barListTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416+(iPhone5?88:0)) style:UITableViewStylePlain];
    [barListTV setDelegate:self];
    [barListTV setDataSource:self];
    [barListTV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [barListTV setBackgroundColor:[UIColor clearColor]];
    [barListTV setBackgroundView:nil];
    [barListTV setRowHeight:113.0f];
    [self.view addSubview:barListTV];
    
    
    
    if (!noiOS7) {
        for (UIView *view in self.view.subviews) {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+64, view.frame.size.width, view.frame.size.height)];
        }
    }
    
    if (isMyCollect == YES) {
        myCollectTitleView.titleName.text = @"我的收藏";
        NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
        NSString *url = [NSString stringWithFormat:@"%@/restful/user/collect?user_id=%@",MM_URL, userid];
        [self initWithRequestByUrl:url];
    } else {
        myCollectTitleView.titleName.text = titleNameString;
        NSString *url = [NSString stringWithFormat:@"%@/restful/user/collect?user_id=%@",MM_URL, collectId];
        [self initWithRequestByUrl:url];
    }
}

- (void) back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark  Send Request Method

-(void)initWithRequestByUrl:(NSString *)urlString
{
    self.collectId = urlString;
    
    if (refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -70.0f, barListTV.frame.size.width,70.0f)];
        view.delegate = self;
        view.backgroundColor = [UIColor clearColor];
        [barListTV addSubview:view];
        self.refreshHeaderView = view;
    }
    
    [barListTV setContentOffset:CGPointMake(0, -65) animated:NO];
    [refreshHeaderView egoRefreshScrollViewDidScroll:barListTV];
    [refreshHeaderView egoRefreshScrollViewDidEndDragging:barListTV];
}

- (void)refaushTableViewData
{
    if(collectId == nil)
    {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@&page=%d",collectId, currentIndex];
    [self sendRequestByUrlString:url];
    NSLog(@"url === %@",url);
    
    NSLog(@"网络流量过去5秒的平均流量字节/秒 ==%lu",[ASIHTTPRequest averageBandwidthUsedPerSecond]);
}

#pragma mark - EGORefreshTableHeaderDelegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    currentIndex = 1;
    [barListSources removeAllObjects];
    [barListTV reloadData];
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
	[refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:barListTV];
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
    [self doneLoadingTableViewData];
    
    NSString *response = [request responseString];
    NSLog(@"response == %@",response);
    if (response == nil || [response JSONValue] == nil) {
        return;
    }
    
    NSDictionary *responseDict = [response JSONValue];
    
    NSInteger status = [[responseDict objectForKey:@"status"] integerValue];
    NSArray *pubList = [responseDict objectForKey:@"list"];
    if (status == 0) {
        for (NSDictionary *dict in pubList) {
            MBarCollectModel *model = [[MBarCollectModel alloc] init];
            
            model.city_county = [dict objectForKey:@"city_county"];
            model.city_id = [dict objectForKey:@"city_id"];
            model.county_id = [dict objectForKey:@"county_id"];
            model.difference = [dict objectForKey:@"difference"];
            model.email = [dict objectForKey:@"email"];
            model.fax = [dict objectForKey:@"fax"];
            model.collectid = [dict objectForKey:@"id"];
            model.intro = [dict objectForKey:@"intro"];
            model.latitude = [dict objectForKey:@"latitude"];
            model.longitude = [dict objectForKey:@"longitude"];
            
            model.mobile_list = [dict objectForKey:@"mobile_list"];
            model.name = [dict objectForKey:@"name"];
            model.pic_path = [dict objectForKey:@"pic_path"];
            model.province_id = [dict objectForKey:@"province_id"];
            model.recommend = [dict objectForKey:@"recommend"];
            model.street = [dict objectForKey:@"street"];
            model.tel_list = [dict objectForKey:@"tel_list"];
            model.view_number = [dict objectForKey:@"view_number"];
            model.web_url = [dict objectForKey:@"web_url"];
            
            [barListSources addObject:model];
            NSLog(@"barListSources count == %d",[barListSources count]);
        }
        
        currentIndex++;
        [barListTV reloadData];
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
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
    [delegate numberofCollection:[barListSources count]];
    return [barListSources count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cell";
    MBarCollectCell *cell = (MBarCollectCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"MBarCollectCell" owner:self options:nil];
        cell = barCollectCell;
    }
    
    if (!noiOS7) {
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    if ([barListSources count] > 0 && indexPath.row == [barListSources count]-1) {
        
        NSString *url = [NSString stringWithFormat:@"%@&page=%d",collectId, currentIndex];
        [self sendRequestByUrlString:url];
        NSLog(@"url === %@",url);
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    MBarCollectModel *model =[barListSources objectAtIndex:indexPath.row];
    [cell setCellInfoWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MBarCollectModel *model = [barListSources objectAtIndex:indexPath.row];
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    MBarDetailsVC *detailsVC = [[MBarDetailsVC alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/restful/pub/detail?pub_id=%@&user_id=%@", MM_URL, model.collectid, userid];
    MTitleView *titleView = [[MTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    titleView.titleName.text = model.name;
    detailsVC.navigationItem.titleView = titleView;
    [detailsVC initWithRequestByUrl:url];
    [self.navigationController pushViewController:detailsVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
