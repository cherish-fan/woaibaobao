//
//  MsgAndUserObject.m
//  woaibaobao
//
//  Created by 梁建 on 14/11/3.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import "MsgAndUserObject.h"
#import "XMPPMessageObject.h"
@implementation MsgAndUserObject
+(MsgAndUserObject *)unionWithMessage:(XMPPMessageObject *)aMessage andUser:(XMPPUserObject *)aUser
{
    
    MsgAndUserObject *unionObject=[[MsgAndUserObject alloc]init];
    
    [unionObject setUser:aUser];
    [unionObject setMessage:aMessage];
    
    return unionObject;
    
    
    
    
    
    
}

-(void)dealloc
{
    
    
    
}


@end
