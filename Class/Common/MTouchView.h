//
//  MTouchView.h
//  Maomao
//   滑倒最里头
//  Created by maochengfang on 13-12-5.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>

//滑动视图的状态
typedef NS_ENUM(NSInteger, ViewState1) {
    NormalState1 = 0,
    LeftState1,
};

@interface MTouchView : UIView
@property (nonatomic, strong) UIView    *lastView1;
@property (nonatomic)         ViewState1 currentState1;

- (void)setCurrentView1:(UIView *)view;
- (void)setHidden1:(BOOL)hidden;

@end
