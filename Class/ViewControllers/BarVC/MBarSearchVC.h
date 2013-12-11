//
//  MBarSearch.h
//  Maomao
//
//  Created by maochengfang on 13-10-28.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "GPPrompting.h"

@interface MBarSearchVC : UIViewController <UITextFieldDelegate, ASIHTTPRequestDelegate>
{
    NSMutableArray *searchArray;
}

@property (weak, nonatomic) IBOutlet UITextField        *searchContentTF;

@property (nonatomic, strong) ASIHTTPRequest            *sendRequest;
@property (nonatomic, strong) ASIHTTPRequest            *sendSearchRequest;

- (IBAction)searchHotBar:(UIButton *)sender;

@end