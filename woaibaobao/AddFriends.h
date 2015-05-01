//
//  AddFriends.h
//  woaibaobao
//
//  Created by 梁建 on 14/10/24.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFriends : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userName;

- (IBAction)addFriend:(id)sender;
@end
