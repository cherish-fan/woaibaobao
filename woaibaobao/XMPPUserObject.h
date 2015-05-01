//
//  XMPPUserObject.h
//  woaibaobao
//
//  Created by 梁建 on 14/11/3.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kUSER_ID           @"userId"
#define kUSER_NICKNAME     @"userNickname"
#define kUSER_DESCRIPTION  @"userDescription"
#define kUSER_USERHEAD     @"userHead"
#define kUSER_ROOM_FLAG    @"roomFlag"
#define kUSER_NEW_MSGS     @"newMsgs"
#define kUSER_TIME_CREATE  @"timeCreate"
@interface XMPPUserObject : NSObject
@property (nonatomic,retain) NSString* userId;
@property (nonatomic,retain) NSString* userNickname;
@property (nonatomic,retain) NSString* userDescription;
@property (nonatomic,retain) NSString* userHead;
@property (nonatomic,retain) NSDate* timeCreate;
@property (nonatomic,strong) NSNumber *roomFlag;//0：朋友；1:永久房间；2:临时房间
@property (nonatomic,strong) NSNumber *NewsMsgs;//0：朋友；1:永久房间；2:临时房间
//数据库增删改查
+(BOOL)saveNewUser:(XMPPUserObject*)aUser;
+(BOOL)saveNewRoom:(XMPPUserObject*)aUser;

+(BOOL)deleteUserById:(NSString*)userId;
+(BOOL)updateUser:(XMPPUserObject*)newUser;
+(BOOL)haveSaveUserById:(NSString*)userId;
+(XMPPUserObject*)getUserById:(NSString*)userId;

+(NSMutableArray*)fetchAllFriendsFromLocal;
+(NSMutableArray*)fetchAllRoomsFromLocal;

//将对象转换为字典
-(NSDictionary*)toDictionary;
+(XMPPUserObject*)userFromDictionary:(NSDictionary*)aDic;
+(NSString*)getHeadImage:(NSString*)s;





@end
