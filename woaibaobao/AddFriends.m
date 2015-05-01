//
//  AddFriends.m
//  woaibaobao
//
//  Created by 梁建 on 14/10/24.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import "AddFriends.h"
#import "XMPPUtils.h"
@interface AddFriends ()

@end

@implementation AddFriends

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addFriend:(id)sender
{
    NSString *userName = [_userName text];
    
    XMPPUtils *sharedXMPP = [XMPPUtils sharedInstance];
    [sharedXMPP addFriend:userName];
    
    
    
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}








@end
