//
//  MessageListCell.h
//  woaibaobao
//
//  Created by 梁建 on 14/10/23.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *avatar;

@property (strong, nonatomic) IBOutlet UILabel *chatWithName;


@property (strong, nonatomic) IBOutlet UILabel *chatDate;


@property (strong, nonatomic) IBOutlet UILabel *chatMessage;


@end
