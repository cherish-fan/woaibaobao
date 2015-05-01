//
//  GroupInfoVC.m
//  woaibaobao
//
//  Created by 梁建 on 14/10/26.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import "GroupInfoVC.h"
#import "XMPPUtils.h"
#import "GroupInfoVC.h"
#import "GroupMembers.h"
#import "InviteGroupContacts.h"
@interface GroupInfoVC ()

@property (nonatomic,strong) XMPPRoom *room;
@property (nonatomic,strong) NSMutableArray *membersArray;
@property (nonatomic) BOOL isSelectMember;



@end

@implementation GroupInfoVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
       
        
        
        
    }
    return self;
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    _membersArray = [NSMutableArray array];
    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *dequeue=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:dequeue];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dequeue];
    }
    
    if (indexPath.row==0)
    {
        cell.textLabel.text=@"群组成员";
    }
    if (indexPath.row==1)
    {
        cell.textLabel.text=@"邀请加入";
    }
    
    return cell;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (indexPath.row==0)
    {
        GroupMembers *vc=[[GroupMembers alloc]init];
        vc.roomJID=_roomJID;
        _isSelectMember=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }


    if (indexPath.row==1) {
        InviteGroupContacts *vc=[[InviteGroupContacts alloc]init];
        vc.roomJID = _roomJID;
        vc.joinedFriends = [_membersArray copy];
        [self.navigationController pushViewController:vc animated:YES];
    
    
    
    
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




#pragma mark - XMPP Room

- (void)fetchMembers
{
    if([[XMPPUtils sharedInstance]isExistRoom:_roomJID]){
        _room = [[XMPPUtils sharedInstance]getExistRoom:_roomJID];
        [_room addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [_room joinRoomUsingNickname:[XMPPUtils sharedInstance].xmppStream.myJID.user history:nil];
        [_room fetchModeratorsList];
        [_room fetchMembersList];
    }
    else{
        XMPPRoomCoreDataStorage *sharedRoomCoreDateStorage = [XMPPRoomCoreDataStorage sharedInstance];
        _room = [[XMPPRoom alloc]initWithRoomStorage:sharedRoomCoreDateStorage jid:_roomJID dispatchQueue:dispatch_get_main_queue()];
        [_room activate:[XMPPUtils sharedInstance].xmppStream];
        [_room addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [_room joinRoomUsingNickname:[XMPPUtils sharedInstance].xmppStream.myJID.user history:nil];
    }
    
    
}

#pragma mark XMPPRoomDelegate

- (void)xmppRoomDidJoin:(XMPPRoom *)sender
{
    NSLog(@"xmppRoomDidJoin");
    
    [[XMPPUtils sharedInstance] addRoom:_room];
    
    [_room fetchModeratorsList];
    [_room fetchMembersList];
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchModeratorsList:(NSArray *)items
{
    NSLog(@"didFetchModeratorsList");
    
    if([items count] > 0){
        for(NSXMLElement *element in items){
            [_membersArray addObject:element];
        }
    }
    
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchMembersList:(NSArray *)items
{
    NSLog(@"didFetchMembersList");
    
    if([items count] > 0){
        for(NSXMLElement *element in items){
            [_membersArray addObject:element];
        }
    }
    if (!_isSelectMember)
    {
        
#warning 切换试图控制器
        
        //[self performSegueWithIdentifier:@"GroupInfo2InviteGroupContact" sender:self];
    }
    
}












@end
