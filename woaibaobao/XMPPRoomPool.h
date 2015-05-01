//
//  XMPPRoomPool.h
//  woaibaobao
//
//  Created by 梁建 on 14/11/4.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XMPPRoomObject;
@class XMPPRoomCoreDataStorage;
@interface XMPPRoomPool : NSObject
{
    NSMutableDictionary *_pool;
    XMPPRoomCoreDataStorage *_storage;
    
    
}

-(XMPPRoomObject *)createRoom:(NSString*)name title:(NSString*)title;
-(XMPPRoomObject *)joinRoom:(NSString*)name title:(NSString*)title;
-(void)deleteAll;
-(void)createAll;
-(void)connectAll;


@end
