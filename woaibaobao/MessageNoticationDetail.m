//
//  MessageNoticationDetail.m
//  woaibaobao
//
//  Created by 梁建 on 14/10/26.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import "MessageNoticationDetail.h"
#import "MessageNotification.h"
#import "MessageNotificationCell.h"
#import "XMPPUtils.h"

@interface MessageNoticationDetail ()
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) XMPPRoom *room;



@end

@implementation MessageNoticationDetail

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}






- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setup];

}

-(void)setup
{
    _dataArray = [NSMutableArray array];
    
    NSString *myString = [[XMPPUtils sharedInstance].xmppStream.myJID user];
    NSString *defaultName;
    if (_isGroupRequest)
    {
        defaultName = [NSString stringWithFormat:@"%@_groupInvite",myString];
        
    }
    else
    {
        defaultName = [NSString stringWithFormat:@"%@_requestRoster",myString];
    }
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:defaultName]) {
        
        _dataArray = [[[NSUserDefaults standardUserDefaults] objectForKey:defaultName] mutableCopy];
    }
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
     return [_dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Message Notification Detail";
    MessageNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MessageNotificationCell" owner:self options:nil]lastObject];
    }
    [cell.agerrBtn addTarget:self action:@selector(agree:) forControlEvents:UIControlEventTouchUpInside];
    [cell.blockBtn addTarget:self action:@selector(block:) forControlEvents:UIControlEventTouchUpInside];
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    if(_isGroupRequest){
        if (dict[@"result"]) {
            cell.agerrBtn.hidden = YES;
            cell.blockBtn.hidden = YES;
            cell.requestRequest.hidden = NO;
            cell.requestRequest.text = [NSString stringWithFormat:@"已%@",dict[@"result"]];
        }
        else{
            cell.requestRequest.hidden = YES;
        }
        NSString *fromString = dict[@"from"];
        NSString *fromUser = [[XMPPJID jidWithString:fromString]user];
        
        NSString *roomName = dict[@"room"];
        NSString *reason = dict[@"reason"];
        
        cell.requestMessage.text = [NSString stringWithFormat:@"%@邀请您加入%@群:%@",fromUser,roomName,reason];
    }
    else{
        if (dict[@"result"]) {
            cell.agerrBtn.hidden = YES;
            cell.blockBtn.hidden = YES;
            cell.requestRequest.hidden = NO;
            cell.requestRequest.text = [NSString stringWithFormat:@"已%@",dict[@"result"]];
        }
        else{
            cell.requestRequest.hidden = YES;
        }
        NSString *fromString = dict[@"from"];
        NSString *fromUser = [[XMPPJID jidWithString:fromString]user];
        cell.requestMessage.text = [NSString stringWithFormat:@"%@请求加您为好友",fromUser];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 70.0;
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

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - XMPPRoomDelegate

- (void)xmppRoomDidJoin:(XMPPRoom *)sender
{
    NSLog(@"xmppRoomDidJoin");
    
    [[XMPPUtils sharedInstance] addRoom:_room];
}

-(void)agree:(id)sender
{
    // Group Invite
    if (_isGroupRequest) {
        UIButton *button = (UIButton *)sender;
        CGRect buttonFrame = [button convertRect:button.bounds toView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonFrame.origin];
        NSMutableDictionary *dict = [[_dataArray objectAtIndex:indexPath.row] mutableCopy];
        XMPPJID *roomJID = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",dict[@"room"],XMPP_MUC_SERVICE]];
        if ([[XMPPUtils sharedInstance]isExistRoom:roomJID]) {
            XMPPRoom *room = [[XMPPUtils sharedInstance]getExistRoom:roomJID];
            [room joinRoomUsingNickname:[XMPPUtils sharedInstance].xmppStream.myJID.user history:nil];
        }
        else{
            XMPPRoomCoreDataStorage *sharedRoomCoreDateStorage = [XMPPRoomCoreDataStorage sharedInstance];
            _room = [[XMPPRoom alloc]initWithRoomStorage:sharedRoomCoreDateStorage jid:roomJID dispatchQueue:dispatch_get_main_queue()];
            [_room activate:[XMPPUtils sharedInstance].xmppStream];
            [_room addDelegate:self delegateQueue:dispatch_get_main_queue()];
            [_room joinRoomUsingNickname:[XMPPUtils sharedInstance].xmppStream.myJID.user history:nil];
        }
        
        
        [dict setObject:@"接受" forKey:@"result"];
        [_dataArray setObject:dict atIndexedSubscript:indexPath.row];
        
        NSString *myString = [[XMPPUtils sharedInstance].xmppStream.myJID user];
        NSString *defaultName = [NSString stringWithFormat:@"%@_groupInvite",myString];
        [[NSUserDefaults standardUserDefaults] setObject:_dataArray forKey:defaultName];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    // Request Roster
    else{
        XMPPRoster *sharedRoster = [XMPPUtils sharedInstance].xmppRoster;
        UIButton *button = (UIButton *)sender;
        CGRect buttonFrame = [button convertRect:button.bounds toView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonFrame.origin];
        
        NSMutableDictionary *dict = [[_dataArray objectAtIndex:indexPath.row] mutableCopy];
        XMPPJID *fromJID = [XMPPJID jidWithString:dict[@"from"]];
        
        [sharedRoster acceptPresenceSubscriptionRequestFrom:fromJID andAddToRoster:YES];
        
        [dict setObject:@"同意" forKey:@"result"];
        [_dataArray setObject:dict atIndexedSubscript:indexPath.row];
        
        NSString *myString = [[XMPPUtils sharedInstance].xmppStream.myJID user];
        NSString *requestRosterDefault = [NSString stringWithFormat:@"%@_requestRoster",myString];
        [[NSUserDefaults standardUserDefaults] setObject:_dataArray forKey:requestRosterDefault];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    
    [self.tableView reloadData];
 
    
    
    
    
    
}

-(void)block:(id)sender
{
    // Group invite
    if (_isGroupRequest) {
        UIButton *button = (UIButton *)sender;
        CGRect buttonFrame = [button convertRect:button.bounds toView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonFrame.origin];
        NSMutableDictionary *dict = [[_dataArray objectAtIndex:indexPath.row] mutableCopy];
        [dict setObject:@"拒绝" forKey:@"result"];
        [_dataArray setObject:dict atIndexedSubscript:indexPath.row];
        
        NSString *myString = [[XMPPUtils sharedInstance].xmppStream.myJID user];
        NSString *defaultName = [NSString stringWithFormat:@"%@_groupInvite",myString];
        [[NSUserDefaults standardUserDefaults] setObject:_dataArray forKey:defaultName];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    // Request Roster
    else{
        XMPPRoster *sharedRoster = [XMPPUtils sharedInstance].xmppRoster;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSMutableDictionary *dict = [[_dataArray objectAtIndex:indexPath.row] mutableCopy];
        XMPPJID *fromJID = [XMPPJID jidWithString:dict[@"from"]];
        
        [sharedRoster rejectPresenceSubscriptionRequestFrom:fromJID];
        
        [dict setObject:@"拒绝" forKey:@"result"];
        [_dataArray setObject:dict atIndexedSubscript:indexPath.row];
        
        NSString *myString = [[XMPPUtils sharedInstance].xmppStream.myJID user];
        NSString *requestRosterDefault = [NSString stringWithFormat:@"%@_requestRoster",myString];
        [[NSUserDefaults standardUserDefaults] setObject:_dataArray forKey:requestRosterDefault];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    
    
    [self.tableView reloadData];
 
    
    
    
}


@end
