//
//  MPictureVC.m
//  Maomao
//
//  Created by  zhao on 13-11-12.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MPictureVC.h"
#import "UIImageView+WebCache.h"
#import "MBackBtn.h"
#import "MTitleView.h"


@interface MPictureVC () <UIScrollViewDelegate>
{
    UIScrollView     *pictureScrollView;
    NSInteger         totalCountOfSet;
    NSInteger         numberOfSet;
    MTitleView       *titleView;
}

@end

@implementation MPictureVC

@synthesize models;

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
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)currentPic:(NSInteger)number numbers:(NSInteger)count
{
    numberOfSet = number;
    totalCountOfSet = count;
    
    NSLog(@"number == %d",numberOfSet);
    titleView = [[MTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    titleView.titleName.text = [NSString stringWithFormat:@"酒吧图片(%d/%d)",numberOfSet+1 ,totalCountOfSet];
    self.navigationItem.titleView = titleView;
    
    pictureScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0+(noiOS7?0:64), 320, 416+(iPhone5?88:0))];
    
    [pictureScrollView setContentSize:CGSizeMake(320 * totalCountOfSet, 416+(noiOS7?0:64)+(iPhone5?88:0))];
    NSInteger offSet = numberOfSet;
    [pictureScrollView setContentOffset:CGPointMake(320 * offSet, 0)];
    [pictureScrollView setPagingEnabled:YES];
    [pictureScrollView setDelegate:self];
    
    for (int i = 1; i <= totalCountOfSet; i++) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(320*(i-1), 0, 320, 416+(iPhone5?88:0))];
        
        MBarEnvironmentModel *model = [models objectAtIndex:i-1];
        NSString *imgUrl = [NSString stringWithFormat:@"%@%@",MM_URL ,model.pic_path];
        [image setImageWithURL:[NSURL URLWithString:imgUrl]];
        [image setContentMode:UIViewContentModeScaleAspectFit];
        [pictureScrollView addSubview:image];
        
    }
    
    [self.view addSubview:pictureScrollView];
    
//    if (!noiOS7) {
//        for (UIView *view in self.view.subviews) {
//            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+64, view.frame.size.width, view.frame.size.height)];
//        }
//    }

}

-(void)scrollViewDidScroll:(UIScrollView *) scrollView
{
    int x = pictureScrollView.contentOffset.x;
    numberOfSet = x / 320 + 1;
    titleView.titleName.text = [NSString stringWithFormat:@"酒吧图片(%d/%d)",numberOfSet ,totalCountOfSet];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
