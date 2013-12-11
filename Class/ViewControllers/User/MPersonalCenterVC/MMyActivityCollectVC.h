//
//  MMyActivityCollectVC.h
//  Maomao
//
//  Created by maochengfang on 13-12-11.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBarAciivityCollectCell.h"
#import "ASIHTTPRequest.h"
#import "GPPrompting.h"
#import "EGORefreshTableHeaderView.h"

@interface MMyActivityCollectVC : UIViewController<ASIHTTPRequestDelegate,EGORefreshTableHeaderDelegate,UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet  MBarAciivityCollectCell   *activityCollectCell;
    GPPrompting                         *prompting;
    UITableView                         *activityListTV;
    NSMutableArray                      *activityListSource;
    BOOL                                isNetWork;
    int                                 currentIndex;
    BOOL                                reloading;
}

@property (nonatomic, copy) NSString    *activityCollectId;
@property (nonatomic, copy) NSString    *titleNameString;
@property (nonatomic, strong) ASIHTTPRequest *sendRequest;
@property (nonatomic, strong) EGORefreshTableHeaderView *
    refreshHeaderView;
@property (nonatomic, strong) UITableView   *activityListTV;

- (void)initWithRequestByUrl:(NSString *)urlString;

@end
