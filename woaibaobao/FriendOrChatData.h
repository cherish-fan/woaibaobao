//
//  FriendOrChatData.h
//  woaibaobao
//
//  Created by 梁建 on 14/10/20.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpConnectLoader.h"
@interface FriendOrChatData : NSObject<ASIHTTPRequestDelegate>




-(void)getUserMessageWithAccount:(NSString *)account
                     WithDeleage:(id <ASIHTTPRequestDelegate>)delegate;
//发送文本消息
//发送文本消息type的类型为0或1,0是用户－>用户1,1是用户－>群组
-(void)sendMessageFromSender:(NSString *)sender
                  toReceiver:(NSString *)receiver
                 withContent:(NSString *)content
                     andType:(NSString *)type
                 withDeleage:(id <ASIHTTPRequestDelegate>)delegate;


-(void)addFriendFromAccount:(NSString *)account
                  toAccount:(NSString *)Friend
               withDelegate:(id <ASIHTTPRequestDelegate>)delegate;



-(void)createGroupWithGroupName:(NSString *)groupName
                    withFounder:(NSString *)founder
                andGroupSummary:(NSString *)summary
                   withDelegate:(id <ASIHTTPRequestDelegate>)delegate;


-(void)getGroupListWithAccount:(NSString *)account
                        withDelegate:(id <ASIHTTPRequestDelegate>)delegate;

-(void)addGroupMemberWithAccount:(NSString *)account
                         toGroup:(NSString *)groupid
                          withDelegate:(id <ASIHTTPRequestDelegate>)delegate;


-(void)getGroupMemberListWithGroupId:(NSString *)groupId
                             withDelegate:(id <ASIHTTPRequestDelegate>)delegate;


-(void)removeGroupMemberWithAccount:(NSString *)account
                          fromGroup:(NSString *)groupid
                           withDelegate:(id <ASIHTTPRequestDelegate>)delegate;


-(void)modifyPasswordWithAccount:(NSString *)account
                 WithOldPassword:(NSString *)oldPassword
                 WithNewPassword:(NSString *)newPassword
                  withDelegate:(id <ASIHTTPRequestDelegate>)delegate;
                                  
-(void)modifyUserInfo:(NSString *)account
             withName:(NSString *)name
             withIcon:(NSString *)icon
         withDelegate:(id <ASIHTTPRequestDelegate>)delegate;

-(void)deleateFriend:(NSString *)friends
       WithMyAccount:(NSString *)account
        withDelegate:(id <ASIHTTPRequestDelegate>)delegate;


-(void)registerAccount:(NSString *)account
           withPassWord:(NSString *)password withName:(NSString *)name
              withIcon:(NSString *)icon
              withDelegate:(id <ASIHTTPRequestDelegate>)delegate;





@end
