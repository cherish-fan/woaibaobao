//
//  MeMainVC.m
//  woaibaobao
//
//  Created by 梁建 on 14/10/26.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import "MeMainVC.h"
#import "XMPPUtils.h"
#import "LoginViewController.h"
#import "TDBadgedCell.h"
#import "messageNotificationUtils.h"
#import "QSUtils.h"
#import "MessageNotification.h"
#import "MyvCardVC.h"
#define SEGUE_ME_LOGIN @"Me2Login"
#define NOTIFY_BACK_CHAT @"notify_back_chat"

@interface MeMainVC ()<UIActionSheetDelegate,BackToChatTabDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)XMPPUtils *shareXMPP;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UITableView *settingTV;
@end

@implementation MeMainVC


-(void)loadView
{
    [super loadView];
    UIView *view=[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view=view;
    
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadTableView];
    _shareXMPP=[XMPPUtils sharedInstance];
    _dataArray=[NSMutableArray arrayWithObjects:@"我的名片",@"消息通知", nil];
    
    [QSUtils setExtraCellLineHidden:_settingTV];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addNotify];
    [self.parentViewController.tabBarItem setBadgeValue:nil];
    [_settingTV reloadData];
    
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self removeNotify];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(void)loadTableView
{
    _settingTV=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-28) style:UITableViewStyleGrouped];
 
    _settingTV.delegate=self;
    _settingTV.dataSource=self;
    _settingTV.userInteractionEnabled=YES;
    [self.view addSubview:_settingTV];
    
    UIButton *logoutBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    logoutBtn.frame=CGRectMake(20, 300, 280, 50);
    [logoutBtn setTitle:@"注销" forState:UIControlStateNormal];
    logoutBtn.backgroundColor=[UIColor redColor];
    [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchDragInside];
    [_settingTV addSubview:logoutBtn];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60.0;
            
    
}
    
//用户点击单元格调用此方法
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    [_settingTV deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 0){
        
        MyvCardVC *vCardVc=[[MyvCardVC alloc]init];
        [self.navigationController pushViewController:vCardVc animated:YES];
    
    
    
    }
    
    else if(indexPath.row == 1)
    {
        MessageNotification *messageNotifica=[[MessageNotification alloc]init];
        [self.navigationController pushViewController:messageNotifica animated:YES];
    }
    
    
    
    
    
}

#pragma mark -TableView Datasource





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArray.count;
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    
    
    TDBadgedCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil)
    {
        cell=[[TDBadgedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
  
    cell.textLabel.text=[_dataArray objectAtIndex:indexPath.row];
    
    if (indexPath.row==1)
    {
        if ([self hasUnsolvedRequest]) {
            cell.badge.fontSize=16.0;
            cell.badgeColor=[UIColor redColor];
            cell.badgeString=@"new";
        }else{
            [cell.badge setHidden:YES];
            cell.badgeColor=[UIColor whiteColor];
            
            
            
        }
    }
    
    
    
    
    return cell;
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    
    
    return 1;
}


#pragma mark - Message Notification

- (BOOL)hasUnsolvedRequest
{
    return ([messageNotificationUtils unsolvedFriendRequest] + [messageNotificationUtils unsolvedGroupRequest]) > 0;
}

-(void)addNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backtochatNotify) name:NOTIFY_BACK_CHAT object:nil];
}


-(void)backtochatNotify
{
    [self backToChatTab];
    
}





#pragma mark -BackToChatTabDelegate methods

-(void)removeNotify
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFY_BACK_CHAT object:nil];
}





-(void)backToChatTab
{
    [(UITabBarController *)self.parentViewController.parentViewController setSelectedIndex:0];
}
-(void)logout
{
    UIActionSheet *loginAction = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出当前帐号" otherButtonTitles:nil, nil];
    [loginAction showInView:self.view];
    
    
    
    
}
#pragma mark -UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:XMPP_USER_PASS];
        [userDefaults synchronize];
        [_shareXMPP disconnect];
        //[self performSegueWithIdentifier:SEGUE_ME_LOGIN sender:self];
    }
}







@end
