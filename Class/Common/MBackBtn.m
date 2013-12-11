//
//  MBackBtn.m
//  Maomao
//
//  Created by  zhao on 13-10-17.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MBackBtn.h"

@implementation MBackBtn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setFrame:CGRectMake(0, 0, 30, 24)];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 4, 9, 16)];
        [img setImage:[UIImage imageNamed:@"common_btn_back.png"]];
        [self addSubview:img];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
