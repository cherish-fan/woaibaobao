//
//  XMPPUtils.m
//  QShare
//
//  Created by Vic on 14-4-16.
//  Copyright (c) 2014年 vic. All rights reserved.
//

#import "XMPPUtils.h"
#import "QSUtils.h"
#import "XMPPvCardTemp.h"
#import "DDLog.h"
#import "GCDAsyncSocket.h"
#import "FMDatabase.h"
#import "DDTTYLogger.h"
#import "TURNSocket.h"
#define QUERY_ROSTER @"queryRoster"

#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

#define DOCUMENT_PATH NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
#define CACHES_PATH NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]

NSString *password;  //密码

BOOL isanonymousConnect = NO; //是不是匿名登录

@implementation XMPPUtils

/**
 *  单例方法创建
 *
 *  @return 返回单例的对象
 */
+ (XMPPUtils *) sharedInstance
{
   static XMPPUtils *sharedUtils = nil;
   
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
        sharedUtils = [[XMPPUtils alloc]init];
      
       [DDLog addLogger:[DDTTYLogger sharedInstance]];
    });
    return sharedUtils;
}

/**
 *  进行一些初始化工作
 */
-(void)setupStream
{
    
    NSAssert(_xmppStream == nil, @"Method setupStream invoked multiple times");

    
    //初始化XMPPStream
    _xmppStream = [[XMPPStream alloc] init];
    
    
    
#if !TARGET_IPHONE_SIMULATOR
    {
        xmppStream.enableBackgroundingOnSocket = YES;
    }
#endif
    
    
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    
    //初始化XMPPReconnect
    _xmppReconnect = [[XMPPReconnect alloc]init];
    [_xmppReconnect activate:_xmppStream];
    
    
    
    
    //2.5 实体扩展模块
    
    _xmppCapabilitiesCoreDataStorage=[[XMPPCapabilitiesCoreDataStorage alloc]init];
    _xmppCapabilities=[[XMPPCapabilities alloc]initWithCapabilitiesStorage:_xmppCapabilitiesCoreDataStorage];
    
    [_xmppCapabilities activate:_xmppStream];
    
    
    
    
    
    
    
    
    
    // 初始化 xmppRosterStorage
    _xmppRosterDataStorage = [XMPPRosterCoreDataStorage sharedInstance];
    _xmppRoster = [[XMPPRoster alloc]initWithRosterStorage:_xmppRosterDataStorage];
    [_xmppRoster activate:_xmppStream];
    [_xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    _xmppRoster.autoFetchRoster = NO;
    _xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    
    // 初始化 message
    _xmppMessageArchivingCoreDataStorage = [[XMPPMessageArchivingCoreDataStorage alloc]init];
    NSLog(@"%@",_xmppMessageArchivingCoreDataStorage);
//    
//    _xmppMessageArchivingModule = [[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:_xmppMessageArchivingCoreDataStorage];
    
     _xmppMessageArchiving=[[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:_xmppMessageArchivingCoreDataStorage];
    [_xmppMessageArchiving activate:_xmppStream];
    
    
//    
//    [_xmppMessageArchivingModule setClientSideMessageArchivingOnly:YES];
//    [_xmppMessageArchivingModule activate:_xmppStream];
//    [_xmppMessageArchivingModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // 初始化 vCard support
    _xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:_xmppvCardStorage];
    [_xmppvCardTempModule activate:_xmppStream];
    [_xmppvCardTempModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // 初始化 XMPPMUC
    _xmppRoomCoreDataStorage = [XMPPRoomCoreDataStorage sharedInstance];
    _xmppMUC = [[XMPPMUC alloc]initWithDispatchQueue:dispatch_get_main_queue()];
    [_xmppMUC activate:_xmppStream];
    [_xmppMUC addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    
}


#pragma mark - Application's Documents directory

/**
 *   Returns the URL to the application's Documents directory.

 *
 *  @return  Returns the URL to the application's Documents directory.

 */
- (NSURL *)applicationDocumentsDirectory
{
   
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

/**
 *  发送在线状态
 */

-(void)goOnline
{
    
   
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [_xmppStream sendElement:presence];
    
}
/**
 *  发生下线状态
 */
-(void)goOffline
{
    
 
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:presence];
    
}

/**
 *  开始连接Xmpp
 *
 *  @return 开始连接xmpp
 */
-(BOOL)connect
{
    
    isanonymousConnect = NO;
    
    //[self setupStream];
    
    //从本地取得用户名，密码和服务器地址
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userName = [defaults stringForKey:XMPP_USER_NAME];
    NSString *jidString = [NSString stringWithFormat:@"%@@%@",userName,XMPP_HOST_NAME];
    NSString *pass = [defaults stringForKey:XMPP_USER_PASS];
    NSString *server = XMPP_HOST_NAME;
    
    if (![_xmppStream isDisconnected])
    {
        return YES;
    }
    
    if (userName == nil || pass == nil)
    {
        return NO;
    }
    
    //设置用户
    [_xmppStream setMyJID:[XMPPJID jidWithString:jidString]];
    //设置服务器
    [_xmppStream setHostName:server];
    //密码
    password = pass;
    
    //连接服务器
    NSError *error = nil;
    if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
        NSLog(@"cant connect %@", server);
        return NO;
    }
    
    return YES;
    
}

/**
 *  用户注册时用的连接的xmpp
 */
- (void)anonymousConnect
{
    isanonymousConnect = YES;
    [self setupStream];
    NSString *jidString = [[NSString alloc] initWithFormat:@"anonymous@%@",XMPP_HOST_NAME];
    NSString *server = XMPP_HOST_NAME;
    [_xmppStream setMyJID:[XMPPJID jidWithString:jidString]];
    [_xmppStream setHostName:server];
    NSError *error;
    if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
        NSLog(@"cant connect server");
    }
}

-(void)enrollWithUserName:(NSString *)userName andPassword:(NSString *)pass
{
    NSString *jidString = [[NSString alloc] initWithFormat:@"%@@%@",userName,XMPP_HOST_NAME];
    [_xmppStream setMyJID:[XMPPJID jidWithString:jidString]];
    NSError *error;
    if (![_xmppStream registerWithPassword:pass error:&error])
    {
        NSLog(@"创建用户失败%@",[error localizedDescription]);
    }
}
/**
 *  查询用户好友
 */
- (void)queryRoster {
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    XMPPJID *myJID = _xmppStream.myJID;
    [iq addAttributeWithName:@"from" stringValue:myJID.description];
    [iq addAttributeWithName:@"to" stringValue:myJID.domain];
    [iq addAttributeWithName:@"id" stringValue:QUERY_ROSTER];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [iq addChild:query];
    [_xmppStream sendElement:iq];
}

/**
 *  添加好友
 *
 *  @param userName 输入添加的好友昵称
 */
-(void)addFriend:(NSString *)userName;
{
    NSString *jidString = [[NSString alloc] initWithFormat:@"%@@%@",userName,XMPP_HOST_NAME];
    [_xmppRoster addUser:[XMPPJID jidWithString:jidString] withNickname:nil];
}
/**
 *  删除好友
 *
 *  @param userName 输入删除好友的名字
 */
-(void)delFriend:(NSString *)userName;
{
     NSString *jidString = [[NSString alloc] initWithFormat:@"%@@%@",userName,XMPP_HOST_NAME];
    [_xmppRoster removeUser:[XMPPJID jidWithString:jidString]];
}

/**
 *  与xmpp服务器断开连接
 */
-(void)disconnect{
    
    [self goOffline];
    [_xmppRoster deactivate];
    [_xmppStream disconnect];
}

#pragma mark - Add or isExist Room JID

-(void)addRoom:(XMPPRoom *)room
{
    if (!_rooms) {
        _rooms = [[NSMutableSet alloc]init];
    }
    if (![self isExistRoom:[room roomJID]]) {
        [_rooms addObject:room];
    }
}

-(BOOL)isExistRoom:(XMPPJID *)roomJID
{
    BOOL isExist = NO;
    for (XMPPRoom *existRoom in _rooms) {
        if ([[existRoom.roomJID bare] isEqualToString:[roomJID bare]]) {
            isExist = YES;
            break;
        }
    }
    return isExist;
}

-(XMPPRoom *)getExistRoom:(XMPPJID *)roomJID
{
    XMPPRoom *existedRoom = nil;
    for (XMPPRoom *existRoom in _rooms) {
        if ([[existRoom.roomJID bare] isEqualToString:[roomJID bare]]) {
            existedRoom = existRoom;
            break;
        }
    }
    return existedRoom;
}


#pragma mark XMPPStreamDelegate methods

//连接服务器
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"didconnect");
    NSError *error = nil;
    if (!isanonymousConnect) {
        //验证密码
        [_xmppStream authenticateWithPassword:password error:&error];
    }
    else
    {
        [_connectDelegate anonymousConnected];
    }
    
    
}

