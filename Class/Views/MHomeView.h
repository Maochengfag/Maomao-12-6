//
//  MHomeView.h
//  Maomao
//
//  Created by  zhao on 13-11-6.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

@protocol MHomeViewDelegate <NSObject>

- (void)homeLeftSlider;
- (void)gotoBarListVC:(NSInteger)typeId type:(NSString *)name;

@end

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "GPPrompting.h"
#import "MHomeModel.h"

@interface MHomeView : UIView <ASIHTTPRequestDelegate>
{
    MBProgressHUD   *hud;
    GPPrompting     *prompting;
    NSMutableArray  *homeSources;
    UIScrollView    *homeScrollView;
    BOOL             isNetWork;
    
}

@property (nonatomic, assign) id <MHomeViewDelegate>    delegate;
@property (nonatomic, strong) ASIHTTPRequest           *sendRequest;
@property (nonatomic, strong) NSString                 *adPic_Path;
- (void)initWithRequestByUrl:(NSString *)urlString;

@end
