//
//  AppDelegate.m
//  woaibaobao
//
//  Created by 梁建 on 14/10/15.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "LoginViewController.h"
#import "NSData+XMPP.h"
#import "LoginUserModel.h"
#import "NSString+Helper.h"
#import "XMPPUtils.h"

@interface AppDelegate ()<XMPPStreamDelegate,XMPPRosterDelegate>
{
    CompletionBlock _completionBlock;//成功的块代码
    CompletionBlock _faildBlock;
    //Xmpp重新连接XmppStream
    XMPPReconnect *_xmppReconect;
    XMPPvCardCoreDataStorage *_xmppvCardStorage;
    XMPPCapabilities *_xmppCapabilities;//实体扩展模块
    XMPPCapabilitiesCoreDataStorage *_xmppCapabilitiesCoreDataStorage;//数据存储模块
    
}
@end
    
  
    
    
    
    
    






@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    NSLog(@"%@",NSHomeDirectory());
  
    
   
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    login=[[LoginViewController alloc]init];

    //[[XMPPUtils sharedInstance] setupStream];
    
    
    self.window.rootViewController=login;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self disconnect];
    NSLog(@"%@",ServerUrl);
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //[self connect];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)dealloc
{
    // 释放XMPP相关对象及扩展模块
    [self teardownStream];
}











-(void)setupStream
{
    
    
    
    
    //0.方法被调用时，要求_xmppStream必须为nil,否则通过断言提醒程序员,并终止程序运行！
    
    NSAssert(_xmppStream==nil, @"xmppstream被多次初始化！");
    
    
    _xmppStream=[[XMPPStream alloc]init];
    
    //添加代理
    
    
    
    
    
    
    
    
    
    //扩展模块
    //重新连接模块
    _xmppReconect=[[XMPPReconnect alloc]init];
    
    //2.2电子名片模块
    
    _xmppvCardStorage=[XMPPvCardCoreDataStorage sharedInstance];
    
    _xmppvCardModule=[[XMPPvCardTempModule alloc]initWithvCardStorage:_xmppvCardStorage];
    
    
    
    _xmppvCardAvatarModule=[[XMPPvCardAvatarModule alloc]initWithvCardTempModule:_xmppvCardModule];
    
    //2.4花名册模块
    
    _xmppRosterStorage=[[XMPPRosterCoreDataStorage alloc]init];
    _xmppRoster=[[XMPPRoster alloc] initWithRosterStorage:_xmppRosterStorage];
    
    
    
    //自动接收好友订阅请求
    
    
    [_xmppRoster setAutoAcceptKnownPresenceSubscriptionRequests:YES];
    
    //自动从服务器更新好友记录,例如:好友更改了名片
    
    [_xmppRoster setAutoFetchRoster:YES];
    
    
    
    //2.5 实体扩展模块
    
    _xmppCapabilitiesCoreDataStorage=[[XMPPCapabilitiesCoreDataStorage alloc]init];
    _xmppCapabilities=[[XMPPCapabilities alloc]initWithCapabilitiesStorage:_xmppCapabilitiesCoreDataStorage];
    
    
    //2.6消息归档模块、
    
    
    
    _xmppMessageArchivingCoreDataStorage=[[XMPPMessageArchivingCoreDataStorage alloc]init];
    
    _xmppMessageArchiving=[[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:_xmppMessageArchivingCoreDataStorage];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //将扩展模块添加到XmppStream
    [_xmppReconect activate:_xmppStream];
    
    [_xmppvCardModule activate:_xmppStream];
    [_xmppvCardAvatarModule activate:_xmppStream];
    [_xmppRoster activate:_xmppStream];
    [_xmppCapabilities activate:_xmppStream];
    [_xmppMessageArchiving activate:_xmppStream];
    
    
    
    
    
    //4.添加代理
    //由于所有网络请求都是基于网络的数据代理，这些数据处理工作与界面UI无关。
    //因此可以让请求网络的代理方法在其他线程中运行，从而提高程序的运行性能，避免出现应用程序的阻塞情况
    
    
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    [_xmppRoster addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0 )];
    
    
    
    
    
    
    
    
    
    
    
    
}

