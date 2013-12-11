//
//  MMainVC.m
//  Maomao
//
//  Created by  zhao on 13-11-6.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MMainVC.h"
#import "MBarListVC.h"
#import "MBarDetailsVC.h"
#import "MBarListModel.h"
#import "MBarCollectModel.h"
#import "MMessageAwakeVC.h"
#import "MSoundAndShockVC.h"
#import "MFeedbackVC.h"
#import "MAboutVC.h"
#import "MSystemMessageVC.h"
#import "MPrivateMessageVC.h"
#import "MCollectView.h"
#import "Utils.h"
#import "JSON.h"
#import "MMyCollectVC.h"
#import "MUserSettingVC.h"
#import "MTitleView.h"
#import "MLoginVC.h"
#import "UIImageView+WebCache.h"
#import "MChatListVC.h"

@interface MMainVC ()
{
    MMessageAwakeVC    *messageAwakeVC;
    MSoundAndShockVC   *soundAndShockVC;
    MFeedbackVC        *feedbackVC;
    MAboutVC           *aboutVC;
    MSystemMessageVC   *systemMessageVC;
    MPrivateMessageVC  *privateMessageVC;
}

@end

@implementation MMainVC

@synthesize touchView;
@synthesize myHomeView;
@synthesize homeView;
@synthesize collectView;
@synthesize messageView;
@synthesize settingView;
@synthesize leftMenuView;
@synthesize formDataRequest;
//测试二期个人中心
@synthesize personalCenter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self userInfo];

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 1000.0f;
    [locationManager startUpdatingLocation];

    [[NSBundle mainBundle] loadNibNamed:@"MLeftMenuView" owner:self options:nil];
    leftMenuView = leftMenuNib;
    leftMenuView.delegate = self;
    [self.view addSubview:leftMenuView];
    
    touchView = [[MTouchSuperView alloc] initWithFrame:CGRectMake(0, 0, 320, 480+(iPhone5?88:0))];
    [self.view addSubview:touchView];
    
    homeView = [[MHomeView alloc] initWithFrame:CGRectMake(0, 0, 320, 460+(iPhone5?88:0)+(noiOS7?0:20))];
    NSString *url = [NSString stringWithFormat:@"%@/restful/pub/home",MM_URL];
    [homeView initWithRequestByUrl:url];
    NSLog(@"url == %@",url);
    [homeView setDelegate:self];
    [touchView setCurrentView:homeView];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSString *headImgPath = [[NSUserDefaults standardUserDefaults] stringForKey:kPic_path];
    NSString *path = [NSString stringWithFormat:@"%@%@",MM_URL, headImgPath];
    [leftMenuView.headImg setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"common_userHeadImg.png"]];
    
    leftMenuView.nameLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:NICKNAME];
    NSLog(@"nameLabe.text==%@",leftMenuView.nameLabel.text);
    leftMenuView.signLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:kSignature];
    
    myHomeView.signLabel.text = [NSString stringWithFormat:@"个性签名：%@",[[NSUserDefaults standardUserDefaults] stringForKey:kSignature]];
    //测试二期个人中心页面
    personalCenter.signalLabel.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:kSignature]];
    /****************设置年龄******************/
    
    NSDate *current = [NSDate date];  //当前时间
    
    //格式化后台获取时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyy-MM-dd HH:mm:ss"];
    
    NSString *stringTime = [[NSUserDefaults standardUserDefaults] stringForKey:kBirthday];
    NSDate *birthday = [formatter dateFromString:stringTime];
    
    //计算年龄
    NSCalendar *systeCalendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComparisonComponents = [systeCalendar components:unitFlags fromDate:birthday toDate:current options:NSWrapCalendarComponents];
    
    myHomeView.ageLabel.text = [NSString stringWithFormat:@"%d 岁",dateComparisonComponents.year];
    
    //测试二期个人中心页面
    personalCenter.ageLabel.text = [NSString stringWithFormat:@"%ld",(long)dateComparisonComponents.year];
    /****************************************************************/

    myHomeView.areaLabel.text = [[[NSUserDefaults standardUserDefaults] stringForKey:kCounty] stringByReplacingOccurrencesOfString:@"$" withString:@""];
    NSLog(@"areaLabel==%@",myHomeView.areaLabel.text);
    
     //测试二期个人中心页面
    personalCenter.areaLabel.text = [[[NSUserDefaults standardUserDefaults] stringForKey:kCounty]
                                     stringByReplacingOccurrencesOfString:@"$" withString:@""];
    
    [myHomeView.iconImg  setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"common_userHeadImg.png"]];
    
    //测试二期个人中心页面
    [personalCenter.Icon setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"personal_Icon.png"]];
    
    myHomeView.nameLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:NICKNAME];
    
    //测试二期个人中心页面
    personalCenter.nameLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:NICKNAME];
}

