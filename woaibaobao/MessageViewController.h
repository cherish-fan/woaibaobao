//
//  MessageViewController.h
//  woaibaobao
//
//  Created by 梁建 on 14/10/15.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableView.h"
#import "ASIHTTPRequest.h"
#import "FriendOrChatData.h"



@interface MessageViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>
{
    UIImageView *_barView;
    BOOL isDown;
    UIButton *btn;
    UITableView *_listView;
    UIButton *addFriendButton;
}
@end
