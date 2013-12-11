//
//  MBarDisplayMapVC.h
//  Maomao
//
//  Created by maochengfang on 13-12-6.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MBarDisplayMapVC : UIViewController<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *displayMapMV;

@property (nonatomic, copy) NSMutableArray *barDetailArray;
@end
