//
//  LoginUserModel.m
//  woaibaobao
//
//  Created by 梁建 on 14/10/17.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import "LoginUserModel.h"
#import "NSString+Helper.h"
#define kXMPPUserNameKey    @"xmppUserName"
#define kXMPPPasswordKey    @"xmppPassword"
#define kXMPPHostNameKey    @"xmppHostName"




@implementation LoginUserModel
single_implementation(LoginUserModel)
#pragma mark - getter & setter
#pragma mark - 私有方法
- (NSString *)loadStringFromDefaultsWithKey:(NSString *)key
{
    NSString *str = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    
    return (str) ? str : @"";
}









- (NSString *)userName
{
    return [self loadStringFromDefaultsWithKey:kXMPPUserNameKey];
}

- (void)setUserName:(NSString *)userName
{
    [userName saveToNSDefaultsWithKey:kXMPPUserNameKey];
}

- (NSString *)password
{
    return [self loadStringFromDefaultsWithKey:kXMPPPasswordKey];
}

- (void)setPassword:(NSString *)password
{
    [password saveToNSDefaultsWithKey:kXMPPPasswordKey];
}

- (NSString *)hostName
{
    return [self loadStringFromDefaultsWithKey:kXMPPHostNameKey];
}

- (void)setHostName:(NSString *)hostName
{
    [hostName saveToNSDefaultsWithKey:kXMPPHostNameKey];
}

- (NSString *)myJIDName
{
    return [NSString stringWithFormat:@"%@@%@", self.userName, self.hostName];
}















@end
