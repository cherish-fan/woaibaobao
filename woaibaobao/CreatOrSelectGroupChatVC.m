//
//  CreatOrSelectGroupChatVC.m
//  woaibaobao
//
//  Created by 梁建 on 14/10/24.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import "CreatOrSelectGroupChatVC.h"
#import "createGroupChatCell.h"
#import "XMPPUtils.h"
#import "GroupChatUtils.h"
#import "MessageViewController.h"
#define USERNAME @"username"
#define AVATARDATA @"avatardata"

@interface CreatOrSelectGroupChatVC ()<xmppFriendsDelegate,UITextFieldDelegate,UIAlertViewDelegate,RoomDelegate>
{
    UIButton *okButton;
    UIButton *cancelButton;
    
    
    
}



@property (nonatomic,strong) NSMutableArray *friends;
@property (nonatomic,strong) XMPPUtils *sharedXMPPUtils;
@property (nonatomic) NSUInteger selectedFriendsCount;
@property (nonatomic,strong) NSMutableArray *selectFriendsJIDs;
@property (nonatomic,strong) GroupChatUtils *groupChatUtils;




@end

@implementation CreatOrSelectGroupChatVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        [self.navigationItem setHidesBackButton:YES];
        okButton =[UIButton buttonWithType:UIButtonTypeContactAdd];
        okButton.frame=CGRectMake(0, 5, 20, 20);
//        [okButton setBackgroundImage:[UIImage imageNamed:@"share_to_time_line_icon"] forState:UIControlStateNormal];
//        [okButton setBackgroundImage:[UIImage imageNamed:@"share_to_time_line_icon"] forState:UIControlStateSelected];
        [okButton addTarget:self action:@selector(OK)forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:okButton];
        self.navigationItem.rightBarButtonItem=back;
       
       
        
        cancelButton =[UIButton buttonWithType:UIButtonTypeSystem];
        cancelButton.frame=CGRectMake(0, 5, 20, 20);
//        [cancelButton setBackgroundImage:[UIImage imageNamed:@"icon_addfriend"] forState:UIControlStateNormal];
//        [cancelButton setBackgroundImage:[UIImage imageNamed:@"icon_addfriend"] forState:UIControlStateSelected];
        [cancelButton addTarget:self action:@selector(cancel)forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *back2=[[UIBarButtonItem alloc]initWithCustomView:cancelButton];
        self.navigationItem.leftBarButtonItem=back2;
  
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    return self;
}

-(void)OK
{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请输入群名" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"OK", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.delegate = self;
    [alertView show];

    
    
    
}

-(void)cancel
{
    
   [self dismissViewControllerAnimated:YES completion:nil]; 
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupFriendData];
    
    
    
    
    
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setupFriendData
{
    _friends = [NSMutableArray array];
    _sharedXMPPUtils = [XMPPUtils sharedInstance];
    _selectFriendsJIDs = [NSMutableArray array];
    _sharedXMPPUtils.friendsDelegate = self;
    [_sharedXMPPUtils queryRoster];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
   return [_friends count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *creatGruopChatCellIdentifier = @"Creat Group Chat";
    static NSString *selectGruopChatCellIdentifier = @"Select Group Chat";
    
    
    
    
    if (indexPath.row == 0) {
        
        UITableViewCell *cell2 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selectGruopChatCellIdentifier];
        cell2.textLabel.text = @"选择一个已经创建的群聊天";
        cell2.textLabel.font = [UIFont systemFontOfSize:16.0];
        cell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell2;
    }
    else{
        
        createGroupChatCell *cell = [tableView dequeueReusableCellWithIdentifier:creatGruopChatCellIdentifier];
       
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"createGroupChatCell" owner:self options:nil]lastObject];
        }
        
        cell.name.text = [[_friends objectAtIndex:indexPath.row - 1] objectForKey:USERNAME];
        NSData *data = [[_friends objectAtIndex:indexPath.row - 1] objectForKey:AVATARDATA];
        if (data) {
            cell.avatarImage.image = [UIImage imageWithData:data];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        return cell;
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.row == 0)
    {
        UITabBarController *tabBarController = (UITabBarController *)self.presentingViewController;
        UINavigationController *navigationController = tabBarController.viewControllers[0];
        MessageViewController *chatMain = (MessageViewController *)navigationController.topViewController;
        
#warning 在这里跳装到群组列表在这里还没实现
        
        
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    else{
        NSString *selectFriendName = [[_friends objectAtIndex:indexPath.row - 1] objectForKey:USERNAME];
        XMPPJID *selectedFriendJID = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",selectFriendName,XMPP_HOST_NAME]];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        (cell.accessoryType == UITableViewCellAccessoryNone) ?
        (cell.accessoryType = UITableViewCellAccessoryCheckmark) :
        (cell.accessoryType = UITableViewCellAccessoryNone);
        (cell.accessoryType == UITableViewCellAccessoryNone) ? (_selectedFriendsCount--) : (_selectedFriendsCount++);
        (cell.accessoryType == UITableViewCellAccessoryNone) ? ([_selectFriendsJIDs removeObject:selectedFriendJID]) : ([_selectFriendsJIDs addObject:selectedFriendJID]);
        
        self.navigationItem.rightBarButtonItem.enabled = (_selectedFriendsCount > 0) ? YES : NO ;
        self.navigationItem.rightBarButtonItem.title = (_selectedFriendsCount > 0) ? [NSString stringWithFormat:@"OK(%d)",_selectedFriendsCount] : @"OK";
        
    }

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"OK"]) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        NSString *groupName = textField.text;
        _groupChatUtils = [[GroupChatUtils alloc]init];
        _groupChatUtils.delegate = self;
        _groupChatUtils.selectedJIDs = [_selectFriendsJIDs copy];
        [_groupChatUtils createRoomWithName:groupName];
    }
    else
        return;
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    return [[alertView textFieldAtIndex:0].text length] > 0 ;
}

#pragma mark RoomDelegate

- (void) didInviteUserSuccess
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) existSameRoom
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark xmppFriendsDelegate methods

-(void)removeFriens
{
    if(_friends)
        [_friends removeAllObjects];
    
}

-(void)friendsList:(NSDictionary *)dict
{
    NSMutableDictionary *_friendDict = [NSMutableDictionary dictionaryWithCapacity:4];
    [_friendDict setObject:dict[@"name"] forKey:USERNAME];
    if ([dict objectForKey:@"avatar"]) {
        [_friendDict setObject:dict[@"avatar"] forKey:AVATARDATA];
    }
    [_friends addObject:_friendDict];
    [self.tableView reloadData];
}

















@end
