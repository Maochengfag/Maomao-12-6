//
//  GPPrompting.m
//  OMPBaby
//
//  Created by hong chen on 12-11-8.
//
//

#import "GPPrompting.h"
#import <QuartzCore/QuartzCore.h>

#define G_FONT_SIZE 16
#define G_ICON_WIDTH 30
#define G_ALPHA 0.6
#define DELAY_HIDDEN 1

@interface GPPrompting ()
{
    UIView *cornerView;
    
    UIImageView * iconView;
    UILabel * titleLabel;
}

@end

@implementation GPPrompting
@synthesize delegate;

- (void)dealloc
{
    [cornerView release];
    [iconView release];
    [titleLabel release];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hid) object:nil];
    
    [super dealloc];
}

-(id) initWithView:(UIView *)view Text:(NSString *)text Icon:(NSString *) imgString;
{
    self = [super initWithFrame:view.bounds];
    if (self) {
        self.hidden=YES;
        self.alpha=0.0f;
        
        cornerView=[[UIView alloc] initWithFrame:CGRectZero];
        
        UITapGestureRecognizer * tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleToFitHomeView:)];
        [self addGestureRecognizer:tapGesture];
        [tapGesture release];
        
        cornerView.layer.cornerRadius=8;
        cornerView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:G_ALPHA];
        
        iconView=[[UIImageView alloc] initWithFrame:CGRectZero];
        titleLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.font=[UIFont systemFontOfSize:G_FONT_SIZE];
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.text=text;
        
        [cornerView addSubview:iconView];
        [cornerView addSubview:titleLabel];
        [self addSubview:cornerView];
        
        UIFont *font = [UIFont systemFontOfSize:G_FONT_SIZE];
        CGSize titleSize = [text sizeWithFont:font
                            constrainedToSize:CGSizeMake(MAXFLOAT,200)
                                lineBreakMode:UILineBreakModeWordWrap];
        
        if (imgString!=nil) {
            cornerView.frame=CGRectMake(0, 0, titleSize.width+20, 5+G_ICON_WIDTH+10+20);
            iconView.image=[UIImage imageNamed:imgString];
            
            cornerView.center=CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2-50);
            iconView.frame=CGRectMake(0, 0, G_ICON_WIDTH, G_ICON_WIDTH);
            iconView.center=CGPointMake(cornerView.frame.size.width/2, 5+G_ICON_WIDTH/2);
            titleLabel.frame=CGRectMake(0, 0, titleSize.width, 20);
            titleLabel.center=CGPointMake(cornerView.frame.size.width/2, 5+G_ICON_WIDTH+10);
            
        }else{
            cornerView.frame=CGRectMake(0, 0, titleSize.width+20, 20+20);
            cornerView.center=CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2-50);
            titleLabel.frame=CGRectMake(0, 0, titleSize.width, 20);
            titleLabel.center=CGPointMake(cornerView.frame.size.width/2, 10+10);
        }
    }
    return self;
}

-(void)handleToFitHomeView:(id)sender
{
    self.hidden=YES;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    self.alpha = 0.0f;
    [UIView commitAnimations];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hid) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenView) object:nil];
    if ([delegate respondsToSelector:@selector(doSomethingAfterHidden:)]) {
        [delegate doSomethingAfterHidden:nil];
    }
    self.delegate = nil;
}

-(void)show
{
    self.hidden = NO;
    self.alpha = 0.0f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    self.alpha = 1.0f;
    [UIView commitAnimations];
    [self performSelector:@selector(hid) withObject:nil afterDelay:DELAY_HIDDEN];
    
}

-(void)hiddenView
{
     self.hidden=YES;
    
    if ([delegate respondsToSelector:@selector(doSomethingAfterHidden:)]) {
        [delegate doSomethingAfterHidden:nil];
    }
    self.delegate = nil;
}

-(void)hid
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    self.alpha = 0.0f;
    [UIView commitAnimations];
    [self performSelector:@selector(hiddenView) withObject:nil afterDelay:0.5];
    
}
@end
