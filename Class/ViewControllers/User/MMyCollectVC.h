//
//  MMyCollectVC.h
//  Maomao
//
//  Created by zhao on 13-11-15.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//
@protocol MMyCollectDelegate <NSObject>

- (void)numberofCollection:(NSInteger)num;

@end

#import <UIKit/UIKit.h>
#import "MBarCollectCell.h"
#import "ASIHTTPRequest.h"
#import "GPPrompting.h"
#import "EGORefreshTableHeaderView.h"

@interface MMyCollectVC : UIViewController <ASIHTTPRequestDelegate, EGORefreshTableHeaderDelegate, UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet MBarCollectCell *barCollectCell;
    GPPrompting              *prompting;
    UITableView              *barListTV;
    NSMutableArray           *barListSources;
    BOOL                      isNetWork;
    int                       currentIndex;
    BOOL                      reloading;
}

@property (nonatomic, assign) BOOL                        isMyCollect;
@property (nonatomic, copy)   NSString                   *titleNameString;
@property (nonatomic, copy)   NSString                   *collectId;

@property (nonatomic, strong) ASIHTTPRequest             *sendRequest;
@property (nonatomic, strong) EGORefreshTableHeaderView  *refreshHeaderView;
@property (nonatomic, strong) UITableView                *barListTV;
@property (nonatomic, strong) id<MMyCollectDelegate> delegate;

- (void)initWithRequestByUrl:(NSString *)urlString;

@end
