//
//  MPrivateMessageVC.h
//  Maomao
//
//  Created by  zhao on 13-11-11.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "GPPrompting.h"
#import "MPrivateMessageCell.h"
#import "EGORefreshTableHeaderView.h"

@interface MPrivateMessageVC : UIViewController <ASIHTTPRequestDelegate, EGORefreshTableHeaderDelegate>
{
    
    IBOutlet MPrivateMessageCell  *privateMessageCell;
    BOOL                           reloading;
}

@property (nonatomic, strong) ASIHTTPRequest            *sendRequest;
@property (nonatomic, strong) ASIHTTPRequest            *sendClearMessageRequest;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, copy)   NSString                  *lastUrlString;
@property (nonatomic, strong) UITableView               *messageListTV;

@end
