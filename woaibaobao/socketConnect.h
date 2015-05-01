//
//  socketConnect.h
//  woaibaobao
//
//  Created by 梁建 on 14/10/22.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "DDXML.h"
#import "NSString+DDXML.h"
@interface socketConnect : NSObject<GCDAsyncSocketDelegate>
{
    
    GCDAsyncSocket *_socket;
    BOOL _ConnectStatus;
    
    
    
    
    
}
-(socketConnect *)sharedInstacnce;
-(void)connectToHostWithDelegate:(id <GCDAsyncSocketDelegate>)delegate toHostName:(NSString *)hostName toHostPort:(NSString *)hostPort;
@end
