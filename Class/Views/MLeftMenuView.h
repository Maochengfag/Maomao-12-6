//
//  MLeftMenu.h
//  Maomao
//
//  Created by  zhao on 13-11-6.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

@protocol MLetMenuViewDelegate <NSObject>

- (void)gotoNextVC:(NSInteger)type;

@end

#import <UIKit/UIKit.h>

@interface MLeftMenuView : UIView

@property (nonatomic, assign) id<MLetMenuViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UIImageView *headBgImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;

- (IBAction)gotoNextVC:(UIButton *)sender;

@end
