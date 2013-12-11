//
//  MTouchSuperView.h
//  Maomao
//
//  Created by  zhao on 13-11-6.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>

//滑动视图的状态
typedef NS_ENUM(NSInteger, ViewState) {
    NormalState = 0,
    LeftState,
};

@interface MTouchSuperView : UIView

@property (nonatomic, strong) UIView      *lastView;
@property (nonatomic)         ViewState    currentState;

- (void)setCurrentView:(UIView *)view;
- (void)setHidden:(BOOL)hidden;

@end
