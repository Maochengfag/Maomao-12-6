//
//  MCollectView.m
//  Maomao
//
//  Created by  zhao on 13-11-6.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MCollectView.h"
#import "Utils.h"
#import "JSON.h"
#import "MBarDetailsVC.h"

@implementation MCollectView

@synthesize delegate;
@synthesize sendRequest;
@synthesize refreshHeaderView;
@synthesize lastUrlString;
@synthesize barListTV;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.91 alpha:1.0]];
        
        UIImageView *topBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0+(noiOS7?0:20), 320, 44)];
        [topBar setImage:[UIImage imageNamed:@"common_topBar_blue.png"]];
        [topBar setUserInteractionEnabled:YES];
        [self addSubview:topBar];
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setFrame:CGRectMake(14, 10, 30, 24)];
        [leftBtn setImage:[UIImage imageNamed:@"common_btn_left.png"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(leftSlider) forControlEvents:UIControlEventTouchUpInside];
        [topBar addSubview:leftBtn];
        
        UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 180, 44)];
        [titleName setTextColor:[UIColor whiteColor]];
        [titleName setText:@"酒吧收藏"];
        [titleName setFont:[UIFont boldSystemFontOfSize:20]];
        [titleName setBackgroundColor:[UIColor clearColor]];
        [titleName setTextAlignment:NSTextAlignmentCenter];
        [topBar addSubview:titleName];
        
        barListSources = [NSMutableArray arrayWithCapacity:0];
        currentIndex = 1;
        
        barListTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 44+(noiOS7?0:20), 320, 416+(iPhone5?88:0)) style:UITableViewStylePlain];
        [barListTV setDelegate:self];
        [barListTV setDataSource:self];
        [barListTV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [barListTV setBackgroundColor:[UIColor clearColor]];
        [barListTV setBackgroundView:nil];
        [barListTV setRowHeight:113.0f];
        [self addSubview:barListTV];
    }
    return self;
}

- (void)leftSlider
{
    [delegate collectLeftSlider];
}

#pragma mark -
#pragma mark  Send Request Method

-(void)initWithRequestByUrl:(NSString *)urlString
{
    self.lastUrlString = urlString;
    
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
    [super drawRect:rect];
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
        prompting = [[GPPrompting alloc] initWithView:self Text:@"网络链接中断" Icon:nil];
        [self addSubview:prompting];
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
        
        NSString *url = [NSString stringWithFormat:@"%@&page=%d",lastUrlString, currentIndex];
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
    
    [delegate gotoCollectBarDetail:model];
}

@end
