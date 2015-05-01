//
//  MyAnnotation.m
//  woaibaobao
//
//  Created by 梁建 on 14/10/23.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

-(id)initWithCoordinate:(CLLocationCoordinate2D)c andTitle:(NSString *)t andSubtitle:(NSString *)subtitle
{
    self = [super init];
    if(self){
        _coordinate = c;
        _title = t;
        _subtitle = subtitle;
    }
    return self;
}


@end
