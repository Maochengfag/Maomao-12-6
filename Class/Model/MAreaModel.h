//
//  MAreaModel.h
//  Maomao
//
//  Created by zhao on 13-11-17.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAreaModel : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSArray  *city_list;
@property (nonatomic, copy) NSString *areaId;

@end
