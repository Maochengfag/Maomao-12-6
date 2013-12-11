//
//  MUserSettingVC.m
//  Maomao
//
//  Created by zhao on 13-11-15.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MUserSettingVC.h"
#import "MBackBtn.h"
#import "MModifyNicknameVC.h"
#import "MModifyBirthdayVC.h"
#import "MModifySignatureVC.h"
#import "MModifyAreaVC.h"
#import "MModifyPasswordVC.h"
#import "MTitleView.h"
#import "Utils.h"
#import "JSON.h"
#import "GPPrompting.h"
#import "MBProgressHUD.h"
#import "AGSimpleImageEditorView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIImageView+WebCache.h"

@interface MUserSettingVC () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    GPPrompting           *prompting;
    MBProgressHUD         *hud;
}

@property (nonatomic, strong) NSString      *currentPhoto;
;

@end

@implementation MUserSettingVC

@synthesize headImg;
@synthesize nicknameLabel;
@synthesize birthdayLabel;
@synthesize sexLabel;
@synthesize signLabel;
@synthesize areaLabel;
@synthesize passwordLabel;

@synthesize sexFormDataRequest;
@synthesize currentPhoto;
@synthesize headImgFormDataRequest;

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
    // Do any additional setup after loading the view from its nib.
    
    MTitleView *titleView = [[MTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    titleView.titleName.text = @"个人资料";
    self.navigationItem.titleView = titleView;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.91 alpha:1.0]];
    
    MBackBtn *backBtn = [MBackBtn buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    NSString *headImgPath = [[NSUserDefaults standardUserDefaults] stringForKey:kPic_path];
    NSString *path = [NSString stringWithFormat:@"%@%@",MM_URL, headImgPath];
    [headImg setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"common_userHeadImg.png"]];
    
    nicknameLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:NICKNAME];
    
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:kBirthday] isEqualToString:@"<null>"]) {
        birthdayLabel.text = @"";
    } else {
        birthdayLabel.text = [[[NSUserDefaults standardUserDefaults] stringForKey:kBirthday] substringWithRange:NSMakeRange(0, 10)];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:kSex] isEqualToString:@"<null>"]) {
        sexLabel.text = @"";
    } else if ([[[NSUserDefaults standardUserDefaults] stringForKey:kSex] isEqualToString:@"1"]) {
        sexLabel.text = @"男";
    } else if ([[[NSUserDefaults standardUserDefaults] stringForKey:kSex] isEqualToString:@"0"]) {
        sexLabel.text = @"女";
    }
    
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:kSignature] isEqualToString:@"<null>"]) {
        signLabel.text = @"";
    } else {
        signLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:kSignature];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:kCounty] isEqualToString:@"<null>"]) {
        areaLabel.text = @"";
    } else {
        areaLabel.text = [[[NSUserDefaults standardUserDefaults] stringForKey:kCounty] stringByReplacingOccurrencesOfString:@"$" withString:@""];
    }

    if (!noiOS7) {
        for (UIView *view in self.view.subviews) {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+64, view.frame.size.width, view.frame.size.height)];
        }
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSInteger modifyType = [[NSUserDefaults standardUserDefaults] integerForKey:kModifyType];
    switch (modifyType) {
        case 1:
            nicknameLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:NICKNAME];
            break;
        case 2:
            birthdayLabel.text = [[[NSUserDefaults standardUserDefaults] stringForKey:kBirthday] substringWithRange:NSMakeRange(0, 10)];
            break;
        case 3:
            signLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:kSignature];
            break;
        case 4:
            areaLabel.text = [[[NSUserDefaults standardUserDefaults] stringForKey:kCounty] stringByReplacingOccurrencesOfString:@"$" withString:@""];
            break;
        default:
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kModifyType];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)modifyHeadImg:(UIButton *)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"选择本地图片", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==actionSheet.cancelButtonIndex) return ;

    UIImagePickerControllerSourceType sourceType = buttonIndex == 0 ?  UIImagePickerControllerSourceTypeCamera:
    UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self pickImageBy:sourceType];
}

#pragma mark -  AGMedallion Event
- (void)pickImageBy:(UIImagePickerControllerSourceType) sourceType;
{
    UIImagePickerController *ipc= [[UIImagePickerController alloc] init];
	ipc.sourceType = sourceType;
	ipc.delegate = self;
    ipc.allowsEditing=YES;
	[self presentModalViewController:ipc animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //图片储存路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    NSString *file = [documentsDirectory stringByAppendingPathComponent:@"/Caches"];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSString *imageName = [NSString stringWithFormat:@"%@.png",[NSDate date]];
    self.currentPhoto = [file stringByAppendingPathComponent:imageName];
    [UIImageJPEGRepresentation(image, 10.f) writeToFile:self.currentPhoto atomically:YES];
    
    [self.headImg setImage:image];
    
	[self dismissModalViewControllerAnimated:YES];
    
    hud = [[MBProgressHUD alloc] init];
    [hud setLabelText:@"保存中，请稍等！"];
    [hud show:YES];
    [self.view addSubview:hud];
    
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    NSString *urlString = [NSString stringWithFormat:@"%@/restful/user/user_info/%@" ,MM_URL, userid];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    headImgFormDataRequest = [ASIFormDataRequest requestWithURL:url];
    
    [headImgFormDataRequest setDelegate:self];
    [headImgFormDataRequest setTimeOutSeconds:120];
    [headImgFormDataRequest setDidFailSelector:@selector(requestHeadImgDidFailed:)];
    [headImgFormDataRequest setDidFinishSelector:@selector(requestHeadImgDidSuccess:)];
    [headImgFormDataRequest setRequestMethod:@"POST"];
    
    NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:PASSWORD];
    ;
    
    [headImgFormDataRequest addPostValue:password forKey:@"password"];
    [headImgFormDataRequest setFile:currentPhoto forKey:@"head_picture"];
    
    [headImgFormDataRequest startAsynchronous];
    
}

