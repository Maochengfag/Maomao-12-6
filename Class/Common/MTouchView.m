//
//  MTouchView.m
//  Maomao
//
//  Created by maochengfang on 13-12-5.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MTouchView.h"
#define SLIDE_SIZE 0

@implementation MTouchView

@synthesize lastView1;
@synthesize currentState1;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTranslation:)];
        [self addGestureRecognizer:pgr];
    }
    return self;
}

//手势方法
- (void)panTranslation:(id)sender{
    UIPanGestureRecognizer *pgr = (UIPanGestureRecognizer *)sender;
    CGPoint point = [pgr translationInView:self];
    
    switch (currentState1) {
        case NormalState1:
            if (point.x < 0) {
                return;
            }
            [self setTransform:CGAffineTransformMakeTranslation(point.x, 0)];
            
            break;
        case LeftState1:
            [self setTransform:CGAffineTransformMakeTranslation(point.x + SLIDE_SIZE, 0)];
            break;
    }
    
    switch (pgr.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            break;
        case UIGestureRecognizerStateEnded:
            [self checkCurrentFrame:point.x];
            break;
        default:
            break;
    }
}

//手势结束后动画
- (void)checkCurrentFrame:(float)offSet
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    if (self.frame.origin.x < 160) {
        [self setTransform:CGAffineTransformIdentity];
        currentState1 = NormalState1;
    } else {
        [self setTransform:CGAffineTransformMakeTranslation(SLIDE_SIZE,0)];
        currentState1 = LeftState1;
    }
    
    [UIView commitAnimations];
    
}

- (void)setHidden1:(BOOL)hidden
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    if (hidden) {
        [self setTransform:CGAffineTransformIdentity];
        currentState1 = NormalState1;
    } else {
        [self setTransform:CGAffineTransformMakeTranslation(SLIDE_SIZE,0)];
        currentState1 = LeftState1;
    }
    
    [UIView commitAnimations];
}

-(void)setCurrentView1:(UIView *)view
{
    if (lastView1 == nil) {
        self.lastView1 = view;
        [self addSubview:view];
        return;
    } else if (view ==lastView1) {
        return;
    }
    
    [lastView1 removeFromSuperview];
    self.lastView1 = view;
    [self addSubview:lastView1];
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