- (void)userInfo
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    NSLog(@"userid == %@",userid);
    NSString *urlString = [NSString stringWithFormat:@"%@/restful/user/user_info/%@" ,MM_URL, userid];
    NSLog(@"usrlString == %@",urlString);
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    formDataRequest = [ASIFormDataRequest requestWithURL:url];
    
    [formDataRequest setDelegate:self];
    [formDataRequest setTimeOutSeconds:kRequestTime];
    [formDataRequest setDidFailSelector:@selector(requestDidFailed:)];
    [formDataRequest setDidFinishSelector:@selector(requestDidSuccess:)];
    [formDataRequest setRequestMethod:@"POST"];
    
    [formDataRequest startSynchronous];
}

- (void)requestDidFailed:(ASIFormDataRequest *)request
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络无法连接，请检查网络连接" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alertView show];
}

- (void) requestDidSuccess:(ASIFormDataRequest *)request
{
    NSLog(@"code:%d",[request responseStatusCode]);
    NSString *responseString = [request responseString];
    if (responseString == nil || [responseString JSONValue] == nil)
    {
        return;
    }
    NSLog(@"responseString==%@",responseString);
    NSDictionary *respponseDict = [responseString JSONValue];
    NSInteger status = [[respponseDict objectForKey:@"status"] integerValue];
    
    if (status == 0) {
        
        NSDictionary *userDict = [respponseDict objectForKey:@"user"];
        NSString *userid = [userDict objectForKey:@"id"];
        NSString *nickName = [userDict objectForKey:@"nick_name"];
        NSString *loginName = [userDict objectForKey:LOGINNAME];
        NSString *loginType = [userDict objectForKey:LOGIN_TYPE];
        
        NSDictionary *userInfo = [respponseDict objectForKey:@"user_info"];
        NSString *tel = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"tel"]];
        NSString *city_id = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"city_id"]];
        NSString *sex = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"sex"]];
        NSString *county = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"county"]];
        NSString *street = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"street"]];
        NSString *county_id = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"county_id"]];
        NSString *ethnicity_id = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"ethnicity_id"]];
        NSString *upload_name = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"upload_name"]];
        NSString *email = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"email"]];
        NSString *company = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"company"]];
        NSString *base_path = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"base_path"]];
        NSString *job = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"job"]];
        NSString *birthday = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"birthday"]];
        NSString *rel_path = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"rel_path"]];
        NSString *province_id = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"province_id"]];
        NSString *pic_path = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"pic_path"]];
        NSString *birthday_type = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"birthday_type"]];
        NSString *mobile = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"mobile"]];
        NSString *real_name = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"real_name"]];
        NSString *intro = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"intro"]];
        NSString *signature = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"signature"]];
        NSString *pic_name = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"pic_name"]];
        
        [[NSUserDefaults standardUserDefaults] setObject:userid forKey:USERID];
        [[NSUserDefaults standardUserDefaults] setObject:nickName forKey:NICKNAME];
        [[NSUserDefaults standardUserDefaults] setObject:loginName forKey:LOGINNAME];
        [[NSUserDefaults standardUserDefaults] setObject:loginType forKey:LOGIN_TYPE];
        [[NSUserDefaults standardUserDefaults] setObject:tel forKey:kTel];
        [[NSUserDefaults standardUserDefaults] setObject:city_id forKey:kCity_id];
        [[NSUserDefaults standardUserDefaults] setObject:sex forKey:kSex];
        [[NSUserDefaults standardUserDefaults] setObject:county forKey:kCounty];
        [[NSUserDefaults standardUserDefaults] setObject:street forKey:kStreet];
        [[NSUserDefaults standardUserDefaults] setObject:county_id forKey:kCounty_id];
        [[NSUserDefaults standardUserDefaults] setObject:ethnicity_id forKey:kEthnicity_id];
        [[NSUserDefaults standardUserDefaults] setObject:upload_name forKey:kUpload_name];
        [[NSUserDefaults standardUserDefaults] setObject:email forKey:kEmail];
        [[NSUserDefaults standardUserDefaults] setObject:company forKey:kCompany];
        [[NSUserDefaults standardUserDefaults] setObject:base_path forKey:kBase_path];
        [[NSUserDefaults standardUserDefaults] setObject:job forKey:kJob];
        [[NSUserDefaults standardUserDefaults] setObject:birthday forKey:kBirthday];
        [[NSUserDefaults standardUserDefaults] setObject:rel_path forKey:kRel_path];
        [[NSUserDefaults standardUserDefaults] setObject:province_id forKey:kProvince_id];
        [[NSUserDefaults standardUserDefaults] setObject:pic_path forKey:kPic_path];
        [[NSUserDefaults standardUserDefaults] setObject:birthday_type forKey:kBirthday_type];
        [[NSUserDefaults standardUserDefaults] setObject:mobile forKey:kMobile];
        [[NSUserDefaults standardUserDefaults] setObject:real_name forKey:kReal_name];
        [[NSUserDefaults standardUserDefaults] setObject:intro forKey:kIntro];
        [[NSUserDefaults standardUserDefaults] setObject:signature forKey:kSignature];
        [[NSUserDefaults standardUserDefaults] setObject:pic_name forKey:kPic_name];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else if (status == 1) {
        NSString *message = [respponseDict objectForKey:@"message"];
        UIAlertView *OK = [[UIAlertView alloc] initWithTitle:@"重要提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [OK show];
    }
}

