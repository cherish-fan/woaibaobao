//
//  AppDelegate.h
//  woaibaobao
//
//  Created by 梁建 on 14/10/15.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
#import "LoginViewController.h"

typedef void(^CompletionBlock)();
#define xmppDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    LoginViewController *login;
    
}

@property (strong, nonatomic) UIWindow *window;
#pragma mark -XMPP属性及做法



@property(strong,nonatomic,readonly)XMPPStream *xmppStream;
//xmppVcard头像模块
@property(strong,nonatomic,readonly)XMPPvCardAvatarModule *xmppvCardAvatarModule;
//xmppVcard模块
@property(strong,nonatomic,readonly)XMPPvCardTempModule *xmppvCardModule;
//花名册
@property(strong,nonatomic,readonly)XMPPRoster *xmppRoster;
//花名称模块
@property(strong,nonatomic,readonly)XMPPRosterCoreDataStorage *xmppRosterStorage;
/** 消息归档（归档）模块，只读属性
 *
 *
 */
@property(strong,nonatomic,readonly)XMPPMessageArchiving *xmppMessageArchiving;
@property(strong,nonatomic,readonly)XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;
//传输文件的socket数组
@property(assign,nonatomic) NSMutableArray *sockerList;
@property(assign,nonatomic)BOOL isRegisterUser;

/**
 *连接到服务器
 *用户信息保存在服务器中
 *@param completion 连接正确代码
 *@param faild     连接错误代码
 */
-(void)connecWithCompletion:(CompletionBlock)completion failed:(CompletionBlock)faild;
-(void)connect;
-(void)disconnect;
/**
 *注销用户登录
 
 
 */
-(void)logout;




































 
 
 
 
 











@end

