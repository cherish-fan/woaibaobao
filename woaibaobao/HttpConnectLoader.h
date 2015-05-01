//
//  HttpConnectLoader.h
//  woaibaobao
//
//  Created by 梁建 on 14/10/17.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
@interface HttpConnectLoader : NSObject

+ (void)loadInBackgroundWithUrl:(NSString *)url setDelegate:(id <ASIHTTPRequestDelegate>)delegate setID:(int)tag setParams:(NSDictionary *)paramsDic setFiles:(NSDictionary *)dic;







@end
