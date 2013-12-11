//
//  MBarListCell.h
//  Maomao
//
//  Created by  zhao on 13-10-17.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBarListModel.h"

@interface MBarListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel         *barNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView     *barIcon;
@property (weak, nonatomic) IBOutlet UILabel         *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel         *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel         *introLabel;

- (void)setCellInfoWithModel:(MBarListModel *)model;

@end
