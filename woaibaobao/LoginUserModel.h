//
//  LoginUserModel.h
//  woaibaobao
//
//  Created by 梁建 on 14/10/17.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface LoginUserModel : NSObject
single_interface(LoginUserModel)
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *hostName;

@property (strong, nonatomic, readonly) NSString *myJIDName;
















@end
