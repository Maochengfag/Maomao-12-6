//
//  MBarFeedback.h
//  Maomao
//
//  Created by maochengfang on 13-10-20.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "GPPrompting.h"

@interface MFeedbackVC : UIViewController <ASIHTTPRequestDelegate>
{
    MBProgressHUD           *hud;
    GPPrompting             *prompting;
}

@property (weak, nonatomic) IBOutlet UITextField *feedBackInfo;

@property (nonatomic, strong)ASIHTTPRequest       *sendRequest;

@end
