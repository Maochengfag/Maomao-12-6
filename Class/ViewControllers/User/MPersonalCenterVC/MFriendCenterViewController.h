//
//  MFriendCenterViewController.h
//  Maomao
//
//  Created by maochengfang on 13-12-5.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

@protocol MFriendCenterViewControlDelegate <NSObject>

- (void)friendCenterLeftSlider;
- (void)mFriendCenterVCGotoNext:(NSInteger)number;

@end

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface MFriendCenterViewController : UIViewController
@property (nonatomic, assign) id<MFriendCenterViewControlDelegate>delegate;
@property (nonatomic, copy) NSString *friendId;
@property (nonatomic, strong) ASIFormDataRequest *formDataReuqest;
@property (weak, nonatomic) IBOutlet UILabel *friendAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendExpTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendIntegrationLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *friendIcon;

@property (weak, nonatomic) IBOutlet UILabel *friendSignLabel;
@property (weak, nonatomic) IBOutlet UILabel *numofGift;
@property (weak, nonatomic) IBOutlet UIScrollView *friendScrollView;

//Button Action
- (IBAction)gotoClink:(UIButton *)sender;
- (IBAction)haveTeaser:(UIButton *)sender;
- (IBAction)sendGift:(UIButton *)sender;
- (IBAction)sendMsg:(UIButton *)sender;
- (IBAction)showGift:(UIButton *)sender;

- (IBAction)barCollection:(UIButton *)sender;



@end
