//
//  XMPPUserObject.m
//  woaibaobao
//
//  Created by 梁建 on 14/11/3.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import "XMPPUserObject.h"
#import "XMPPUtils.h"
@implementation XMPPUserObject

+(BOOL)saveNewUser:(XMPPUserObject*)aUser
{
    NSString* myUserId = [[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_ID];
    FMDatabase* db = [[XMPPUtils sharedInstance] openUserDb:myUserId];
    [XMPPUserObject checkTableCreatedInDb:db userId:myUserId];
    
    aUser.roomFlag= [NSNumber numberWithInt:0];
    aUser.timeCreate = [NSDate date];
    NSString *insertStr=[NSString stringWithFormat:@"INSERT INTO 'friend' ('userId','userNickname','userDescription','userHead','roomFlag','timeCreate','newMsgs') VALUES (?,?,?,?,?,?,0)"];
    BOOL worked = [db executeUpdate:insertStr,aUser.userId,aUser.userNickname,aUser.userDescription,[XMPPUserObject getHeadImage:aUser.userId],aUser.roomFlag,aUser.timeCreate];
    //    FMDBQuickCheck(worked);
    
    return worked;
}


+(BOOL)saveNewRoom:(XMPPUserObject*)aUser
{
    NSString* myUserId = [[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_ID];
    FMDatabase* db = [[XMPPUtils sharedInstance] openUserDb:myUserId];
    [XMPPUserObject checkTableCreatedInDb:db userId:myUserId];
    
    aUser.roomFlag= [NSNumber numberWithInt:1];
    aUser.timeCreate = [NSDate date];
    NSString *insertStr=[NSString stringWithFormat:@"INSERT INTO 'friend' ('userId','userNickname','userDescription','userHead','roomFlag','timeCreate','newMsgs') VALUES (?,?,?,?,?,?,0)"];
    BOOL worked = [db executeUpdate:insertStr,aUser.userId,aUser.userNickname,aUser.userDescription,[XMPPUserObject getHeadImage:aUser.userId],aUser.roomFlag,aUser.timeCreate];
    //    FMDBQuickCheck(worked);
    
    return worked;
}


+(XMPPUserObject *)getUserById:(NSString*)userId
{
    NSString* myUserId = [[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_ID];
    FMDatabase* db = [[XMPPUtils sharedInstance] openUserDb:myUserId];
    
    FMResultSet *rs=[db executeQuery:[NSString stringWithFormat:@"select * from friend where userId=?"],userId];
    if ([rs next]) {
        XMPPUserObject *user=[[XMPPUserObject alloc]init];
        user.userId=[rs stringForColumn:kUSER_ID];
        user.userNickname=[rs stringForColumn:kUSER_NICKNAME];
        user.userHead=[rs stringForColumn:kUSER_USERHEAD];
        user.userDescription=[rs stringForColumn:kUSER_DESCRIPTION];
        user.roomFlag=[rs objectForColumnName:kUSER_ROOM_FLAG];
        user.timeCreate=[rs dateForColumn:kUSER_TIME_CREATE];
        user.NewsMsgs=[rs objectForColumnName:kUSER_NEW_MSGS];
        [rs close];
        return user;
    };
    return nil;
}



+(BOOL)haveSaveUserById:(NSString*)userId
{
    NSString* myUserId = [[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_ID];
    FMDatabase* db = [[XMPPUtils sharedInstance] openUserDb:myUserId];
    [XMPPUserObject checkTableCreatedInDb:db userId:myUserId];
    
    FMResultSet *rs=[db executeQuery:[NSString stringWithFormat:@"select count(*) from friend where userId=?"],userId];
    while ([rs next]) {
        int count= [rs intForColumnIndex:0];
        
        if (count!=0){
            [rs close];
            return YES;
        }else
        {
            [rs close];
            return NO;
        }
        
    };
    [rs close];
    return YES;
}

+(BOOL)deleteUserById:(NSString*)userId
{
    return NO;
    
}

+(BOOL)updateUser:(XMPPUserObject*)newUser
{
        NSString* myUserId = [[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_ID];
        FMDatabase* db = [[XMPPUtils sharedInstance] openUserDb:myUserId];
        [XMPPUserObject checkTableCreatedInDb:db userId:myUserId];
    
        BOOL worked=[db executeUpdate:[NSString stringWithFormat:@"update friend set roomFlag=1 where userId=?"],newUser.userId];
        return worked;
}

+(NSMutableArray*)fetchAllFriendsFromLocal
{
    NSMutableArray *resultArr=[[NSMutableArray alloc]init];
    
    NSString* myUserId = [[NSUserDefaults standardUserDefaults] objectForKey:kMY_USER_ID];
    FMDatabase* db = [[XMPPUtils sharedInstance] openUserDb:myUserId];
    [XMPPUserObject checkTableCreatedInDb:db userId:myUserId];
    
    FMResultSet *rs=[db executeQuery:[NSString stringWithFormat:@"select * from friend order by timeCreate desc"]];
    while ([rs next]) {
       XMPPUserObject *user=[[XMPPUserObject alloc] init];
        user.userId=[rs stringForColumn:kUSER_ID];
        user.userNickname=[rs stringForColumn:kUSER_NICKNAME];
        user.userHead=[rs stringForColumn:kUSER_USERHEAD];
        user.userDescription=[rs stringForColumn:kUSER_DESCRIPTION];
        user.roomFlag=[rs objectForColumnName:kUSER_ROOM_FLAG];
        user.NewsMsgs=[rs objectForColumnName:kUSER_NEW_MSGS];
        user.timeCreate=[rs dateForColumn:kUSER_TIME_CREATE];
        [resultArr addObject:user];
    }
    [rs close];
    return resultArr;
}

+(NSMutableArray*)fetchAllRoomsFromLocal
{
    NSMutableArray *resultArr=[[NSMutableArray alloc]init];
    
    NSString* myUserId = [[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_ID];
    FMDatabase* db = [[XMPPUtils sharedInstance] openUserDb:myUserId];
    [XMPPUserObject checkTableCreatedInDb:db userId:myUserId];
    
    FMResultSet *rs=[db executeQuery:[NSString stringWithFormat:@"select * from friend where roomFlag=1 order by timeCreate desc"]];
    while ([rs next]) {
        XMPPUserObject *user=[[XMPPUserObject alloc]init];
        user.userId=[rs stringForColumn:kUSER_ID];
        user.userNickname=[rs stringForColumn:kUSER_NICKNAME];
        user.userHead=[rs stringForColumn:kUSER_USERHEAD];
        user.userDescription=[rs stringForColumn:kUSER_DESCRIPTION];
        user.roomFlag=[rs objectForColumnName:kUSER_ROOM_FLAG];
        user.NewsMsgs=[rs objectForColumnName:kUSER_NEW_MSGS];
        user.timeCreate=[rs dateForColumn:kUSER_TIME_CREATE];
        [resultArr addObject:user];
    }
    [rs close];
    return resultArr;
}


+(XMPPUserObject*)userFromDictionary:(NSDictionary*)aDic
{
    XMPPUserObject *user=[[XMPPUserObject alloc]init];
    //    [user setUserId:[[aDic objectForKey:kUSER_ID]stringValue]];
    [user setUserId:[aDic objectForKey:kUSER_ID]];
    [user setUserHead:[aDic objectForKey:kUSER_USERHEAD]];
    [user setUserDescription:[aDic objectForKey:kUSER_DESCRIPTION]];
    [user setUserNickname:[aDic objectForKey:kUSER_NICKNAME]];
    user.NewsMsgs = [aDic objectForKey:kUSER_NEW_MSGS];
    user.timeCreate = [aDic objectForKey:kUSER_TIME_CREATE];
    user.roomFlag = [aDic objectForKey:kUSER_ROOM_FLAG];
    return user;
}

-(NSDictionary*)toDictionary
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:_userId,kUSER_ID,_userNickname,kUSER_NICKNAME,_userDescription,kUSER_DESCRIPTION,_userHead,kUSER_USERHEAD,_roomFlag,kUSER_ROOM_FLAG,_NewsMsgs,kUSER_NEW_MSGS,nil];
    return dic;
}

+(BOOL)checkTableCreatedInDb:(FMDatabase *)db userId:(NSString*)userId
{
    NSString *createStr=[NSString stringWithFormat:@"CREATE  TABLE  IF NOT EXISTS 'friend' ('userId' VARCHAR PRIMARY KEY  NOT NULL  UNIQUE , 'userNickname' VARCHAR, 'userDescription' VARCHAR, 'userHead' VARCHAR,'roomFlag' INT, 'content' VARCHAR,'type' INTEGER,'timeSend' DATETIME,'timeCreate' DATETIME,'newMsgs' INTEGER)"];
    
    BOOL worked = [db executeUpdate:createStr];
    //    FMDBQuickCheck(worked);
    return worked;
}



+(NSString*)getHeadImage:(NSString*)userId{
    int n = [userId length];
    if(n>0){
        const char* s=[userId cString];
        for(int i=0;i<strlen(s);i++)
            n += s[i];
        n = fmod(n, 18);
    }
    userId =  [NSString stringWithFormat:@"head_temp%d.jpg",n];
    return userId;
    
    /*
     
     NSString* path = [[g_App imageFilePath] stringByAppendingPathComponent:s];
     if([s length]<=0 || ![[NSFileManager defaultManager] fileExistsAtPath:path]){
     srandom(time(0));
     int n = fmod(random(),18);
     s =  [NSString stringWithFormat:@"head_temp%d.jpg",n];
     }
     return s;*/
}




@end
