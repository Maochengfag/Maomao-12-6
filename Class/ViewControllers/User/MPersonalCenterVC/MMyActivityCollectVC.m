//
//  MMyActivityCollectVC.m
//  Maomao
//
//  Created by maochengfang on 13-12-11.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MMyActivityCollectVC.h"
#import "Utils.h"
#import "MBackBtn.h"
#import "MTitleView.h"

@interface MMyActivityCollectVC ()

@end

@implementation MMyActivityCollectVC
@synthesize titleNameString;
@synthesize activityCollectId;
@synthesize sendRequest;
@synthesize refreshHeaderView;
@synthesize activityListTV;

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
    MTitleView *myActivityTitleView = [[MTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    myActivityTitleView.titleName.text =@"活动收藏";
    self.navigationItem.titleView = myActivityTitleView;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.91 alpha:1.0]];
    
    MBackBtn *backBtn = [MBackBtn buttonWithType:UIButtonTypeCustom];
    
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    activityListTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416+(iPhone5?88:0)) style:UITableViewStylePlain];
    [activityListTV setDelegate:self];
    [activityListTV setDataSource:self];
    [activityListTV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [activityListTV setBackgroundColor:[UIColor clearColor]];
    [activityListTV setBackgroundView:nil];
    [activityListTV setRowHeight:80.0f];
    
    [self.view addSubview:activityListTV];
    
    if (!noiOS7) {
        for (UIView *view in self.view.subviews) {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+64, view.frame.size.width, view.frame.size.height)];
        }
    }
    
    //等待接口
    
//    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
//    NSString *url = [NSString stringWithFormat:@"%@/restful/user/collect?user_id=%@",MM_URL, userid];
//    [self initWithRequestByUrl:url];
    
}

#pragma mark -
#pragma mark - Send Request Method


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
