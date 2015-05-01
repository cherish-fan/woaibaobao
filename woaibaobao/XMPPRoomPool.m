//
//  XMPPRoomPool.m
//  woaibaobao
//
//  Created by 梁建 on 14/11/4.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import "XMPPRoomPool.h"
#import "XMPPRoomObject.h"
#import "XMPPUserObject.h"
@implementation XMPPRoomPool

-(XMPPRoomObject *)createRoom:(NSString*)name title:(NSString*)title
{
    XMPPRoomObject *room=[[XMPPRoomObject alloc]init];
    return room;
    
}
-(XMPPRoomObject *)joinRoom:(NSString*)name title:(NSString*)title
{
    if([_pool objectForKey:name])
        return [_pool objectForKey:name];
    XMPPRoomObject* room = [[XMPPRoomObject alloc] init];
    room.roomName = name;
    room.roomTitle = title;
    room.storage   = _storage;
    room.nickName  = [[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_NICKNAME];
    [room joinRoom];
    [_pool setObject:room forKey:room.roomName];
    return room;
}
-(void)deleteAll
{
    for(int i=[_pool count]-1;i>=0;i--)
        [_pool.allValues objectAtIndex:i];
    [_pool removeAllObjects];
  
}
-(void)createAll
{
    NSMutableArray* array = [XMPPUserObject fetchAllRoomsFromLocal];
    for(int i=0;i<[array count];i++){
        XMPPUserObject *room = [array objectAtIndex:i];
        [self joinRoom:room.userId title:room.userNickname];
    }
}
-(void)connectAll
{
    
}






@end
