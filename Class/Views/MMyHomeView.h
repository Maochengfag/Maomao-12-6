//
//  MMyHomeView.h
//  Maomao
//
//  Created by zhao on 13-11-18.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

@protocol MMyHomeViewDelegate <NSObject>

- (void)myHomeLeftSlider;
- (void)myHomeGotoNext:(NSInteger)number;

@end

#import <UIKit/UIKit.h>

@interface MMyHomeView : UIView

@property (nonatomic, assign) id <MMyHomeViewDelegate>   delegate;
@property (strong, nonatomic)  UILabel                  *ageLabel;
@property (strong, nonatomic)  UILabel                  *areaLabel;
@property (strong, nonatomic)  UIImageView              *iconImg;
@property (strong, nonatomic)  UILabel                  *nameLabel;
@property (strong, nonatomic)  UILabel                  *signLabel;

- (void)gotoSettingUserInfo:(UIButton *)sender;
- (void)gotoMyCollect:(UIButton *)sender;
- (void)gotoMyMessage:(UIButton *)sender;

@end
