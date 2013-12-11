//
//  MPictureVC.h
//  Maomao
//
//  Created by  zhao on 13-11-12.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBarEnvironmentModel.h"

@interface MPictureVC : UIViewController

@property (nonatomic, strong) NSArray               *models;

- (void)currentPic:(NSInteger)number numbers:(NSInteger)count;

@end
