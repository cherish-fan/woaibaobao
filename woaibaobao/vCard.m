//
//  vCard.m
//  woaibaobao
//
//  Created by 梁建 on 14/10/25.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import "vCard.h"

@implementation vCard
+ (vCard *)vCardWithAvatar:(NSData *)avatarData andSex:(NSString *)sex andLocation:(NSString *)location andIntroduce:(NSString *)introduce
{
    vCard *card = [[vCard alloc]init];
    card.avatarData = avatarData;
    card.sex = sex;
    card.location = location;
    card.introduce = introduce;
    return card;
}



@end