#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    [locationManager stopUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation: newLocation completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
//            CLPlacemark *placemark = [array objectAtIndex:0];
//            NSString *country = placemark.ISOcountryCode;
//            NSString *city = placemark.administrativeArea;
            
            [[NSUserDefaults standardUserDefaults] setFloat:newLocation.coordinate.longitude forKey:LONGITUDE];
            [[NSUserDefaults standardUserDefaults] setFloat:newLocation.coordinate.latitude forKey:LATITUDE];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"%@",error);
}

#pragma mark - 
#pragma mark MLetMenuViewDelegate

- (void)gotoNextVC:(NSInteger)type
{
    [touchView setHidden:YES];
    switch (type) {
        case 10:
//            if (myHomeView == nil) {
//                myHomeView = [[MMyHomeView alloc] initWithFrame:CGRectMake(0, 0, 320, 460+(iPhone5?88:0)+(noiOS7?0:20))];
//                [myHomeView setDelegate:self];
//            }
            
            //测试二期个人中心页面
            if (personalCenter == nil) {
                personalCenter = [[MPersonalCenterVC alloc] init];
                [personalCenter setDelegate:self];
            }

            [touchView setCurrentView:personalCenter.view];
            break;
        case 11:
            [touchView setCurrentView:homeView];
            break;
        case 12:
            if (collectView == nil) {
                collectView = [[MCollectView alloc] initWithFrame:CGRectMake(0, 0, 320, 460+(iPhone5?88:0)+(noiOS7?0:20))];
                [collectView setDelegate:self];
                
                NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
                NSString *url = [NSString stringWithFormat:@"%@/restful/user/collect?user_id=%@",MM_URL, userid];
                [collectView initWithRequestByUrl:url];
            }
            [touchView setCurrentView:collectView];
            break;
        case 13:
            if (messageView == nil) {
                messageView = [[MMessageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460+(iPhone5?88:0)+(noiOS7?0:20))];
                [messageView setDelegate:self];
            }
            [touchView setCurrentView:messageView];
            break;
        case 14:
            if (settingView == nil) {
                settingView = [[MSettingView alloc] initWithFrame:CGRectMake(0, 0, 320, 460+(iPhone5?88:0)+(noiOS7?0:20))];
                [settingView setDelegate:self];
            }
            [touchView setCurrentView:settingView];
            break;
        default:
            break;
    }
}

//测试二期个人中心页面
#pragma mark -
#pragma mark MMpersonalCenterDelegate

- (void)mPersonalCenterLeftSlider
{
    [self leftSlider];
}


//二期个人中心
#pragma mark -
#pragma mark MPersonalConterDelegate
- (void)personalCenterLeftSlider
{
    [self leftSlider];
}

- (void)mPersonalCenterGotoNext:(NSInteger)number
{
    MUserSettingVC *userSettingVC = [[MUserSettingVC alloc] init];
    MMyCollectVC *myCollectVC = [[MMyCollectVC alloc] init];
    myCollectVC.isMyCollect = YES;
    
    if (privateMessageVC == nil) {
        NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
        privateMessageVC = [[MPrivateMessageVC alloc] init];
        privateMessageVC.lastUrlString = [NSString stringWithFormat:@"%@/restful/user/direct/message?user_id=%@",MM_URL, userid];
    }

    switch (number) {
        case 20:
            [self.navigationController pushViewController:userSettingVC animated:YES];
            break;
        case 21:
            NSLog(@"goto Experience");
            break;
        case 22:
            NSLog(@"goto invite");
            break;
        case 23:
            NSLog(@"goto gift");
            break;
        case 24:
            NSLog(@"goto teaser");
            break;
        case 25:
            NSLog(@"goto priviteMsg");
            [self.navigationController pushViewController:privateMessageVC animated:YES];
            break;
        case 26:
            [self.navigationController pushViewController:myCollectVC animated:YES];
            break;
        case 27:
            NSLog(@"goto activity");
        default:
            break;
    }
}

