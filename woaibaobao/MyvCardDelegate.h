//
//  MyvCardDelegate.h
//  woaibaobao
//
//  Created by 梁建 on 14/10/26.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MyvCardDelegate <NSObject>
@optional

- (void)didSelectMan:(BOOL)isMan;
- (void)didEditIntroduce:(NSString *)introduce;
@end
