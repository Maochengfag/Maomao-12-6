//
//  MBarEnvironmentVC.h
//  Maomao
//
//  Created by  zhao on 13-10-17.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "GPPrompting.h"

@interface MBarEnvironmentVC : UIViewController <ASIHTTPRequestDelegate>
{
    MBProgressHUD      *hud;
    GPPrompting        *prompting;
    NSMutableArray     *environmentSources;
    BOOL                isNetWork;
}

@property (nonatomic, strong) ASIHTTPRequest        *sendRequest;

- (void)initWithRequestByUrl:(NSString *)urlString;

@end
