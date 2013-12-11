//
//  MCollectView.h
//  Maomao
//
//  Created by  zhao on 13-11-6.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//
#import "MBarCollectModel.h"

@protocol MCollectViewDelegate <NSObject>

- (void)collectLeftSlider;
- (void)gotoCollectBarDetail:(MBarCollectModel *)model;

@end

#import <UIKit/UIKit.h>
#import "MBarCollectCell.h"
#import "ASIHTTPRequest.h"
#import "GPPrompting.h"
#import "EGORefreshTableHeaderView.h"

@interface MCollectView : UIView <ASIHTTPRequestDelegate, EGORefreshTableHeaderDelegate, UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet MBarCollectCell *barCollectCell;
    GPPrompting              *prompting;
    UITableView              *barListTV;
    NSMutableArray           *barListSources;
    BOOL                      isNetWork;
    int                       currentIndex;
    BOOL                      reloading;
}

@property (nonatomic, assign) id<MCollectViewDelegate>    delegate;
@property (nonatomic, strong) ASIHTTPRequest             *sendRequest;
@property (nonatomic, strong) EGORefreshTableHeaderView  *refreshHeaderView;
@property (nonatomic, copy)   NSString                   *lastUrlString;
@property (nonatomic, strong) UITableView                *barListTV;


- (void)initWithRequestByUrl:(NSString *)urlString;

@end
