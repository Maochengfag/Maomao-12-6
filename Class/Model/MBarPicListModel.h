//
//  MBarPictureListModel.h
//  Maomao
//
//  Created by  zhao on 13-11-7.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBarPicListModel : NSObject

@property (nonatomic, copy)   NSString *base_path;
@property (nonatomic, copy)   NSString *cover;
@property (nonatomic, copy)   NSString *picId;
@property (nonatomic, copy)   NSString *intro;
@property (nonatomic, copy)   NSString *latitude;
@property (nonatomic, copy)   NSString *longitude;
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, copy)   NSString *pic_name;
@property (nonatomic, copy)   NSString *pic_path;
@property (nonatomic, copy)   NSString *rel_path;

@property (nonatomic, copy)   NSString *thumbnail;
@property (nonatomic, copy)   NSString *type_name;
@property (nonatomic, copy)   NSString *upload_name;
@property (nonatomic, copy)   NSString *view_number;

@end
