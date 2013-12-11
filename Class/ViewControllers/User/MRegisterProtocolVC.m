//
//  MRegisterProtocolVC.m
//  Maomao
//
//  Created by zhao on 13-11-28.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MRegisterProtocolVC.h"

@interface MRegisterProtocolVC ()

@end

@implementation MRegisterProtocolVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backRegisterView:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
