//
//  MConfig.h
//  Maomao
//
//  Created by  zhao on 13-10-17.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#ifndef Maomao_MConfig_h
#define Maomao_MConfig_h

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define noiOS7 ((floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)?YES:NO)

#define kRequestTime 30

//#define MM_URL @"http://42.121.108.142:6001"

#define MM_URL             @"http://61.188.37.228:8081"

#define LONGITUDE          @"longitude"
#define LATITUDE           @"latitude"
#define NICKNAME           @"nick_name"
#define LOGINNAME          @"login_name"
#define USERID             @"userid"
#define LOGIN_TYPE         @"login_type"
#define PASSWORD           @"password"

#define kTel               @"tel"
#define kCity_id           @"city_id"
#define kSex               @"sex"
#define kCounty            @"county"
#define kStreet            @"street"
#define kCounty_id         @"county_id"
#define kEthnicity_id      @"ethnicity_id"
#define kPic_path          @"pic_path"
#define kUpload_name       @"upload_name"
#define kEmail             @"email"
#define kCompany           @"company"
#define kBase_path         @"base_path"
#define kJob               @"job"
#define kBirthday          @"birthday"
#define kRel_path          @"rel_path"
#define kProvince_id       @"province_id"
#define kBirthday_type     @"birthday_type"
#define kMobile            @"mobile"
#define kReal_name         @"real_name"
#define kIntro             @"intro"
#define kSignature         @"signature"
#define kPic_name          @"pic_name"
#define kModifyType        @"modifyType"

#endif

