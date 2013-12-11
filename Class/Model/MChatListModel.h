//
//  MChatListModel.h
//  Maomao
//
//  Created by zhao on 13-12-1.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MChatListModel : NSObject

@property (nonatomic, copy) NSString *receiver_id;
@property (nonatomic, copy) NSString *open_id;
@property (nonatomic, copy) NSString *admin;
@property (nonatomic, copy) NSString *sender_id;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *sign_up_date;
@property (nonatomic, copy) NSString *login_name;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *send_time;
@property (nonatomic, copy) NSString *login_type;
@property (nonatomic, copy) NSString *pic_path;
@property (nonatomic, copy) NSString *system_message_time;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *chatId;

@end
