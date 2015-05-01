//
//  FriendsMainVC.m
//  woaibaobao
//
//  Created by 梁建 on 14/10/24.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import "FriendsMainVC.h"
#import "XMPPUtils.h"
#import "ChatViewController.h"
#import "XMPPvCardTemp.h"
#import "MyFriendCell.h"
#import "QSUtils.h"
#import "ChatViewController.h"
#import "AddFriends.h"
#import "GroupsContact.h"
#define USERNAME @"username"
#define AVATARDATA @"avatardata"
@interface FriendsMainVC ()<xmppFriendsDelegate>
@property (nonatomic,strong) XMPPUtils *sharedXMPP;
@property (nonatomic,strong) NSString *chatUserName;

@end

@implementation FriendsMainVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [_sharedXMPP queryRoster];
}









- (void)viewDidLoad {
    [super viewDidLoad];
    _friendsArray = [NSMutableArray array];
    _sharedXMPP = [XMPPUtils sharedInstance];
    _sharedXMPP.friendsDelegate = self;
    [self addFriendsBarButton];
    
    [QSUtils setExtraCellLineHidden:self.tableView];
    
    
    
    
    
   }

- (void)addFriendsBarButton
{
    UIBarButtonItem *addFriendsBarButton = [[UIBarButtonItem alloc]initWithTitle:@"找个朋友" style:UIBarButtonItemStylePlain target:self action:@selector(addfriends)];
    self.navigationItem.rightBarButtonItem = addFriendsBarButton;
}


- (void)addfriends
{

    NSLog(@"找朋友");
    AddFriends *addfriend=[[AddFriends alloc]init];
    [self.navigationController pushViewController:addfriend animated:YES];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 60.0;
    
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
    return [_friendsArray count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"friendCell";
    MyFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"MyFriendCell" owner:self options:nil]lastObject];
    }
    
    if (indexPath.row == 0) {
        cell.name.text = @"群组";
        cell.avatarImage.image = [UIImage imageNamed:@"groupContact.png"];
    }
    
    else if ([_friendsArray count]) {
        cell.name.text = [[_friendsArray objectAtIndex:[indexPath row] - 1] objectForKey:USERNAME];
        NSData *data = [[_friendsArray objectAtIndex:[indexPath row] - 1] objectForKey:AVATARDATA];
        if (data) {
            cell.avatarImage.image = [UIImage imageWithData:data];
        }
        
    }
    
    //标记
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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
    if (indexPath.row == 0) {
        GroupsContact *groupContact=[[GroupsContact alloc]init];
        [self.navigationController pushViewController:groupContact animated:YES];
    }
    else{
        _chatUserName = (NSString *)[[_friendsArray objectAtIndex:[indexPath row] - 1] objectForKey:USERNAME];
        
        ChatViewController *chatVC=[[ChatViewController alloc]init];
        chatVC.chatName=_chatUserName;
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        NSData *chatWithdata = [[_friendsArray objectAtIndex:[indexPath row] - 1] objectForKey:AVATARDATA];
        if (chatWithdata) {
            chatVC.chatWithAvatar = chatWithdata;
        }
    
     [self.navigationController pushViewController:chatVC animated:YES];
    
    
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    
    
    
    
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark xmppFriendsDelegate implement

-(void)removeFriens
{
    if(_friendsArray)
        [_friendsArray removeAllObjects];
    [self.tableView reloadData];
    
}

- (void)friendsList:(NSDictionary *)dict
{
    NSMutableDictionary *_friendDict = [NSMutableDictionary dictionaryWithCapacity:4];
    [_friendDict setObject:dict[@"name"] forKey:USERNAME];
    if ([dict objectForKey:@"avatar"]) {
        [_friendDict setObject:dict[@"avatar"] forKey:AVATARDATA];
    }
    [_friendsArray addObject:_friendDict];
    [self.tableView reloadData];
}













@end
