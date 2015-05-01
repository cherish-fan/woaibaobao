//
//  MyvCardVC.m
//  woaibaobao
//
//  Created by 梁建 on 14/10/26.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import "MyvCardVC.h"
#import "XMPPUtils.h"
#import "XMPPvCardTemp.h"
#import "vCard.h"
#import "MyvCardSex.h"
#import "MyvCardInfo.h"
#import "QBImagePickerController.h"
#import "MyvCardInfo.h"
@interface MyvCardVC ()<UIActionSheetDelegate,QBImagePickerControllerDelegate,MyvCardDelegate,XMPPvCardTempModuleDelegate>

@property (nonatomic,strong) vCard *card;
@property (nonatomic,strong) XMPPvCardTemp *myvCard;
@property (nonatomic,strong) XMPPvCardTempModule *vCardTempModule;
@property (strong, nonatomic)  UIImageView *avatar;
@property (strong, nonatomic)  UILabel *sex;
@property (strong, nonatomic)  UILabel *introduce;
@property (strong, nonatomic) UITableView *vCardTable;


@end

@implementation MyvCardVC



-(void)loadView{
    [super loadView];
    UIView *view=[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view=view;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.avatar=[[UIImageView alloc]initWithFrame:CGRectMake(180, 10, 80, 80)];
    self.sex=[[UILabel alloc]initWithFrame:CGRectMake(150, 10, 100, 40)];
    self.introduce=[[UILabel alloc]initWithFrame:CGRectMake(150, 10, 200, 40)];
    [self loadTabelView];
    _card = [[vCard alloc]init];
    [self setupvCardTemp];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
   [self initUserInfo];
    
    
    
    
}








- (void)setupvCardTemp
{
    _vCardTempModule = [[XMPPUtils sharedInstance] xmppvCardTempModule];
    [_vCardTempModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    _myvCard = [_vCardTempModule myvCardTemp];
}

- (void)initUserInfo
{
    if (_myvCard.photo) {
        _card.avatarData = _myvCard.photo;
    }
    if (_myvCard.sex) {
        _card.sex = _myvCard.sex;
    }
    if (_myvCard.title) {
        _card.introduce = _myvCard.title;
    }
    if (_myvCard.mailer) {
        _card.location = _myvCard.mailer;
    }
    
    [self setupUserInfo];
    [self.vCardTable reloadData];
}

- (void)setupUserInfo
{
    NSString *blackString = @"未填写";
    _sex.text = _card.sex ? _card.sex :blackString;
    _introduce.text = _card.introduce ? _card.introduce :blackString;
    if (_card.avatarData)
    {
        [_avatar setImage:[UIImage imageWithData:_card.avatarData]];
    }
}


-(void)loadTabelView
{
    self.vCardTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-28) style:UITableViewStyleGrouped];
    
    self.vCardTable.delegate=self;
    self.vCardTable.dataSource=self;
    self.vCardTable.userInteractionEnabled=YES;
    [self.view addSubview:self.vCardTable];
 
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
 {
     
     static NSString *reuseIdentifier=@"CELL";
     UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
     if (cell==nil)
     {
         cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
         
     }
     if (indexPath.row==0)
     {
         
     cell.textLabel.text=@"头像";
    [cell.contentView addSubview:self.avatar];
     }
     
     if (indexPath.row==1)
     {
         cell.textLabel.text=@"性别";
        
         [cell.contentView addSubview:self.sex];
         
     }
     
     if (indexPath.row==2)
     {
      cell.textLabel.text=@"个性签名";
         
     [cell.contentView addSubview:self.introduce];
     }
     
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==0) {
        return 100;
    }else{
        
        
        return 60;
    }
    
    
    
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
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"更换头像" otherButtonTitles:nil, nil];
        [actionSheet showInView:self.view];
    }
    if (indexPath.row==1) {
       
       
        MyvCardSex *mycardsex=[[MyvCardSex alloc]init];
       
        mycardsex.delegate=self;
        mycardsex.sex=_sex.text;
        [self.navigationController pushViewController:mycardsex animated:YES];
    
    }
    
    if (indexPath.row==2) {
        
        MyvCardInfo *myvcardInfo=[[MyvCardInfo alloc]init];
        
        myvcardInfo.delegate=self;
        myvcardInfo.introduce=self.introduce.text;
        [self.navigationController pushViewController:myvcardInfo animated:YES];
        
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


#pragma mark -XMPPvCardTempModuleDelegate methods

- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule
        didReceivevCardTemp:(XMPPvCardTemp *)vCardTemp
                     forJID:(XMPPJID *)jid
{
    NSLog(@"didreceivecard");
}

- (void)xmppvCardTempModuleDidUpdateMyvCard:(XMPPvCardTempModule *)vCardTempModule
{
    NSLog(@"didupdatecard");
    
}

- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule failedToUpdateMyvCard:(NSXMLElement *)error
{
    NSLog(@"failtoupdatecard");
    
}

#pragma mark -MyvCardDelegate methods

- (void)didSelectMan:(BOOL)isMan
{
    if (isMan) {
        _sex.text = @"男";
        _myvCard.sex = @"男";
    }
    else{
        _sex.text = @"女";
        _myvCard.sex = @"女";
    }
    
    [_vCardTempModule updateMyvCardTemp:_myvCard];
    [self.tableView reloadData];
}

- (void)didEditIntroduce:(NSString *)introduce
{
    _introduce.text = introduce;
   
    _myvCard.title = introduce;
    
    [_vCardTempModule updateMyvCardTemp:_myvCard];
    
}

#pragma mark -UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        if (![QBImagePickerController isAccessible]) {
            NSLog(@"Error: Source is not accessible.");
        }
        QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = NO;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];
    }
}

#pragma mark - QBImagePickerControllerDelegate

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    CGImageRef imageRef = [[asset defaultRepresentation]fullResolutionImage];
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    
    [_avatar setImage:[UIImage imageWithData:data]];
    _myvCard.photo = data;
    [_vCardTempModule updateMyvCardTemp:_myvCard];
    
    [self dismissImagePickerController];
}

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    [self dismissImagePickerController];
}

- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    
    [self dismissImagePickerController];
}

- (void)dismissImagePickerController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}





@end
