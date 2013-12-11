//
//  MBarDetailsVC.h
//  Maomao
//
//  Created by  zhao on 13-10-17.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "GPPrompting.h"
#import <MapKit/MapKit.h>

//测试二期个人中心
#import "MFriendCenterViewController.h"

@interface MBarDetailsVC : UIViewController <ASIHTTPRequestDelegate,MFriendCenterViewControlDelegate>
{
    MBProgressHUD      *hud;
    GPPrompting        *prompting;
    NSMutableArray     *signaSources;
    BOOL                isNetWork;
}

@property (weak, nonatomic) IBOutlet UIButton       *barIconBtn;
@property (weak, nonatomic) IBOutlet UILabel        *barNameLabel;
@property (weak, nonatomic) IBOutlet UILabel        *signaNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel        *distanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *telNumber;

@property (weak, nonatomic) IBOutlet UILabel        *barTypeLabel;
@property (weak, nonatomic) IBOutlet UITextView     *barIntroTextView;
@property (weak, nonatomic) IBOutlet UIScrollView   *signerShowScrollView;
@property (weak, nonatomic) IBOutlet UILabel *NumofCheck;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;


@property (nonatomic, strong) ASIHTTPRequest        *sendRequest;
@property (nonatomic, strong) ASIHTTPRequest        *sendCollectRequest;
@property (nonatomic, strong) ASIHTTPRequest        *sendCancelCollectRequest;
- (void)initWithRequestByUrl:(NSString *)urlString;
- (IBAction)slideSignerShowView:(UIButton *)sender;
- (IBAction)callPhone:(UIButton *)sender;

- (IBAction)LocationBtn:(UIButton *)sender;
@end
