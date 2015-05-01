//
//  socketConnect.m
//  woaibaobao
//
//  Created by 梁建 on 14/10/22.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import "socketConnect.h"

@implementation socketConnect


-(socketConnect *)sharedInstacnce
{
    
    static socketConnect *sharedSockerConnect = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,
                  ^{
        sharedSockerConnect = [[socketConnect alloc]init];
    });
    return sharedSockerConnect;
    
    
    
    
    
}

-(void)connectToHostWithDelegate:(id<GCDAsyncSocketDelegate>)delegate toHostName:(NSString *)hostName toHostPort:(NSString *)hostPort
{
    
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:delegate delegateQueue:dispatch_get_main_queue()];
    
    if (!_ConnectStatus)
    {
        NSError *err = nil;
        if (![_socket connectToHost:hostName onPort:hostPort.intValue error:&err]) // Asynchronous!
        {
            //该方法异步，返回错误是因为 delegate没设置等
            NSLog(@"I goofed: %@", err);
        }
    }else{
        [_socket disconnect];
    }
 
    
    
    
    
    
    
    
}

- (NSString*)makeLoginXMLWithAccount:(NSString*)account andPwd:(NSString*)password
{
    DDXMLElement *elementSent = [[DDXMLElement alloc] initWithName: @"sent"];
    //[elementSent setValue:@"" forKey:@""];
    
    // key 域
    DDXMLElement *elementKey = [[DDXMLElement alloc] initWithName: @"key"];
    [elementKey setStringValue:@"client_auth"];
    [elementSent addChild:elementKey];
    
    // timestamp 域
    
    DDXMLElement*elementTimestamp = [[DDXMLElement alloc] initWithName: @"timestamp"];
    [elementTimestamp setStringValue:[NSString stringWithFormat:@"%.0f",[[NSDate date]timeIntervalSince1970]]];
    [elementSent addChild:elementTimestamp];
    
    // data 域
    DDXMLElement*elementData = [[DDXMLElement alloc] initWithName: @"data"];
    DDXMLElement*elementDataAccount = [[DDXMLElement alloc] initWithName: @"account"];
    [elementDataAccount setStringValue:account];
    DDXMLElement*elementDataChannel = [[DDXMLElement alloc] initWithName: @"channel"];
    [elementDataChannel setStringValue:@"ios"];
    DDXMLElement*elementDataPwd = [[DDXMLElement alloc] initWithName: @"password"];
    [elementDataPwd setStringValue:password];
    
    [elementData addChild:elementDataAccount];
    [elementData addChild:elementDataChannel];
    [elementData addChild:elementDataPwd];
    
    [elementSent addChild:elementData];
    
    NSString* xmlString = [@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>" stringByAppendingString:[elementSent XMLString]];
    xmlString = [xmlString stringByAppendingString:@"\b"];
    
    NSLog(@"xml:\n %@",xmlString);
    return xmlString;
    
    
    //    <?xml version="1.0" encoding="UTF-8"?>
    //    <sent>
    //       <key>client_auth</key>
    //       <timestamp>1386403273483</timestamp>
    //       <data>
    //          <account>xiyang</account>
    //          <channel>android</channel>
    //          <password>q</password>
    //       </data>
    //    </sent>\b
    
}

-(void)writeDataToSocketWithUsername:(NSString *)username andPassword:(NSString *)password
{
    if ([_socket isConnected]) {
        NSString *xmlString = [self makeLoginXMLWithAccount:username andPwd:password];
        [_socket writeData:[xmlString dataUsingEncoding:NSUTF8StringEncoding] withTimeout:15 tag:10000];
        
    }else{
        
    
    
    }
    
}

-(NSString *)makeHeartbeatXml
{
    DDXMLElement *elementSent = [[DDXMLElement alloc] initWithName: @"sent"];
    //[elementSent setValue:@"" forKey:@""];
    
    // key 域
    DDXMLElement *elementKey = [[DDXMLElement alloc] initWithName: @"key"];
    [elementKey setStringValue:@"client_heartbeat"];
    [elementSent addChild:elementKey];
    
    NSString* xmlString = [@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>" stringByAppendingString:[elementSent XMLString]];
    xmlString = [xmlString stringByAppendingString:@"\b"];
    
    NSLog(@"xml:\n %@",xmlString);
    
    return xmlString;
}




-(void)sendHeartbeatXml
{
    
    [NSTimer scheduledTimerWithTimeInterval:3
                                     target:self
                                   selector:@selector(sendHeartbeat)
                                   userInfo:nil
                                    repeats:YES];
    
    
    
}

-(void)sendHeartbeat
{
    
    
    NSString *xmlString = [self makeHeartbeatXml];
    [_socket writeData:[xmlString dataUsingEncoding:NSUTF8StringEncoding] withTimeout:15 tag:200000];
    
    
    
    
    
    
    
    
    
    
    
}



#pragma mark - GCDAsyncSocketDelegate


- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"连接断开:%@",err);
    
    
}


- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"Connected: %@:%d", host, port);
    _ConnectStatus = YES;
    [_socket readDataWithTimeout:-1 tag:10000];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"socket reveivedMsg:%@",string);
    
    
    
    /*
     <?xml version="1.0" encoding="UTF-8"?>
     <reply>
     <key>client_auth</key>
     <timestamp>1413890302062</timestamp>
     <code>200</code>
     <data>
     <icon>UI_18660181668</icon>
     <name>高兴的爸爸</name>
     </data>
     </reply>
     */
   

//如果接收的别人发来的消息
    
/*
 <?xml version=\"1.0\" encoding=\"UTF-8\"?>
 <message>
 <mid>client_auth</key>
 <type>2</type>
 <title>ttt</title>
 <content>aaaa</content>
 <sender>system</sender>
 <receiver>10001</receiver>
 <timestamp>1343243455553</timestamp>
 </message>\b
 
 
 
 
 */







}








@end
