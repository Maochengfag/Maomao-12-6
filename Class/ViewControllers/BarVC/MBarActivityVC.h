//
//  MBarActivityVC.h
//  Maomao
//
//  Created by maochengfang on 13-12-11.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "GPPrompting.h"

@interface MBarActivityVC : UIViewController<ASIHTTPRequestDelegate>
{
    MBProgressHUD   *hud;
    GPPrompting     *prompting;
    BOOL            isNetWork;
}

@property (weak, nonatomic) IBOutlet UIImageView *activityImg;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *addressLable;
@property (weak, nonatomic) IBOutlet UILabel *jionNumLabel;
@property (weak, nonatomic) IBOutlet UITextView *activityDetailLable;
@property (nonatomic, strong) ASIHTTPRequest    *sendRequest;
@property (nonatomic, strong) ASIHTTPRequest    *sendCollectRequest;
@property (nonatomic, strong) ASIHTTPRequest    *sendCancelCollectRequest;

@end
