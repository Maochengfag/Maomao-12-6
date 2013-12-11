//
//  MUserSettingVC.h
//  Maomao
//
//  Created by zhao on 13-11-15.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface MUserSettingVC : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView   *headImg;
@property (weak, nonatomic) IBOutlet UILabel       *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel       *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel       *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel       *signLabel;
@property (weak, nonatomic) IBOutlet UILabel       *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel       *passwordLabel;

@property (nonatomic, strong) ASIFormDataRequest   *sexFormDataRequest;
@property (nonatomic, strong) ASIFormDataRequest   *headImgFormDataRequest;

- (IBAction)modifyHeadImg:(UIButton *)sender;
- (IBAction)modifyNickname:(UIButton *)sender;
- (IBAction)modifyBirthday:(UIButton *)sender;
- (IBAction)modifySex:(UIButton *)sender;
- (IBAction)modifySign:(UIButton *)sender;
- (IBAction)modifyArea:(UIButton *)sender;
- (IBAction)modifyPassword:(UIButton *)sender;

@end
