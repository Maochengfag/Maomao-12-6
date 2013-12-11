//
//  MLeftMenu.m
//  Maomao
//
//  Created by  zhao on 13-11-6.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MLeftMenuView.h"

@implementation MLeftMenuView

@synthesize delegate;
@synthesize signLabel;
@synthesize nameLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (IBAction)gotoNextVC:(UIButton *)sender
{
    NSLog(@"sender==%@",sender);
    [delegate gotoNextVC:sender.tag];
}

@end
