//
//  vCard.h
//  woaibaobao
//
//  Created by 梁建 on 14/10/25.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface vCard : NSObject

@property (nonatomic,strong) NSData *avatarData;
@property (nonatomic,strong) NSString *sex;
@property (nonatomic,strong) NSString *location;
@property (nonatomic,strong) NSString *introduce;

+ (vCard *)vCardWithAvatar:(NSData *)avatarData andSex:(NSString *)sex andLocation:(NSString *)location andIntroduce:(NSString *)introduce;




@end
