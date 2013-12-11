//
//  MBarChangepasswd.h
//  Maomao
//
//  Created by maochengfang on 13-10-26.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface MModifyPasswordVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextField      *oldPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField      *aNewPasswordTF;

@property (nonatomic,strong)  ASIFormDataRequest      *formDataRequest;

@end
