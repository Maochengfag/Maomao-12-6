//
//  MBarListVC.m
//  Maomao
//
//  Created by  zhao on 13-10-17.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MBarListVC.h"
#import "MBackBtn.h"
#import "MBarPicListModel.h"
#import "MBarListModel.h"
#import "Utils.h"
#import "JSON.h"
#import "UIButton+WebCache.h"
#import "MBarDetailsVC.h"
#import "MRightBtn.h"
#import "MBarSearchVC.h"
#import "MTitleView.h"

@interface MBarListVC () <UITableViewDataSource, UITableViewDelegate>
{
    MBProgressHUD   *hud;
    GPPrompting     *prompting;
    NSMutableArray  *barPicSources;
    NSMutableArray  *barListSources;
    BOOL             isNetWork;
    int              currentIndex;
}

@end

@implementation MBarListVC

@synthesize sendRequest;
@synthesize recommendScrollView;
@synthesize recommendPage;
@synthesize refreshHeaderView;
@synthesize urlStr;
@synthesize lastUrlString;
@synthesize barListTV;
@synthesize isNoBarList;

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
    [self.view setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.91 alpha:1.0]];
    
    MBackBtn *backBtn = [MBackBtn buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    MRightBtn *rightBtn = [MRightBtn buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    barPicSources = [NSMutableArray arrayWithCapacity:0];
    barListSources = [NSMutableArray arrayWithCapacity:0];
    currentIndex = 1;

    if (isNoBarList == NO) {  //标准酒吧列表页
        barListTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 126, 320, 290+(iPhone5?88:0)) style:UITableViewStylePlain];
        [self.view addSubview:barListTV];
    } else {      //搜索结果列表
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 416+(iPhone5?88:0))];
        [bgView setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.91 alpha:1.0]];
        [self.view addSubview:bgView];

        barListTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416+(iPhone5?88:0)) style:UITableViewStylePlain];
        [bgView addSubview:barListTV];
        
        [self.navigationItem setRightBarButtonItem:nil];  //隐藏右上角搜索按钮
    }
    [barListTV setDelegate:self];
    [barListTV setDataSource:self];
    [barListTV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [barListTV setBackgroundColor:[UIColor clearColor]];
    [barListTV setBackgroundView:nil];
    [barListTV setRowHeight:108.0f];
    
    hud = [[MBProgressHUD alloc] init];
    [hud setLabelText:@"加载中，请稍等！"];
    [self.view addSubview:hud];
    
    NSString *url = [NSString stringWithFormat:@"%@&city_id=%@",urlStr, @"0"];
    [self initWithRequestByUrl:url];
    
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

- (void)search
{
    NSLog(@"search");
    MBarSearchVC *barSearchVC = [[MBarSearchVC alloc] init];
    [self.navigationController pushViewController:barSearchVC animated:YES];
}

- (void)initWithRequestByUrl:(NSString *)urlString
{
    [hud show:YES];

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

- (IBAction)gotoNearBar:(UIButton *)sender  //附近酒吧
{
    double locationLongitude = [[[NSUserDefaults standardUserDefaults] stringForKey:LONGITUDE] doubleValue];
    double locationLatitude = [[[NSUserDefaults standardUserDefaults] stringForKey:LATITUDE] doubleValue];

    MBarListVC *barListVC = [[MBarListVC alloc] init];
    barListVC.isNoBarList = YES;
    [self.navigationController pushViewController:barListVC animated:YES];
    MTitleView *titleView = [[MTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    titleView.titleName.text = @"附近酒吧";
    barListVC.navigationItem.titleView = titleView;
    NSString *url = [NSString stringWithFormat:@"%@/restful/near/pub?longitude=%f&latitude=%f",MM_URL, locationLongitude, locationLatitude];
    [barListVC initWithRequestByUrl:url];
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
    if (response == nil || [response JSONValue] == nil) {
        return;
    }
    
    NSDictionary *responseDict = [response JSONValue];
    
    NSInteger status = [[responseDict objectForKey:@"status"] integerValue];
    NSArray *picList = [responseDict objectForKey:@"picture_list"];
    NSArray *pubList = [responseDict objectForKey:@"pub_list"];
    if (status == 0) {
        for (NSDictionary *dict in picList) {
            MBarPicListModel *model = [[MBarPicListModel alloc] init];
            
            model.base_path = [dict objectForKey:@"base_path"];
            model.cover = [dict objectForKey:@"cover"];
            model.picId = [dict objectForKey:@"id"];
            model.intro = [dict objectForKey:@"intro"];
            model.latitude = [dict objectForKey:@"latitude"];
            model.longitude = [dict objectForKey:@"longitude"];
            model.name = [dict objectForKey:@"name"];
            model.pic_name = [dict objectForKey:@"pic_name"];
            model.pic_path = [dict objectForKey:@"pic_path"];
            model.rel_path = [dict objectForKey:@"rel_path"];
            
            model.thumbnail = [dict objectForKey:@"thumbnail"];
            model.type_name = [dict objectForKey:@"type_name"];
            model.upload_name = [dict objectForKey:@"upload_name"];
            model.view_number = [dict objectForKey:@"view_number"];
            
            [barPicSources addObject:model];
        }
        
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
            
            [barListSources addObject:model];
        }
        
        currentIndex++;
        [barListTV reloadData];
    }
    

    [self setPicListConten];
    
    [hud hide:YES];
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

- (void)setPicListConten
{
    for (int i = 0; i < [barPicSources count]; i++) {
        MBarPicListModel *model = [barPicSources objectAtIndex:i];
        
        UIButton *picBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [picBtn addTarget:self action:@selector(gotoBarDetails:) forControlEvents:UIControlEventTouchUpInside];
        [picBtn setTag:[model.picId integerValue]];
        [picBtn setTitle:model.name forState:UIControlStateNormal];
        [picBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        NSString *picPath = [NSString stringWithFormat:@"%@%@",MM_URL, model.pic_path];
        [picBtn setImageWithURL:[NSURL URLWithString:picPath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"common_img_default.png"]];
        
        [picBtn setFrame:CGRectMake(i * 82, 0, 72, 72)];
        [recommendScrollView addSubview:picBtn];
    }
    
    [recommendScrollView setContentSize:CGSizeMake([barPicSources count] * 82, 72)];
    
    [recommendScrollView setContentSize:CGSizeMake([barPicSources count] * 82, 72)];
    [recommendPage setNumberOfPages:[barPicSources count]];
    timeLoop = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(scrollViewLoops:) userInfo:nil repeats:YES];

}

/*
 实现推荐酒吧轮播
 */
- (void)scrollViewLoops:(NSTimer *)time
{
    NSInteger offset = recommendScrollView.contentOffset.x;
    if (offset != ([barPicSources count])*82) {
        [UIView beginAnimations:@"loop" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5f];
        [recommendScrollView setContentOffset:CGPointMake(offset+82, 4)];
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:@"loop" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5f];
        [recommendScrollView setContentOffset:CGPointMake(34, 4)];
        [UIView commitAnimations];
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
    NSLog(@"BarDetail Url ==%@",url);
    [detailsVC initWithRequestByUrl:url];
    [self.navigationController pushViewController:detailsVC animated:YES];
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
    MBarListCell *cell = (MBarListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"MBarListCell" owner:self options:nil];
        cell = barListCell;
    }
    
    if (!noiOS7) {
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    if ([barListSources count] > 0 && indexPath.row == [barListSources count]-1) {
        
        NSString *url = [NSString stringWithFormat:@"%@&page=%d",lastUrlString, currentIndex];
        [self sendRequestByUrlString:url];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    MBarListModel *model =[barListSources objectAtIndex:indexPath.row];
    [cell setCellInfoWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MBarListModel *model = [barListSources objectAtIndex:indexPath.row];
    
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    MBarDetailsVC *detailsVC = [[MBarDetailsVC alloc] init];
    MTitleView *titleView = [[MTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    titleView.titleName.text = model.name;
    detailsVC.navigationItem.titleView = titleView;
    NSString *url = [NSString stringWithFormat:@"%@/restful/pub/detail?pub_id=%@&user_id=%@", MM_URL, model.barListId, userid];
    [detailsVC initWithRequestByUrl:url];
    [self.navigationController pushViewController:detailsVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
