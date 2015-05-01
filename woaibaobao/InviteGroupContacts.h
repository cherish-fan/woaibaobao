//
//  InviteGroupContacts.h
//  woaibaobao
//
//  Created by 梁建 on 14/10/26.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteGroupContacts : UITableViewController
@property (nonatomic,strong) XMPPJID *roomJID;
@property (nonatomic,strong) NSArray *joinedFriends;
@end
