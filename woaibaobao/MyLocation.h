//
//  MyLocation.h
//  woaibaobao
//
//  Created by 梁建 on 14/10/23.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyLocationDelegate <NSObject>

-(void)sendLocationImage:(UIImage *)image andLongitude:(double)longitude andLatitude:(double)latitude;

@end


@interface MyLocation : UIViewController

@property (nonatomic,weak) id<MyLocationDelegate> delegate;


@end
