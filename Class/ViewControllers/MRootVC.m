//
//  MRootVC.m
//  Maomao
//
//  Created by  zhao on 13-10-16.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MRootVC.h"
#import "MLoginVC.h"

@interface MRootVC () <UIScrollViewDelegate>

@end

@implementation MRootVC

@synthesize rootScroll;
@synthesize rootPage;
@synthesize navigation;

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
    rootScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480+(iPhone5?88:0))];
    [rootScroll setContentSize:CGSizeMake(320*3, 480+(iPhone5?88:0))];
    [rootScroll setDelegate:self];
    [rootScroll setShowsHorizontalScrollIndicator:NO];
    [rootScroll setShowsVerticalScrollIndicator:NO];
    [rootScroll setPagingEnabled:YES];
    [self.view addSubview:rootScroll];
    
    rootPage = [[UIPageControl alloc] initWithFrame:CGRectMake(106, 415+(iPhone5?88:0), 108, 36)];
    [rootPage setNumberOfPages:3];
    [self.view addSubview:rootPage];
    
    UIImageView *firstImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480+(iPhone5?88:0))];
    [firstImg setImage:[UIImage imageNamed:@"guide_1.jpg"]];
    [rootScroll addSubview:firstImg];
    
    UIImageView *secondImg = [[UIImageView alloc] initWithFrame:CGRectMake(320, 0, 320, 480+(iPhone5?88:0))];
    [secondImg setImage:[UIImage imageNamed:@"guide_2.jpg"]];
    [rootScroll addSubview:secondImg];
    
    UIImageView *thirdImg = [[UIImageView alloc] initWithFrame:CGRectMake(640, 0, 320, 480+(iPhone5?88:0))];
    [thirdImg setImage:[UIImage imageNamed:@"guide_3.jpg"]];
    [thirdImg setUserInteractionEnabled:YES];
    [rootScroll addSubview:thirdImg];
    
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [startBtn setFrame:CGRectMake(120, 340+(iPhone5?68:0), 80, 44)];
    [startBtn addTarget:self action:@selector(startInto) forControlEvents:UIControlEventTouchUpInside];
    [thirdImg addSubview:startBtn];
}

- (void)startInto
{
    MLoginVC *loginVC = [[MLoginVC alloc] initWithNibName:(iPhone5?@"MLoginVC":@"MLoginVCi4") bundle:nil];
    [self presentViewController:loginVC animated:YES completion:nil];
}

#pragma mark -
#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = 320;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) +1;
    self.rootPage.currentPage = page;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
