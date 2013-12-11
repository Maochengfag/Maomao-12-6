//
//  MPersonalCenterVC.h
//  Maomao
//
//  Created by maochengfang on 13-12-3.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

@protocol MPersonalCenterDelegate <NSObject>

- (void)personalCenterLeftSlider;
- (void)mPersonalCenterGotoNext:(NSInteger)number;

@end

#import <UIKit/UIKit.h>
#import "MMyCollectVC.h"

@interface MPersonalCenterVC : UIViewController<MMyCollectDelegate>

@property(nonatomic,assign) id <MPersonalCenterDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UIImageView *Icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *signalLabel;
@property (weak, nonatomic) IBOutlet UILabel *ExperienceLabel;

@property (weak, nonatomic) IBOutlet UILabel *ExperienceTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *IntegrationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderIcon;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;



/********************邀约，礼物，传情，私信,我的收藏，我的活动Lable**************/

@property (weak, nonatomic) IBOutlet UILabel *inviteNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *inviteNotice;
@property (weak, nonatomic) IBOutlet UILabel *giftNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *giftNotice;

@property (weak, nonatomic) IBOutlet UILabel *teaserNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *teaserNotice;
@property (weak, nonatomic) IBOutlet UILabel *privateMsgNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *privateMsgNotice;
@property (weak, nonatomic) IBOutlet UILabel *collectionNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityNumLabel;

//Button Action

- (IBAction)gotoNextVC:(UIButton *)sender;
/***************************************************/

@end
