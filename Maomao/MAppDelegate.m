//
//  MAppDelegate.m
//  Maomao
//
//  Created by  zhao on 13-10-16.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MAppDelegate.h"
#import "MRootVC.h"

@implementation MAppDelegate

@synthesize navigation;
@synthesize mainVC;
@synthesize loginVC;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    //增加标识，用于判断是否是第一次启动应用...
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunchTag"]) {
        MRootVC *rootVC = [[MRootVC alloc] init];
        self.window.rootViewController = rootVC;
        [self.window addSubview:rootVC.view];
    } else {
        if ([[[NSUserDefaults standardUserDefaults] stringForKey:USERID] length] > 0) {
            mainVC = [[MMainVC alloc] init];
            navigation = [[UINavigationController alloc] initWithRootViewController:mainVC];
            navigation.delegate = self;
            [navigation.navigationBar setBackgroundImage:[UIImage imageNamed:@"common_barBg_top.png"] forBarMetrics:UIBarMetricsDefault];
            self.window.rootViewController = navigation;
            [self.window addSubview:navigation.view];
        } else {
            loginVC = [[MLoginVC alloc] initWithNibName:(iPhone5?@"MLoginVC":@"MLoginVCi4") bundle:nil];
            self.window.rootViewController = loginVC;
            [self.window addSubview:loginVC.view];
        }
        
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == mainVC) {
        [navigationController setNavigationBarHidden:YES animated:YES];
    } else if ([navigationController isNavigationBarHidden]) {
        [navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
