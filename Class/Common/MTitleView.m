//
//  MTitleView.m
//  Maomao
//
//  Created by  zhao on 13-10-17.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MTitleView.h"

@implementation MTitleView

@synthesize titleName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        titleName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
        [titleName setTextColor:[UIColor whiteColor]];
        [titleName setFont:[UIFont boldSystemFontOfSize:20]];
        [titleName setBackgroundColor:[UIColor clearColor]];
        [titleName setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:titleName];
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
