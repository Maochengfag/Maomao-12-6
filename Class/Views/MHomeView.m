//
//  MHomeView.m
//  Maomao
//
//  Created by  zhao on 13-11-6.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MHomeView.h"
#import "Utils.h"
#import "JSON.h"
#import "UIButton+WebCache.h"

@implementation MHomeView

@synthesize delegate;
@synthesize sendRequest;
@synthesize adPic_Path;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        UIImageView *topBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0+(noiOS7?0:20), 320, 44)];
        [topBar setImage:[UIImage imageNamed:@"common_barBg_top.png"]];
        [self setBackgroundColor:[UIColor whiteColor]];
        [topBar setUserInteractionEnabled:YES];
        [self addSubview:topBar];
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setFrame:CGRectMake(15, 10, 30, 24)];
        [leftBtn setImage:[UIImage imageNamed:@"common_btn_left.png"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(leftSlider) forControlEvents:UIControlEventTouchUpInside];
        [topBar addSubview:leftBtn];
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setFrame:CGRectMake(260, 10, 45, 24)];
        [rightBtn addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
        [topBar addSubview:rightBtn];
        
        UILabel *cityName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 32, 24)];
        [cityName setText:@"上海"];
        [cityName setTextColor:[UIColor whiteColor]];
        [cityName setFont:[UIFont systemFontOfSize:14]];
        [cityName setBackgroundColor:[UIColor clearColor]];
        [rightBtn addSubview:cityName];
        
        UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(32, 10, 10, 6)];
        [rightImg setImage:[UIImage imageNamed:@"common_img_down_arrow.png"]];
        [rightBtn addSubview:rightImg];
        
        homeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44+(noiOS7?0:20), 320, 416+(iPhone5?88:0))];
        [homeScrollView setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.91 alpha:1.0]];
        [self addSubview:homeScrollView];
        
        hud = [[MBProgressHUD alloc] init];
        [hud setLabelText:@"加载中，请稍等！"];
        [hud show:YES];
        [homeScrollView addSubview:hud];
        
        homeSources = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)leftSlider
{
    [delegate homeLeftSlider];
}

- (void)selectCity
{
    NSLog(@"selcetCity");
}

#pragma mark -
#pragma mark  Send Request Method

- (void)initWithRequestByUrl:(NSString *)urlString
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
    [self.sendRequest startSynchronous];
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
    //获取广告图片
    adPic_Path = [responseDict objectForKey:@"advertising_picture"];
    NSInteger status = [[responseDict objectForKey:@"status"] integerValue];
    NSArray *list = [responseDict objectForKey:@"list"];
    
    if (status == 0) {
        for (NSDictionary *dict in list) {
            MHomeModel *model = [[MHomeModel alloc] init];
            model.base_path = [dict objectForKey:@"base_path"];
            model.code = [dict objectForKey:@"code"];
            model.homeid = [dict objectForKey:@"id"];
            model.name = [dict objectForKey:@"name"];
            model.pic_name = [dict objectForKey:@"pic_name"];
            model.pic_path = [dict objectForKey:@"pic_path"];
            model.rel_path = [dict objectForKey:@"rel_path"];
            [homeSources addObject:model];
        }
    }
    
    [self setHomeConten];
    
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

- (void)setHomeConten   //设置主页内容
{
    NSInteger count = [homeSources count];  //总数量
    
    int xPoint;
    int row = 1;
    int hight;
    
    for (int i = 0; i < count; i++) {  //判断button位置
        MHomeModel *model = [homeSources objectAtIndex:i];
        
        switch (i % 2) {
            case 0:
                xPoint = 169;
                break;
            case 1:
                row++;
                xPoint = 14;
                break;
            default:
                break;
        }
        
        NSString *picPath = [NSString stringWithFormat:@"%@%@",MM_URL, model.pic_path];   //图片URL
        UIButton *barBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [barBtn setImageWithURL:[NSURL URLWithString:picPath] forState:UIControlStateNormal];
        [barBtn setTag:[model.homeid integerValue]];
        [barBtn addTarget:self action:@selector(gotoBarListVC:) forControlEvents:UIControlEventTouchUpInside];
        [barBtn setTitle:model.name forState:UIControlStateNormal];
        [barBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        
        if (row == 1) {
            [barBtn setFrame:CGRectMake(14, 14, 292, 129)];
            [barBtn setTag:[model.homeid integerValue]];
            
            //设置酒吧分类名称
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 260, 48)];
            [name setText:model.name];
            [name setBackgroundColor:[UIColor clearColor]];
            [name setFont:[UIFont boldSystemFontOfSize:26]];
            [name setTextColor:[UIColor whiteColor]];
            [name setTextAlignment:NSTextAlignmentLeft];
            [barBtn addSubview:name];
        } else {
            [barBtn setFrame:CGRectMake(xPoint, 14 + 129 + 14 + (row -2) * 100, 137, 86)];
            [barBtn setTag:[model.homeid integerValue]];
            
            //设置酒吧分类名称
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, 62, 132, 24)];
            [name setText:model.name];
            [name setBackgroundColor:[UIColor clearColor]];
            [name setFont:[UIFont boldSystemFontOfSize:17]];
            [name setTextColor:[UIColor whiteColor]];
            [name setTextAlignment:NSTextAlignmentRight];
            [barBtn addSubview:name];
        }
        
        [homeScrollView addSubview:barBtn];
        
        hight = barBtn.frame.origin.y + barBtn.frame.size.height + 14;
    }
    
    //初始化广告按钮
    NSString *adPicPath = [NSString stringWithFormat:@"%@%@",MM_URL,adPic_Path];
    UIButton *adBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [adBtn setImageWithURL:[NSURL URLWithString:adPicPath] forState:UIControlStateNormal];
    [adBtn addTarget:self action:@selector(gotoAdVC) forControlEvents:UIControlEventTouchUpInside];
    [adBtn setFrame:CGRectMake(0, hight-5, 320, 65)];
    
    [homeScrollView addSubview:adBtn];
    [homeScrollView setContentSize:CGSizeMake(320, hight+adBtn.frame.size.height)];
}

- (void)gotoAdVC
{
    NSLog(@"goto  AD.");
}
- (void)gotoBarListVC:(UIButton *)button
{
    [delegate gotoBarListVC:button.tag type:button.titleLabel.text];
}

@end
