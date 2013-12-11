//
//  MTouchSuperView.m
//  Maomao
//
//  Created by  zhao on 13-11-6.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MTouchSuperView.h"
#define SLIDE_SIZE 226

@implementation MTouchSuperView

@synthesize lastView;
@synthesize currentState;

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
    
    switch (currentState) {
        case NormalState:
            if (point.x < 0) {
                return;
            }
            [self setTransform:CGAffineTransformMakeTranslation(point.x, 0)];
            
            break;
        case LeftState:
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
        currentState = NormalState;
    } else {
        [self setTransform:CGAffineTransformMakeTranslation(SLIDE_SIZE,0)];
        currentState = LeftState;
    }
    
    [UIView commitAnimations];
    
}

- (void)setHidden:(BOOL)hidden
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    if (hidden) {
        [self setTransform:CGAffineTransformIdentity];
        currentState = NormalState;
    } else {
        [self setTransform:CGAffineTransformMakeTranslation(SLIDE_SIZE,0)];
        currentState = LeftState;
    }
    
    [UIView commitAnimations];
}

-(void)setCurrentView:(UIView *)view
{
    if (lastView == nil) {
        self.lastView = view;
        [self addSubview:view];
        return;
    } else if (view ==lastView) {
        return;
    }
    
    [lastView removeFromSuperview];
    self.lastView = view;
    [self addSubview:lastView];
}

@end