// Provide 2.x compliance
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
	NSDictionary *dict = [NSDictionary dictionaryWithObject:image forKey:UIImagePickerControllerEditedImage];
	[self imagePickerController:picker didFinishPickingMediaWithInfo:dict];
}

- (void)requestHeadImgDidFailed:(ASIFormDataRequest *)request
{
    [hud hide:YES];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络无法连接，请检查网络连接" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alertView show];
}

- (void)requestHeadImgDidSuccess:(ASIFormDataRequest *)request
{
    [hud hide:YES];
    
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
        NSDictionary *userInfo = [respponseDict objectForKey:@"user_info"];
        NSString *picPath = [userInfo objectForKey:@"pic_path"];
        [[NSUserDefaults standardUserDefaults] setObject:picPath forKey:kPic_path];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIAlertView *OK = [[UIAlertView alloc] initWithTitle:@"重要提示" message:@"头像设置成功！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [OK show];
        
    } else if (status == 1) {
        NSString *message = [respponseDict objectForKey:@"message"];
        UIAlertView *OK = [[UIAlertView alloc] initWithTitle:@"重要提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [OK show];
    }
}

- (IBAction)modifyNickname:(UIButton *)sender
{
    MModifyNicknameVC *modifyNicknameVC = [[MModifyNicknameVC alloc] init];
    [self.navigationController pushViewController:modifyNicknameVC animated:YES];
}

- (IBAction)modifyBirthday:(UIButton *)sender
{
    MModifyBirthdayVC *modifyBirthdayVC = [[MModifyBirthdayVC alloc] init];
    [self.navigationController pushViewController:modifyBirthdayVC animated:YES];
}

- (IBAction)modifySex:(UIButton *)sender
{
    UIAlertView *sexAlert = [[UIAlertView alloc] initWithTitle:@"性别" message:nil delegate:self cancelButtonTitle:@"男" otherButtonTitles: @"女",nil];
    [sexAlert show];

}

- (IBAction)modifySign:(UIButton *)sender
{
    MModifySignatureVC *modifySignatureVC = [[MModifySignatureVC alloc] init];
    [self.navigationController pushViewController:modifySignatureVC animated:YES];
}

- (IBAction)modifyArea:(UIButton *)sender
{
    MModifyAreaVC *modifyAreaVC = [[MModifyAreaVC alloc] init];
    [self.navigationController pushViewController:modifyAreaVC animated:YES];
}

- (IBAction)modifyPassword:(UIButton *)sender
{
    MModifyPasswordVC *modifyPasswordVC = [[MModifyPasswordVC alloc] init];
    [self.navigationController pushViewController:modifyPasswordVC animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *sex;
    switch (buttonIndex) {
        case 0:
            sex = @"1";
            [self.sexLabel setText:@"男"];
            break;
        case 1:
            sex = @"0";
            [self.sexLabel setText:@"女"];
            break;
        default:
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.sexLabel.text forKey:kSex];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    NSString *urlString = [NSString stringWithFormat:@"%@/restful/user/user_info/%@" ,MM_URL, userid];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    sexFormDataRequest = [ASIFormDataRequest requestWithURL:url];
    
    [sexFormDataRequest setDelegate:self];
    [sexFormDataRequest setTimeOutSeconds:kRequestTime];
    [sexFormDataRequest setDidFailSelector:@selector(requestDidFailed:)];
    [sexFormDataRequest setDidFinishSelector:@selector(requestDidSuccess:)];
    [sexFormDataRequest setRequestMethod:@"POST"];
    
    NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:PASSWORD];
    ;
    [sexFormDataRequest addPostValue:password forKey:@"password"];
    [sexFormDataRequest addPostValue:sex forKey:@"sex"];
    
    [sexFormDataRequest startAsynchronous];
    
}

- (void)requestDidFailed:(ASIFormDataRequest *)request
{
    [hud hide:YES];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络无法连接，请检查网络连接" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alertView show];
}

- (void) requestDidSuccess:(ASIFormDataRequest *)request
{
    [hud hide:YES];
    
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
        UIAlertView *OK = [[UIAlertView alloc] initWithTitle:@"重要提示" message:@"性别设置成功！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [OK show];
        
    } else if (status == 1) {
        NSString *message = [respponseDict objectForKey:@"message"];
        UIAlertView *OK = [[UIAlertView alloc] initWithTitle:@"重要提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [OK show];
    }
}

@end
