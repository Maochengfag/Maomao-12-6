//
//  MSettingView.h
//  Maomao
//
//  Created by  zhao on 13-11-6.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

@protocol MSettingViewDelegate <NSObject>

- (void)settingLeftSlider;
- (void)gotoNextSetting:(NSInteger)number;

@end

#import <UIKit/UIKit.h>

@interface MSettingView : UIView

@property (nonatomic, assign) id<MSettingViewDelegate> delegate;

@end
