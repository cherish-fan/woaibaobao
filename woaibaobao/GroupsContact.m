//
//  GroupsContact.m
//  woaibaobao
//
//  Created by 梁建 on 14/10/24.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import "GroupsContact.h"
#import "GroupsChatVC.h"
@interface GroupsContact ()

@end

@implementation GroupsContact

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
    
    [self setupGroupsContact];
    
    self.title = @"群组";
}

- (void)setupGroupsContact
{
    _roomJIDs = [self fetchRoomJIDsFromCoreData];
    NSLog(@"%@",_roomJIDs );
        
}

#pragma mark - Fetch Rooms From CoreData

- (NSArray *)fetchRoomJIDsFromCoreData
{
    NSManagedObjectContext *context = [[XMPPRoomCoreDataStorage sharedInstance] mainThreadManagedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPRoomOccupantCoreDataStorageObject" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr == %@",[[XMPPUtils sharedInstance].xmppStream.myJID bare]];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *dataArray = [context executeFetchRequest:request error:&error];
    
    NSMutableOrderedSet *orderedSet = [[NSMutableOrderedSet alloc]init];
    for (XMPPRoomOccupantCoreDataStorageObject *roomMessage in dataArray) {
        [orderedSet addObject:roomMessage.roomJID];
    }
    
    return [orderedSet array];
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
     return [_roomJIDs count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Groups Contact Cell";
    
    MyFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyFriendCell" owner:self options:nil]lastObject];
    }
    
    cell.name.text = [(XMPPJID *)[_roomJIDs objectAtIndex:indexPath.row] user];
    
    return cell;
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
  
    
     XMPPJID *roomJID = [_roomJIDs objectAtIndex:indexPath.row];
    GroupsChatVC *groupchatvc=[[GroupsChatVC alloc]init];
    groupchatvc.roomJID=roomJID;
    [self.navigationController pushViewController:groupchatvc animated:YES];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
