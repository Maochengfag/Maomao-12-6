//
//  MRegisterVC.h
//  Maomao
//
//  Created by zhao on 13-11-14.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface MRegisterVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextField      *nicknameTF;
@property (weak, nonatomic) IBOutlet UITextField      *emailTF;
@property (weak, nonatomic) IBOutlet UITextField      *passwordTF;
@property (weak, nonatomic) IBOutlet UIImageView      *selectImg;

@property (nonatomic, strong) UINavigationController  *navigat;
@property (nonatomic,strong)  ASIFormDataRequest      *formDataRequest;

- (IBAction)selectProtocol:(UIButton *)sender;
- (IBAction)lookProtocol:(UIButton *)sender;
- (IBAction)registerAccount:(UIButton *)sender;

@end
