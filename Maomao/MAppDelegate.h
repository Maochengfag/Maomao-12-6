//
//  MAppDelegate.h
//  Maomao
//
//  Created by  zhao on 13-10-16.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMainVC.h"
#import "MLoginVC.h"

@interface MAppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow               *window;
@property (nonatomic, strong) UINavigationController *navigation;
@property (nonatomic, strong) MMainVC                *mainVC;
@property (nonatomic, strong) MLoginVC               *loginVC;

@end