// 销毁XMPPStream并注销已注册的扩展模块
- (void)teardownStream
{
    // 1. 删除代理
    [_xmppStream removeDelegate:self];
    [_xmppRoster removeDelegate:self];
    
    // 2. 取消激活在setupStream方法中激活的扩展模块
    [_xmppReconect deactivate];
    [_xmppvCardModule deactivate];
    [_xmppvCardAvatarModule deactivate];
    [_xmppRoster deactivate];
    [_xmppCapabilities deactivate];
    [_xmppMessageArchiving deactivate];
    
    // 3. 断开XMPPStream的连接
    [_xmppStream disconnect];
    
    // 4. 内存清理
    _xmppStream = nil;
    _xmppReconect = nil;
    _xmppvCardModule = nil;
    _xmppvCardAvatarModule = nil;
    _xmppvCardStorage = nil;
    _xmppRoster = nil;
    _xmppRosterStorage = nil;
    _xmppCapabilities = nil;
    _xmppCapabilitiesCoreDataStorage = nil;
    _xmppMessageArchiving = nil;
    _xmppMessageArchivingCoreDataStorage = nil;
}

-(void)goOnline
{
    
    XMPPPresence *presence=[XMPPPresence presence];
    [_xmppStream sendElement:presence];
    
    
    
}

//XmppStream离线,用presence来更新用户在服务器的状态

-(void)goOffine
{
    
    XMPPPresence *presence=[XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:presence];
}

//向服务器发送请求

-(void)connect
{
    //1，设置xmppstream
    
    
    
    
    
    
    
    
    
    if ([_xmppStream isConnected])
    {
        return;
    }
    
    
    
    
    
    
    //2,设置用户名，密码和服务器
    NSString *userName=[[LoginUserModel sharedLoginUserModel] myJIDName];
    NSString *hostName=[[LoginUserModel sharedLoginUserModel] hostName];
    if ([hostName isEmptyString]||[userName isEmptyString])
    {
        
        return;
        
    }
    
    
    
    
    [_xmppStream setMyJID:[XMPPJID jidWithString:userName]];
    [_xmppStream setHostName:hostName];
    [_xmppStream setHostPort:28888];
  
    NSError *error=nil;
    
    
    
    
    
    //连接到服务器
    [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    
     // 提示：如果没有指定JID和hostName，才会出错，其他都不出错。
    if (error)
    {
        NSLog(@"连接错误:%@",[error localizedDescription]);
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

#pragma mark 连接到服务器
-(void)connecWithCompletion:(CompletionBlock)completion failed:(CompletionBlock)faild
{
    // 1. 记录块代码
    _completionBlock = completion;
    _faildBlock = faild;
    
    // 2. 如果已经存在连接，先断开连接，然后再次连接
    if ([_xmppStream isConnected]) {
        [_xmppStream disconnect];
    }
    
    // 3. 连接到服务器
    [self connect];
}



-(void)disconnect
{
    
    
    //发送离线状态
    [self goOffine];
    
    
    //_xmppStream断开连接
    [_xmppStream disconnect];
}

- (void)logout
{
    // 1. 通知服务器下线，并断开连接
    [self disconnect];
    
    // 2. 显示用户登录Storyboard
    
}





#pragma mark - XMppDelegate
#pragma mark 连接到服务器(如果服务器地址不对，则不会调用此方法)

- (void)xmppStreamDidConnect:(XMPPStream *)sender;
{
    NSError *error=nil;
    
    _isRegisterUser=NO;
    
    NSString *passWord=[[LoginUserModel sharedLoginUserModel] password];
    
    if (_isRegisterUser)
    {
        
        
        
        [_xmppStream registerWithPassword:passWord error:&error];
        
        
        if (error)
        {
            NSLog(@"身份验证出错:%@",[error localizedDescription]);
            
        }else{
            
            
            
            NSLog(@"身份验证成功");
        }
        
        
    }else{
        [_xmppStream authenticateWithPassword:passWord error:&error];
        
        
        
        if (error) {
            NSLog(@"身份验证出错:%@",[error localizedDescription]);
            
        }else{
            
            
            
            NSLog(@"身份验证成功");
        }
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
}

#pragma mark 注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    _isRegisterUser = NO;
    
    // 注册成功，直接发送验证身份请求，从而触发后续的操作
    [_xmppStream authenticateWithPassword:[LoginUserModel sharedLoginUserModel].password  error:nil];
}

#pragma mark 注册失败(用户名已经存在)
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    _isRegisterUser = NO;
    if (_faildBlock != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _faildBlock();
        });
    }
}

