//验证通过
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    NSLog(@"didauthenticate");
    [_connectDelegate didAuthenticate];
    [self goOnline];

    [_xmppvCardTempModule fetchvCardTempForJID:_xmppStream.myJID];
}


//没有通过验证
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    [_connectDelegate didNotAuthenticate:error];
}

//注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    [_connectDelegate registerSuccess];
}

//注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
    [_connectDelegate registerFailed:error];
}

//收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    
//    //消息回执
//    
//        NSXMLElement *request = [message elementForName:@"request"];
//        if (request)
//        {
//            if ([request.xmlns isEqualToString:@"urn:xmpp:receipts"])//消息回执
//            {
//                //组装消息回执
//                XMPPMessage *msg = [XMPPMessage messageWithType:[message attributeStringValueForName:@"type"] to:message.from elementID:[message attributeStringValueForName:@"id"]];
//                NSXMLElement *recieved = [NSXMLElement elementWithName:@"received" xmlns:@"urn:xmpp:receipts"];
//                [msg addChild:recieved];
//    
//                //发送回执
//                [self.xmppStream sendElement:msg];
//            }
//        }else
//        {
//            NSXMLElement *received = [message elementForName:@"received"];
//            if (received)
//            {
//                if ([received.xmlns isEqualToString:@"urn:xmpp:receipts"])//消息回执
//                {
//                    //发送成功
//                    NSLog(@"message send success!");
//                }
//            }
//        }
    
   
    
    
    
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);    
    
    
    
    
    
    
    
    
    
    
    
    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSLog(@"message:%@",message);
    if (!msg)
        return;
    if([message isErrorMessage])
        return;
    
    // block group chat system message
    if ([[[message attributeForName:@"type"] stringValue] isEqualToString:@"groupchat"] && [message.from isBare]) {
        return;
    }
    XMPPJID *fromJID = message.from;
    NSString *from = [fromJID user];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:msg forKey:@"body"];
    [dict setObject:[NSDate dateWithTimeIntervalSinceNow:0] forKey:@"timestamp"];
    
    XMPPJID *chatJID;

    if ([message isChatMessage]) {
        [dict setObject:from forKey:@"chatwith"];
        [dict setObject:@(NO) forKey:@"isOutgoing"];
        chatJID = fromJID;
    }
    else if ([[[message attributeForName:@"type"] stringValue] isEqualToString:@"groupchat"]){
        [dict setObject:@"groupchat" forKey:@"chatType"];
        [dict setObject:[fromJID resource] forKey:@"from"];
        [dict setObject:[fromJID bare] forKey:@"roomJID"];
        chatJID = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",[fromJID resource],XMPP_HOST_NAME]];
        dict[@"isOutgoing"] = [[fromJID resource] isEqualToString:_xmppStream.myJID.user] ? @(YES) : @(NO);
    }
    
    [_xmppvCardTempModule fetchvCardTempForJID:chatJID];
    XMPPvCardTemp *vCard = [_xmppvCardTempModule vCardTempForJID:chatJID shouldFetch:YES];
    NSData *avatarData = vCard.photo;
    
    if (avatarData)
    {
        [dict setObject:avatarData forKey:@"chatWithAvatar"];
    }
    
    if ([UIApplication sharedApplication].applicationState!=UIApplicationStateActive)
    {
        
        UILocalNotification *location=[[UILocalNotification alloc] init];
        location.alertAction=@"OK";
        
        
        
    }
    
    [self.messageDelegate newMessageReceived:dict];
   
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CHAT_MSG object:dict];

}

