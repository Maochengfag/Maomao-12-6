//
//  MChatListVC.h
//  Maomao
//
//  Created by zhao on 13-11-29.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "GPPrompting.h"

@interface MChatListVC : UIViewController <ASIHTTPRequestDelegate>
{
    MBProgressHUD      *hud;
    GPPrompting        *prompting;
    NSMutableArray     *chatListSource;
    BOOL                isNetWork;
}

@property (weak, nonatomic) IBOutlet UIView        *sendView;
@property (weak, nonatomic) IBOutlet UITextField   *contentTF;

@property (nonatomic, strong) NSString             *senderId;
@property (nonatomic, strong) NSString             *nameString;
@property (nonatomic, strong) ASIHTTPRequest       *sendRequest;
@property (nonatomic, strong) ASIHTTPRequest       *sendContentRequest;

- (void)initWithRequestByUrl:(NSString *)urlString;

- (IBAction)selectFace:(UIButton *)sender;
- (IBAction)sendContent:(UIButton *)sender;

@end