#pragma mark-通过验证

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    
    if (_completionBlock!=nil)
    {
    dispatch_async(dispatch_get_main_queue(), ^{
    
     _completionBlock();
    
    });
    }
    
    
    NSLog(@"验证通过");
    
    
    
    [self goOnline];
    
    
    #warning 在这里展示登录后的主界面
//    
//        XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithString:@"admin@jianliangdemac-mini.local"]];
//    
//        [message addBody:@"我是哈哈"];
//    
//        [ _xmppStream sendElement:message];
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MainViewController *main=[[MainViewController alloc]init];
        
        main.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        
        
        
        
        
        
        [login presentViewController:main animated:YES completion:^{
            NSLog(@"call back");
            
            
        }];
  
        
        
        
        
        
        
        
    });
    
    
    
    
    
    
    
    
    
}

#pragma mark-验证失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    NSLog(@"验证失败:%@",error);
    
     if (_faildBlock!=nil)
    {
    dispatch_async(dispatch_get_main_queue(), ^{
    
     _faildBlock();
    
    });
    }
    
    
#warning 要在这里添加回到用户登录界面的代码
    
    
}



























#pragma mark 用户展现变化
#pragma mark 添加好友
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    
    NSLog(@"接收到用户展示数据.%@",presence);
    
    //1.判断接收到的presence类型是否为subscribe
    if ([presence.type isEqualToString:@"subscribe"])
    {
        //2 取出presence的from的jid
        XMPPJID *from=[presence from];
        
        //3 接收来自from添加好友的订阅请求
        [_xmppRoster acceptPresenceSubscriptionRequestFrom:from andAddToRoster:YES];
        
        
        
        
        
        
        
    }
    
    
}

#pragma mark 判断IQ是否是SI请求

-(BOOL)isSIRequest:(XMPPIQ *)iq
{
    
    
    NSXMLElement *si=[iq elementForName:@"si" xmlns:@"http://jabber.org/protocol"];
    
    NSString *uuid=[[si attributeForName:@"id"]stringValue];
    if (si&&uuid)
    {
        return YES;
    }
    
    
    
    
    
    
    return NO;
    
    
}

#pragma mark 接收请求

-(BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    NSLog(@"接收到请求 - %@",iq);
    //0.判断IQ是否是SI请求
    if ([self isSIRequest:iq])
    {
        
        
        
        TURNSocket *socket=[[TURNSocket alloc]initWithStream:_xmppStream toJID:iq.to];
        
        [_sockerList addObject:socket];
        [socket startWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        
        
        
        
    }
    
    
    
    
    
    
    
    return YES;
}








#pragma mark 接收消息











- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    
    
    NSLog(@"接收到用户信息%@",message);
    
    
    
    //接收别人发送的图像
    NSString *imageStr = [[message elementForName:@"imageData"] stringValue];
    
    if (imageStr)
    {
        // 2. 解码成图像
        NSData *data = [[NSData alloc] initWithBase64EncodedString:imageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        // 3. 保存图像
        UIImage *image = [UIImage imageWithData:data];
        // 4. 将图像保存到相册
        // 1) target 通常用self
        // 2) 保存完图像调用的方法
        // 3) 上下文信息
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    
    
    
    
    
    
}

#pragma mark - XMPProster代理


- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    
    
    
    NSLog(@"接收到其他用户的请求 %@",presence);
    
    
    
    
    
}









@end
