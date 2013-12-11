//
//  MChatListVC.m
//  Maomao
//
//  Created by zhao on 13-11-29.
//  Copyright (c) 2013年 BangQu. All rights reserved.
//

#import "MChatListVC.h"
#import "MChatListModel.h"
#import "Utils.h"
#import "JSON.h"
#import "MBackBtn.h"
#import "MRightBtn.h"
#import "MChatListCell.h"
#import "MTitleView.h"

@interface MChatListVC () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView    *chatListTV;
    NSTimer        *timeLoop;
    UIView         *faceView;
    BOOL            isShowFaces;
}

@end

@implementation MChatListVC

@synthesize sendView;
@synthesize contentTF;
@synthesize senderId;
@synthesize nameString;
@synthesize sendRequest;
@synthesize sendContentRequest;

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
    [self.view setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.91 alpha:1.0]];
    
    MTitleView *titleView = [[MTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    titleView.titleName.text = nameString;
    self.navigationItem.titleView = titleView;
    
    MBackBtn *backBtn = [MBackBtn buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    MRightBtn *rightBtn = [MRightBtn buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"资料" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    chatListSource =  [NSMutableArray arrayWithCapacity:0];
    
    chatListTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0+(noiOS7?0:64), 320, 416-43+(iPhone5?88:0)) style:UITableViewStylePlain];
    [chatListTV setDelegate:self];
    [chatListTV setDataSource:self];
    [chatListTV setRowHeight:95.0f];
    [chatListTV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:chatListTV];
    
    faceView = [[UIView alloc] initWithFrame:CGRectMake(0, 416+(iPhone5?88:0)-80+(noiOS7?0:64), 320, 80)];
    [faceView setHidden:YES];
    [self.view addSubview:faceView];
    
    for (int i = 0; i < 16; i++) {  //设置表情
        UIButton *faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (i < 9) {
            [faceBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ic_face_00%i.png",i+1]] forState:UIControlStateNormal];
        } else {
            [faceBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ic_face_0%i.png",i+1]] forState:UIControlStateNormal];
        }
        
        [faceBtn.titleLabel setText:[NSString stringWithFormat:@"[edu00%i]",i+1]];
        [faceBtn addTarget:self action:@selector(selectFacePict:) forControlEvents:UIControlEventTouchUpInside];
        if (i < 8) {
            [faceBtn setFrame:CGRectMake(20+i*(24+8), 10, 24, 24)];
        } else {
            [faceBtn setFrame:CGRectMake(20+(i-8)*(24+8), 10+34, 24, 24)];
        }
        [faceView addSubview:faceBtn];
    }

    hud = [[MBProgressHUD alloc] init];
    [hud setLabelText:@"加载中，请稍等！"];
    [hud show:YES];
    [self.view addSubview:hud];

    [self requestChatContent];
    
    timeLoop = [NSTimer scheduledTimerWithTimeInterval:5.0f
                                                target:self
                                              selector:@selector(requestChatContent)
                                              userInfo:nil
                                               repeats:YES];
    
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeKeyBoard:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)back
{
    [timeLoop invalidate];
    [self.sendRequest clearDelegatesAndCancel];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestChatContent
{
    [self.sendRequest clearDelegatesAndCancel];
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    
    NSString *url = [NSString stringWithFormat:@"%@/restful/user/message/info?sender_id=%@&receiver_id=%@", MM_URL, senderId, userid];
    [self initWithRequestByUrl:url];
}

#pragma mark -
#pragma mark  Send Request Method

- (void)initWithRequestByUrl:(NSString *)urlString;
{
    NSLog(@"urlString == %@",urlString);
    isNetWork = [Utils checkCurrentNetWork];
    
    if (!isNetWork) {
        if (prompting != nil) {
            [prompting removeFromSuperview];
            prompting = nil;
        }
        prompting = [[GPPrompting alloc] initWithView:self.view Text:@"网络链接中断" Icon:nil];
        [self.view addSubview:prompting];
        [prompting show];
        return;
    }
    
    if (self.sendRequest != nil) {
        [self.sendRequest clearDelegatesAndCancel];
        self.sendRequest = nil;
    }
    
    NSURL * url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    self.sendRequest = [ASIHTTPRequest requestWithURL:url];
    [self.sendRequest setTimeOutSeconds:kRequestTime];
    [self.sendRequest setDelegate:self];
    [self.sendRequest startAsynchronous];
}

- (IBAction)selectFace:(UIButton *)sender
{
    [self selectedFace];
}

- (void)selectedFace
{
    if (isShowFaces == NO) {
        [UIView animateWithDuration:0.25f animations:^{
            [faceView setHidden:NO];
            
            [sendView setFrame:CGRectMake(0, sendView.frame.origin.y-80, 320, 43)];
            [chatListTV setFrame:CGRectMake(0, chatListTV.frame.origin.y-80, 320, chatListTV.frame.size.height)];
        }];
        
        isShowFaces = YES;
        
    } else {
        [UIView animateWithDuration:0.25f animations:^{
            [faceView setHidden:YES];
            
            [chatListTV setFrame:CGRectMake(0, 0+(noiOS7?0:64), 320, 416-43+(iPhone5?88:0))];
            [sendView setFrame:CGRectMake(0, sendView.frame.origin.y+80, 320, 43)];
        }];
        
        isShowFaces = NO;
    }
}

- (void)selectFacePict:(UIButton *)button
{
    contentTF.text = [contentTF.text stringByAppendingString:button.titleLabel.text];
}

- (IBAction)sendContent:(UIButton *)sender
{
    [self.view endEditing:YES];
    if (isShowFaces == YES) {
        [self selectedFace];
    }

    [hud setLabelText:@"发送中，请稍等！"];
    [hud show:YES];

    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];

    NSString *url = [NSString stringWithFormat:@"%@/restful/user/sender/message?sender_id=%@&receiver_id=%@&content=%@", MM_URL, userid, senderId, contentTF.text];
    [self sendContentRequest:url];
    [contentTF setText:@""];
}

- (void)sendContentRequest:(NSString *)urlString;
{
    NSLog(@"urlString == %@",urlString);
    isNetWork = [Utils checkCurrentNetWork];
    
    if (!isNetWork) {
        if (prompting != nil) {
            [prompting removeFromSuperview];
            prompting = nil;
        }
        prompting = [[GPPrompting alloc] initWithView:self.view Text:@"网络链接中断" Icon:nil];
        [self.view addSubview:prompting];
        [prompting show];
        return;
    }
    
    if (self.sendContentRequest != nil) {
        [self.sendContentRequest clearDelegatesAndCancel];
        self.sendContentRequest = nil;
    }
    
    NSURL * url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    self.sendContentRequest = [ASIHTTPRequest requestWithURL:url];
    [self.sendContentRequest setTimeOutSeconds:kRequestTime];
    [self.sendContentRequest setDelegate:self];
    [self.sendContentRequest startAsynchronous];
}

#pragma mark -
#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    
    if (response == nil || [response JSONValue] == nil) {
        return;
    }
    
    NSDictionary *responseDict = [response JSONValue];
    
    if (request == sendRequest) {
        NSInteger status = [[responseDict objectForKey:@"status"] integerValue];
        NSArray *list = [responseDict objectForKey:@"list"];
        
        if ([chatListSource count] < [list count]) {
            [chatListSource removeAllObjects];
        }
        
        if (status == 0) {
            for (NSDictionary *dict in list) {
                MChatListModel *model = [[MChatListModel alloc] init];
                model.receiver_id = [dict objectForKey:@"receiver_id"];
                model.open_id = [dict objectForKey:@"open_id"];
                model.admin = [dict objectForKey:@"admin"];
                model.sender_id = [dict objectForKey:@"sender_id"];
                model.age = [dict objectForKey:@"age"];
                model.time = [dict objectForKey:@"time"];
                model.sex = [dict objectForKey:@"sex"];
                model.sign_up_date = [dict objectForKey:@"sign_up_date"];
                model.login_name = [dict objectForKey:@"login_name"];
                model.content = [dict objectForKey:@"content"];
                model.nick_name = [dict objectForKey:@"nick_name"];
                model.send_time = [dict objectForKey:@"send_time"];
                model.login_type = [dict objectForKey:@"login_type"];
                model.pic_path = [dict objectForKey:@"pic_path"];
                model.system_message_time = [dict objectForKey:@"system_message_time"];
                model.password = [dict objectForKey:@"password"];
                model.chatId = [dict objectForKey:@"id"];
                
                if ([chatListSource count] < [list count]) {
                    [chatListSource addObject:model];
                }
            }
            
            [chatListTV reloadData];
            
            if (chatListTV.contentSize.height > 416-43+(iPhone5?88:0)) {
                [chatListTV setContentOffset:CGPointMake(0, chatListTV.contentSize.height-416+43)];
            }
            
        }
        
        [hud hide:YES];
    }
    
    if (request == sendContentRequest) {
        NSInteger status = [[responseDict objectForKey:@"status"] integerValue];
        if (status == 0) {
            NSLog(@"发送成功");
            [self requestChatContent];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [hud hide:YES];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                       message:@"网络无法连接,请检查网络连接!"
                                                      delegate:self
                                             cancelButtonTitle:@"知道了"
                                             otherButtonTitles:nil];
    [alertView show];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [chatListSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cell";
    MChatListCell *cell = (MChatListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[MChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    
    if (!noiOS7) {
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    MChatListModel *model =[chatListSource objectAtIndex:indexPath.row];
    [cell setCellContent:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //----触摸取消输入----
    [self.view endEditing:YES];
}

#pragma mark ----键盘高度变化------
-(void)changeKeyBoard:(NSNotification *)aNotifacation
{
    //获取到键盘frame 变化之前的frame
    NSValue *keyboardBeginBounds=[[aNotifacation userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect beginRect=[keyboardBeginBounds CGRectValue];
    
    //获取到键盘frame变化之后的frame
    NSValue *keyboardEndBounds=[[aNotifacation userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect endRect=[keyboardEndBounds CGRectValue];
    
    CGFloat deltaY=endRect.origin.y-beginRect.origin.y;
    //拿frame变化之后的origin.y-变化之前的origin.y，其差值(带正负号)就是我们self.view的y方向上的增量
    
    
    [UIView animateWithDuration:0.25f animations:^{
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+deltaY, self.view.frame.size.width, self.view.frame.size.height)];
    }];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.
{
    //----触摸取消输入----
    [self.view endEditing:YES];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
