//
//  MDetailListModel.h
//  Maomao
//  酒吧列表模型
//  Created by maochengfang on 13-10-24.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBarListModel : NSObject

@property (nonatomic, copy)   NSString *city_id;
@property (nonatomic, copy)   NSString *county_id;
@property (nonatomic, copy)   NSString *email;
@property (nonatomic, copy)   NSString *fax;
@property (nonatomic, copy)   NSString *barListId;
@property (nonatomic, copy)   NSString *intro;
@property (nonatomic, copy)   NSString *latitude;
@property (nonatomic, copy)   NSString *longitude;
@property (nonatomic, copy)   NSString *mobile_list;
@property (nonatomic, copy)   NSString *name;

@property (nonatomic, copy)   NSString *pic_path;
@property (nonatomic, copy)   NSString *province_id;
@property (nonatomic, assign) BOOL     recommend;
@property (nonatomic, copy)   NSString *street;
@property (nonatomic, copy)   NSString *tel_list;
@property (nonatomic, copy)   NSString *type_name;
@property (nonatomic, copy)   NSString *view_number;
@property (nonatomic, copy)   NSString *web_url;

@end
