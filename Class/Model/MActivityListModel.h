//
//  MBarActivityList.h
//  Maomao
//  活动列表
//  Created by maochengfang on 13-11-6.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MActivityListModel : NSObject

@property (nonatomic, copy) NSString    *activity_info;
@property (nonatomic, copy) NSString    *activity_picture_path;
@property (nonatomic, copy) NSString    *base_path;
@property (nonatomic, copy) NSString    *county;
@property (nonatomic, copy) NSString    *end_date;
@property (nonatomic, assign) NSInteger hot;
@property (nonatomic, assign) NSInteger activity_list_id;
@property (nonatomic, assign) NSInteger join_people_number;
@property (nonatomic, copy) NSString    *pic_name;
@property (nonatomic, copy) NSString    *pic_path;
@property (nonatomic, copy) NSString    *picture_path;
@property (nonatomic, assign) NSInteger  pub_id;
@property (nonatomic, copy) NSString    *pub_picture_path;
@property (nonatomic, copy) NSString    *rel_path;
@property (nonatomic, copy) NSString    *start_date;
@property (nonatomic, copy) NSString    *title;
@property (nonatomic, copy) NSString    *pub_name;

@property (nonatomic, assign) NSInteger  hot_list_id;

@end
