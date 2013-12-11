//
//  MBarListCell.m
//  Maomao
//
//  Created by  zhao on 13-10-17.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MBarListCell.h"
#import "UIImageView+WebCache.h"
#import <MapKit/MapKit.h>

@implementation MBarListCell

@synthesize barNameLabel;
@synthesize barIcon;
@synthesize distanceLabel;
@synthesize addressLabel;
@synthesize introLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellInfoWithModel:(MBarListModel *)model
{
    barNameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    
    [barIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MM_URL, model.pic_path]] placeholderImage:[UIImage imageNamed:@"common_img_default.png"]];
    
    if ([model.street isEqual:[NSNull null]]) {
        addressLabel.text = @"";
    } else {
        addressLabel.text = [NSString stringWithFormat:@"%@",model.street];
    }
    
    introLabel.text = [NSString stringWithFormat:@"%@",model.intro];
    
    //计算距离
    double locationLongitude = [[[NSUserDefaults standardUserDefaults] stringForKey:LONGITUDE] doubleValue];
    double locationLatitude = [[[NSUserDefaults standardUserDefaults] stringForKey:LATITUDE] doubleValue];
    
    double longitude = [model.longitude doubleValue];
    double latitude = [model.latitude doubleValue];
    
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:locationLatitude longitude:locationLongitude];
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    distanceLabel.text = [NSString stringWithFormat:@"%0.1f km",[newLocation distanceFromLocation :currentLocation]/1000];

}

@end
