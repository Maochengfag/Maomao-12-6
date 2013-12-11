//
//  MDetailModel.h
//  Maomao
//  酒吧详情模型
//  Created by maochengfang on 13-10-23.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBarDetailModel : NSObject

//总体信息
@property (nonatomic, copy)   NSString    *county;
@property (nonatomic, copy)   NSString    *is_collect;
@property (nonatomic, copy)   NSString    *message;

//酒吧详情数据
@property (nonatomic, assign) NSInteger    city_id;
@property (nonatomic, assign) NSInteger    county_id;
@property (nonatomic, copy)   NSString    *email;
@property (nonatomic, copy)   NSString    *fax;
@property (nonatomic, copy)   NSString    *barDetailId;
@property (nonatomic, copy)   NSString    *intro;
@property (nonatomic, copy)   NSString    *latitude;
@property (nonatomic, copy)   NSString    *longitude ;
@property (nonatomic, copy)   NSString    *mobile_list;
@property (nonatomic, copy)   NSString    *name;

@property (nonatomic, copy)   NSString    *pic_path;
@property (nonatomic, assign) NSInteger    province_id;
@property (nonatomic, assign) BOOL         recommend;
@property (nonatomic, copy)   NSString    *street;
@property (nonatomic, copy)   NSString    *tel_list;
@property (nonatomic, copy)   NSString    *type_name;
@property (nonatomic, copy)   NSString    *view_number;
@property (nonatomic, copy)   NSString    *web_url;

@end
