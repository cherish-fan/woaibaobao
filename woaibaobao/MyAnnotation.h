//
//  MyAnnotation.h
//  woaibaobao
//
//  Created by 梁建 on 14/10/23.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface MyAnnotation : NSObject<MKAnnotation>
@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic,copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;


//初始化方法
-(id)initWithCoordinate:(CLLocationCoordinate2D)c andTitle:(NSString *)t andSubtitle:(NSString *)subtitle;
@end
