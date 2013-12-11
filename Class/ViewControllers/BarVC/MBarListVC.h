//
//  MBarListVC.h
//  Maomao
//
//  Created by  zhao on 13-10-17.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "GPPrompting.h"
#import "MBarListCell.h"
#import "EGORefreshTableHeaderView.h"

@interface MBarListVC : UIViewController <ASIHTTPRequestDelegate, EGORefreshTableHeaderDelegate,UIScrollViewDelegate>
{
    IBOutlet MBarListCell *barListCell;
    BOOL                   reloading;
    NSTimer                 *timeLoop;
}

@property (weak, nonatomic) IBOutlet UIScrollView       *recommendScrollView;
@property (nonatomic, strong)   UIPageControl          *recommendPage;
@property (nonatomic, strong) ASIHTTPRequest            *sendRequest;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, copy)   NSString                  *urlStr;
@property (nonatomic, copy)   NSString                  *lastUrlString;
@property (nonatomic, strong) UITableView               *barListTV;
@property (nonatomic, assign) BOOL                       isNoBarList;

- (void)initWithRequestByUrl:(NSString *)urlString;
- (IBAction)gotoNearBar:(UIButton *)sender;

@end