//收到好友状态,参照微信不设置在线状态

/*
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    NSString *presentType = [presence type];
    NSString *presentUser = [[presence from] user];
    NSString *senderUser = [[sender myJID]user];
//    NSString *presentFrom = [[presence from]full];
//    NSString *presentTo = [[presence to]full];
    if (![senderUser isEqualToString:presentUser]) {
        if (![presentType isEqualToString:@"unavailable"] )
        {
            [_presentDelegate online:presentUser];
        }
        else
        {
            [_presentDelegate offline:presentUser];
        }
    }
    
}
 
*/

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    NSXMLElement *queryElement = [iq elementForName: @"query" xmlns: @"jabber:iq:roster"];
    
    if (queryElement) {
            [_friendsDelegate removeFriens];
            NSArray *items = [queryElement elementsForName: @"item"];
            for (NSXMLElement *item in items) {
                NSString *jidString = [item attributeStringValueForName:@"jid"];
                XMPPJID *jid = [XMPPJID jidWithString:jidString];
                [_xmppvCardTempModule fetchvCardTempForJID:jid];
                XMPPvCardTemp *vCard = [_xmppvCardTempModule vCardTempForJID:jid shouldFetch:YES];
                NSData *avatarData = vCard.photo;
                NSString *userName = [jid user];
                NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithCapacity:4];
                if (avatarData) {
                    [mutableDict setObject:avatarData forKey:@"avatar"];
                }
                [mutableDict setObject:userName forKey:@"name"];
                NSDictionary *friendDict = [[NSDictionary alloc]initWithDictionary:mutableDict];
                [_friendsDelegate friendsList:friendDict];
            }
    }
    return YES;
}

