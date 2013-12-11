//
//  MBarAreaChoice.h
//  Maomao
//
//  Created by maochengfang on 13-10-25.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "GPPrompting.h"

@interface MModifyAreaVC : UIViewController <ASIHTTPRequestDelegate>
{
    MBProgressHUD          *hud;
    GPPrompting            *prompting;
}

@property (nonatomic, strong) ASIHTTPRequest          *sendRequest;
@property (nonatomic, strong) ASIFormDataRequest      *formDataRequest;

@end
