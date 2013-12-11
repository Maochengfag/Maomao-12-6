//
//  MpersonalCenter.h
//  Maomao
//
//  Created by maochengfang on 13-10-28.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface MFriendCenterVC : UIViewController

@property (nonatomic, copy) NSString              *friendId;
@property (nonatomic, copy) NSString              *friendSign;
@property (weak, nonatomic) IBOutlet UILabel      *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel      *areaLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel      *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel      *collectNumberLabel;

@property (nonatomic, strong) ASIFormDataRequest  *formDataRequest;

- (IBAction)sendPrivateMessage:(UIButton *)sender;
- (IBAction)gotoFriendCollectBar:(UIButton *)sender;

@end
