//
//  MessageNotification.m
//  woaibaobao
//
//  Created by 梁建 on 14/10/26.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import "MessageNotification.h"
#import "messageNotificationUtils.h"
#import "TDBadgedCell.h"
#import "QSUtils.h"
#import "MessageNoticationDetail.h"
@interface MessageNotification ()
@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation MessageNotification
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
    [QSUtils setExtraCellLineHidden:self.tableView];
    
    [self setup];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}



- (void)setup
{
    _dataArray = @[@"朋友请求",@"群组邀请"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    
    
    return 1;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Message Notifications Cell";
    TDBadgedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TDBadgedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    if (indexPath.row == 0) {
        if ([messageNotificationUtils unsolvedFriendRequest] != 0) {
            cell.badge.fontSize = 16.0;
            cell.badgeColor = [UIColor redColor];
            cell.badgeString = [NSString stringWithFormat:@"%d",[messageNotificationUtils unsolvedFriendRequest]];
        }
        else{
            [cell.badge setHidden:YES];
            cell.badgeColor = [UIColor whiteColor];
        }
        
    }
    else if (indexPath.row == 1) {
        if ([messageNotificationUtils unsolvedGroupRequest] != 0) {
            cell.badge.fontSize = 16.0;
            cell.badgeColor = [UIColor redColor];
            cell.badgeString = [NSString stringWithFormat:@"%d",[messageNotificationUtils unsolvedGroupRequest]];
        }
        else{
            [cell.badge setHidden:YES];
        }
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




#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageNoticationDetail *vc=[[MessageNoticationDetail alloc]init];
  
    if(indexPath.row == 0)
    {
        vc.isGroupRequest = NO;
    }
    
    else if (indexPath.row == 1)
    {
        vc.isGroupRequest = YES;
    }

    [self.navigationController pushViewController:vc animated:YES];
   
    
    
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
