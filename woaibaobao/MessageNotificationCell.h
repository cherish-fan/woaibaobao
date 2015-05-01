//
//  MessageNotificationCell.h
//  woaibaobao
//
//  Created by 梁建 on 14/10/26.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageNotificationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *requestMessage;
@property (weak, nonatomic) IBOutlet UILabel *requestRequest;
@property (weak, nonatomic) IBOutlet UIButton *agerrBtn;
@property (weak, nonatomic) IBOutlet UIButton *blockBtn;

@end