#pragma mark - XMPPRosterDelegate

- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    if([[presence type] isEqualToString:@"subscribe"]){
        NSString *myString = [_xmppStream.myJID user];
        NSString *requestRosterDefault = [NSString stringWithFormat:@"%@_requestRoster",myString];
        NSDictionary *requestRosterDict = @{@"from": [presence fromStr], @"to": [presence toStr]};
        
        if([[NSUserDefaults standardUserDefaults] objectForKey:requestRosterDefault]){
            NSMutableArray *array = [[[NSUserDefaults standardUserDefaults] objectForKey:requestRosterDefault] mutableCopy];
            [array insertObject:requestRosterDict atIndex:0];
            [[NSUserDefaults standardUserDefaults] setObject:array forKey:requestRosterDefault];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else{
            NSMutableArray *array = [NSMutableArray arrayWithObject:requestRosterDict];
            [[NSUserDefaults standardUserDefaults] setObject:array forKey:requestRosterDefault];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_Friends_Request object:@"friendsInvite"];
    }
}

#pragma mark - XMPPMUCDelegate

- (void)xmppMUC:(XMPPMUC *)sender roomJID:(XMPPJID *) roomJID didReceiveInvitation:(XMPPMessage *)message
{
    NSString *myString = [_xmppStream.myJID user];
    NSString *groupInviteDefault = [NSString stringWithFormat:@"%@_groupInvite",myString];
    
    NSString *roomName = [roomJID user];
    
    NSXMLElement *x = [message elementForName:@"x" xmlns:XMPPMUCUserNamespace];
	NSXMLElement *inviteElement = [x elementForName:@"invite"];
    NSXMLElement *reasonElement = [inviteElement elementForName:@"reason"];
    
    NSString *whoInvite = [inviteElement attributeStringValueForName:@"from"];
    NSString *inviteMessage = [reasonElement stringValue];
    
    NSDictionary *groupInviteDict = @{@"from": whoInvite, @"room": roomName, @"reason": inviteMessage};
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:groupInviteDefault]){
        NSMutableArray *array = [[[NSUserDefaults standardUserDefaults] objectForKey:groupInviteDefault] mutableCopy];
        [array insertObject:groupInviteDict atIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:groupInviteDefault];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else{
        NSMutableArray *array = [NSMutableArray arrayWithObject:groupInviteDict];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:groupInviteDefault];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }


}

- (void)xmppMUC:(XMPPMUC *)sender roomJID:(XMPPJID *) roomJID didReceiveInvitationDecline:(XMPPMessage *)message
{
    NSLog(@"didReceiveInvitationDecline");
}

#pragma mark-UIApplicationDelegate
#pragma mark UIApplicationDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store
    // enough application state information to restore your application to its current state in case
    // it is terminated later.
    //
    // If your application supports background execution,
    // called instead of applicationWillTerminate: when the user quits.
    
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
#if TARGET_IPHONE_SIMULATOR
    DDLogError(@"The iPhone simulator does not process background network traffic. "
               @"Inbound traffic is queued until the keepAliveTimeout:handler: fires.");
#endif
    
    if ([application respondsToSelector:@selector(setKeepAliveTimeout:handler:)])
    {
        [application setKeepAliveTimeout:600 handler:^{
            
            DDLogVerbose(@"KeepAliveHandler");
            
            // Do other keep alive stuff here.
        }];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}


- (FMDatabase*)openUserDb:(NSString*)userId{
    userId = [userId uppercaseString];
    if([_userIdOld isEqualToString:userId])
    {
        if(_db && [_db goodConnection])
            return _db;
    }
    _userIdOld = [userId copy];
    NSString* t =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString* s = [NSString stringWithFormat:@"%@/%@.db",t,userId];
    
    [_db close];
   
    _db = [[FMDatabase alloc] initWithPath:s];
    if (![_db open]) {
        NSLog(@"数据库打开失败");
        return nil;
    };
    return _db;
}




@end
