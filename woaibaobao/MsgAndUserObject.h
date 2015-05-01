//
//  MsgAndUserObject.h
//  woaibaobao
//
//  Created by 梁建 on 14/11/3.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XMPPMessageObject;
@class XMPPUserObject;
@interface MsgAndUserObject : NSObject

@property(nonatomic,retain)XMPPMessageObject *message;
@property(nonatomic,retain)XMPPUserObject *user;

+(MsgAndUserObject *)unionWithMessage:(XMPPMessageObject *)aMessage andUser:(XMPPUserObject *)aUser;


@end
