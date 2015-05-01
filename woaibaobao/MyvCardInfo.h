//
//  MyvCardInfo.h
//  woaibaobao
//
//  Created by 梁建 on 14/10/26.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyvCardDelegate.h"

@interface MyvCardInfo : UIViewController
@property (nonatomic,weak) id<MyvCardDelegate> delegate;
@property (nonatomic,strong) NSString *introduce;
@end
