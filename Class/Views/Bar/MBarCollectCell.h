//
//  MBarCollectCell.h
//  Maomao
//
//  Created by maochengfang on 13-10-18.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBarCollectModel.h"

@interface MBarCollectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *barIconImg;
@property (weak, nonatomic) IBOutlet UILabel *barNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *streetLabel;

- (void)setCellInfoWithModel:(MBarCollectModel *)model;

@end
