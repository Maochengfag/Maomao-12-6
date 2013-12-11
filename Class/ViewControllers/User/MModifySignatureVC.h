//
//  MBarSignature.h
//  Maomao
//
//  Created by maochengfang on 13-10-25.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface MModifySignatureVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *signTF;

@property (nonatomic,strong)  ASIFormDataRequest      *formDataRequest;

@end
