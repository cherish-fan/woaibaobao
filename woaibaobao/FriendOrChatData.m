//
//  FriendOrChatData.m
//  woaibaobao
//
//  Created by 梁建 on 14/10/20.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import "FriendOrChatData.h"
#import "JSONKit.h"
@implementation FriendOrChatData

-(void)getUserMessageWithAccount:(NSString *)account WithDeleage:(id<ASIHTTPRequestDelegate>)delegate
{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:account,@"account", nil];
    [HttpConnectLoader loadInBackgroundWithUrl:[ServerUrl stringByAppendingString:GetFriendList] setDelegate:delegate setID:1 setParams:dic setFiles:nil];
    
    
}

-(void)sendMessageFromSender:(NSString *)sender
                  toReceiver:(NSString *)receiver
                 withContent:(NSString *)content
                     andType:(NSString *)type
                 withDeleage:(id <ASIHTTPRequestDelegate>)delegate
{
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:sender,@"sender",receiver,@"receiver" ,content,@"content",type,@"type",nil];
    [HttpConnectLoader loadInBackgroundWithUrl:[ServerUrl stringByAppendingString:SendMessage] setDelegate:delegate setID:1 setParams:dic setFiles:nil];
    
    
    
    
    
    
}

-(void)addFriendFromAccount:(NSString *)account
                  toAccount:(NSString *)Friend
               withDelegate:(id <ASIHTTPRequestDelegate>)delegate
{
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:account,@"account",Friend,@"friend",nil];
    [HttpConnectLoader loadInBackgroundWithUrl:[ServerUrl stringByAppendingString:AddFriend] setDelegate:delegate setID:1 setParams:dic setFiles:nil];
    
    
}

-(void)createGroupWithGroupName:(NSString *)groupName
                    withFounder:(NSString *)founder
                andGroupSummary:(NSString *)summary
                   withDelegate:(id <ASIHTTPRequestDelegate>)delegate
{
    
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:groupName,@"name",founder,@"founder",summary,@"summary",nil];
    [HttpConnectLoader loadInBackgroundWithUrl:[ServerUrl stringByAppendingString:CreateGroup] setDelegate:delegate setID:1 setParams:dic setFiles:nil];
  
    
    
    
    
    
    
    
    
}


-(void)getGroupListWithAccount:(NSString *)account
                  withDelegate:(id <ASIHTTPRequestDelegate>)delegate
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:account,@"account", nil];
    [HttpConnectLoader loadInBackgroundWithUrl:[ServerUrl stringByAppendingString:GroupList] setDelegate:delegate setID:1 setParams:dic setFiles:nil];
    
}

-(void)addGroupMemberWithAccount:(NSString *)account
                         toGroup:(NSString *)groupid
                    withDelegate:(id <ASIHTTPRequestDelegate>)delegate
{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:account,@"account",groupid,@"groupId", nil];
    [HttpConnectLoader loadInBackgroundWithUrl:[ServerUrl stringByAppendingString:AddGroupMember] setDelegate:delegate setID:1 setParams:dic setFiles:nil];
    
    
    
}
-(void)getGroupMemberListWithGroupId:(NSString *)groupId
                        withDelegate:(id <ASIHTTPRequestDelegate>)delegate
{
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:groupId,@"groupId", nil];
    [HttpConnectLoader loadInBackgroundWithUrl:[ServerUrl stringByAppendingString:GroupMember_list] setDelegate:delegate setID:1 setParams:dic setFiles:nil];
   
    
    
    
    
    
    
    
}


-(void)removeGroupMemberWithAccount:(NSString *)account
                          fromGroup:(NSString *)groupid
                       withDelegate:(id <ASIHTTPRequestDelegate>)delegate
{
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:groupid,@"groupId",account,@"account",nil];
    [HttpConnectLoader loadInBackgroundWithUrl:[ServerUrl stringByAppendingString:removeGroupMember] setDelegate:delegate setID:1 setParams:dic setFiles:nil];
    
    
    
    
    
}

-(void)modifyPasswordWithAccount:(NSString *)account
                 WithOldPassword:(NSString *)oldPassword
                 WithNewPassword:(NSString *)newPassword
                    withDelegate:(id <ASIHTTPRequestDelegate>)delegate
{
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:account,@"account",oldPassword,@"oldPassword",newPassword,@"newPassword",nil];
    [HttpConnectLoader loadInBackgroundWithUrl:[ServerUrl stringByAppendingString:ModifyPassword] setDelegate:delegate setID:1 setParams:dic setFiles:nil];

    
    
    
    
    
    
}


-(void)modifyUserInfo:(NSString *)account
             withName:(NSString *)name
             withIcon:(NSString *)icon
             withDelegate:(id <ASIHTTPRequestDelegate>)delegate
{
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:account,@"account",name,@"name",icon,@"icon",nil];
    [HttpConnectLoader loadInBackgroundWithUrl:[ServerUrl stringByAppendingString:ModifyUserInfo] setDelegate:delegate setID:1 setParams:dic setFiles:nil];
    
    
    
}

-(void)deleateFriend:(NSString *)friends
       WithMyAccount:(NSString *)account
        withDelegate:(id <ASIHTTPRequestDelegate>)delegate
{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:account,@"account",friends,@"friend",nil];
    [HttpConnectLoader loadInBackgroundWithUrl:[ServerUrl stringByAppendingString:DeleteFriendAction] setDelegate:delegate setID:1 setParams:dic setFiles:nil];
    
    
    
    
}

-(void)registerAccount:(NSString *)account
          withPassWord:(NSString *)password withName:(NSString *)name
              withIcon:(NSString *)icon
          withDelegate:(id <ASIHTTPRequestDelegate>)delegate
{
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:account,@"account",password,@"password",name,@"name",icon,@"icon",nil];
    [HttpConnectLoader loadInBackgroundWithUrl:[ServerUrl stringByAppendingString:UserRegister] setDelegate:delegate setID:1 setParams:dic setFiles:nil];
    
    
}


@end
