//
//  ChatViewCell.h
//  woaibaobao
//
//  Created by 梁建 on 14/10/18.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacialLable.h"
@interface ChatViewCell : UITableViewCell


@property(strong,nonatomic)  UIImageView *imgAvatar;
@property (strong, nonatomic)  UIImageView *imgBg;
@property (strong, nonatomic)  FacialLable *txtMessage;
@property (nonatomic)  BOOL isOutgoing;








@end