//二期好友中心
#pragma mark -
#pragma mark MFriendCenterViewControlDelegate
- (void)friendCenterLeftSlider
{
    [self leftSlider];
}

#pragma mark -
#pragma mark MHomeViewDelegate

- (void)homeLeftSlider
{
    [self leftSlider];
}

- (void)gotoBarListVC:(NSInteger)typeId type:(NSString *)name;
{
    MBarListVC *barListVC = [[MBarListVC alloc] init];
    [self.navigationController pushViewController:barListVC animated:YES];
    MTitleView *titleView = [[MTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    titleView.titleName.text = name;
    barListVC.navigationItem.titleView = titleView;
    barListVC.isNoBarList = NO;
    NSString *url = [NSString stringWithFormat:@"%@/restful/pub/list/detail?type_id=%d&province_id=9",MM_URL, typeId];
    barListVC.urlStr = url;
}

#pragma mark -
#pragma mark MMyHomeViewDelegate

- (void)myHomeLeftSlider
{
    [self leftSlider];
}

- (void)myHomeGotoNext:(NSInteger)number
{
    NSLog(@"number == %d",number);
    MUserSettingVC *userSettingVC = [[MUserSettingVC alloc] init];
    
    MMyCollectVC *myCollectVC = [[MMyCollectVC alloc] init];
    myCollectVC.isMyCollect = YES;

    if (privateMessageVC == nil) {
        NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
        privateMessageVC = [[MPrivateMessageVC alloc] init];
        privateMessageVC.lastUrlString = [NSString stringWithFormat:@"%@/restful/user/direct/message?user_id=%@",MM_URL, userid];
    }

    switch (number) {
        case 11:
            [self.navigationController pushViewController:userSettingVC animated:YES];
            break;
        case 12:
            [self.navigationController pushViewController:myCollectVC animated:YES];
            break;
        case 13:
            [self.navigationController pushViewController:privateMessageVC animated:YES];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark MCollectViewDelegate

- (void)collectLeftSlider
{
    [self leftSlider];
}

- (void)gotoCollectBarDetail:(MBarCollectModel *)model;
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    MBarDetailsVC *detailsVC = [[MBarDetailsVC alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/restful/pub/detail?pub_id=%@&user_id=%@", MM_URL, model.collectid, userid];
    MTitleView *titleView = [[MTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    titleView.titleName.text = model.name;
    detailsVC.navigationItem.titleView = titleView;
    [detailsVC initWithRequestByUrl:url];
    [self.navigationController pushViewController:detailsVC animated:YES];
}

#pragma mark -
#pragma mark MMessageViewDelegate

- (void)messageLeftSlider
{
    [self leftSlider];
}

- (void)gotoMessageDetails:(NSInteger)number
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];

    NSLog(@"number == %d",number);
    systemMessageVC = [[MSystemMessageVC alloc] init];
    if (privateMessageVC == nil) {
        privateMessageVC = [[MPrivateMessageVC alloc] init];
    }
    
    switch (number) {
        case 111:
            [self.navigationController pushViewController:systemMessageVC animated:YES];
            break;
        case 222:
            privateMessageVC.lastUrlString = [NSString stringWithFormat:@"%@/restful/user/direct/message?user_id=%@",MM_URL, userid];
            [self.navigationController pushViewController:privateMessageVC animated:YES];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark MSettingViewDelegate

- (void)settingLeftSlider
{
    [self leftSlider];
}

- (void)gotoNextSetting:(NSInteger)number
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"已经是最新版本" delegate:self cancelButtonTitle:@"知道了 " otherButtonTitles: nil];
    
    MLoginVC *loginVC = [[MLoginVC alloc] initWithNibName:(iPhone5?@"MLoginVC":@"MLoginVCi4") bundle:nil];
    
    switch (number) {
        case 11:
            messageAwakeVC = [[MMessageAwakeVC alloc] init];
            [self.navigationController pushViewController:messageAwakeVC animated:YES];
            break;
        case 12:
            soundAndShockVC = [[MSoundAndShockVC alloc] init];
            [self.navigationController pushViewController:soundAndShockVC animated:YES];
            break;
        case 13:
            [alertView show];
            break;
        case 14:
            feedbackVC = [[MFeedbackVC alloc] init];
            [self.navigationController pushViewController:feedbackVC animated:YES];
            break;
        case 15:
            aboutVC = [[MAboutVC alloc] init];
            [self.navigationController pushViewController:aboutVC animated:YES];
            break;
        case 16:
             //第一次登陆时退出有此，需更改
            [self presentViewController:loginVC animated:YES completion:nil];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:USERID];
            break;
        default:
            break;
    }
}

- (void)leftSlider
{
    if (touchView.currentState == NormalState) {
        [touchView setHidden:NO];
    } else {
        [touchView setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
