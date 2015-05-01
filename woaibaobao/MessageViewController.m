//
//  MessageViewController.m
//  woaibaobao
//
//  Created by 梁建 on 14/10/15.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import "MessageViewController.h"
#import "UIViewExt.h"
#import "ChatViewController.h"
#import "JSONKit.h"
#import "XMPPUtils.h"
#import "MessageListCell.h"
#import "ChatViewController.h"
#import "FriendsMainVC.h"
#import "CreatOrSelectGroupChatVC.h"
#import "GroupsChatVC.h"
#import "MeMainVC.h"
@interface MessageViewController ()<xmppConnectDelegate>

@property(nonatomic,strong) XMPPUtils *sharedXMPP;
@property(nonatomic,strong) NSMutableArray *chatArray;
@property (nonatomic,strong) NSString *chatUserName;
@property int msgNum;


@end

@implementation MessageViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        
        self.title=@"消息";
        [self.navigationItem setHidesBackButton:YES];
        btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(0, 5, 20, 20);
        [btn setBackgroundImage:[UIImage imageNamed:@"share_to_time_line_icon"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"share_to_time_line_icon"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(getfriendList)forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem=back;
        NSLog(@"%f",self.navigationController.navigationBar.height);
        isDown=YES;
        
        addFriendButton =[UIButton buttonWithType:UIButtonTypeCustom];
        addFriendButton.frame=CGRectMake(0, 5, 20, 20);
        [addFriendButton setBackgroundImage:[UIImage imageNamed:@"icon_addfriend"] forState:UIControlStateNormal];
        [addFriendButton setBackgroundImage:[UIImage imageNamed:@"icon_addfriend"] forState:UIControlStateSelected];
        
        
        
        [addFriendButton addTarget:self action:@selector(createGroupAction)forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *back2=[[UIBarButtonItem alloc]initWithCustomView:addFriendButton];
        self.navigationItem.leftBarButtonItem=back2;
        
        
        
        
        
        
        
    }
    return self;
}












-(void)loadView
{
    
    
    
    [super loadView];
    UIView *view=[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view=view;
    view.backgroundColor = [UIColor colorWithRed:164.0/255.0 green:226.0/255.0 blue:211.0/255.0 alpha:1];
    
    
    
    FriendOrChatData *userinfo=[[FriendOrChatData alloc]init];
    [userinfo getUserMessageWithAccount:@"15562565333" WithDeleage:self];
    
    
    
  
}









- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadListView];
    NSLog(@"---->Location:<----%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]);
    _chatArray = [NSMutableArray arrayWithCapacity:20];
    [self addNotify];
    
    
    
    
}



- (void)viewWillAppear:(BOOL)animated
{
    
    [self.parentViewController.tabBarItem setBadgeValue:nil];
    _msgNum = 0;
    
    NSString *userName =[[NSUserDefaults standardUserDefaults] objectForKey:XMPP_USER_NAME];
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_chatRecord",userName]];
    [_chatArray removeAllObjects];
    _chatArray = [NSMutableArray arrayWithArray:array];
    [_listView reloadData];
}








- (void)addNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatNotify:) name:NOTIFY_CHAT_MSG object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendsRequestNotify:) name:NOTIFY_Friends_Request object:nil];
    
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

-(void)getfriendList
{
    
#if  __has_feature(objc_arc)
    
    
#else
    
    
#endif
    
    
    
    [UIView animateWithDuration:0.3 animations:
     ^{
        btn.transform = CGAffineTransformRotate(btn.transform, DEGREES_TO_RADIANS(180));
    }];

    
    
    
    if (isDown)
    {
        if (_barView==nil)
        {
            
            _barView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"导航栏1"]];
            //设置拉伸属性
            // UIImage *image= [_barView.image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
            //_barView.image=image;
            _barView.backgroundColor=[UIColor whiteColor];
            _barView.frame=CGRectMake(0, -60, ScreenWidth, 60);
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
             button.frame=CGRectMake(170, 10, 30, 30);
            [button setBackgroundImage:[UIImage imageNamed:@"icon_addfriend"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(showFriendList) forControlEvents:UIControlEventTouchUpInside];
            
            
            UIButton *button3=[UIButton buttonWithType:UIButtonTypeCustom];
            button3.frame=CGRectMake(120, 10, 30, 30);
            [button3 setBackgroundImage:[UIImage imageNamed:@"xiaoyuan_icon_11"] forState:UIControlStateNormal];
            [button3 addTarget:self action:@selector(showMyInfo) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            
            
            
            [self.view addSubview:_barView];
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectZero];
            label.tag=2015;
            label.font=[UIFont systemFontOfSize:16.0f];
            label.textColor=[UIColor whiteColor];
            label.backgroundColor=[UIColor clearColor];
            _barView.userInteractionEnabled=YES;
            
            [_barView addSubview:label];
            [_barView addSubview:button];
            [_barView addSubview:button3];
        }
        UILabel *label=(UILabel *)[_barView viewWithTag:2015];
        label.text=[NSString stringWithFormat:@""];
        [label sizeToFit];
        label.origin=CGPointMake((_barView.width-label.width)/2, (_barView.height-label.height)/2);
        [UIView animateWithDuration:0.5 animations:^{
            _barView.top=0;
        }completion:^(BOOL finish){
            //
            //        if (finish) {
            //            [UIView beginAnimations:nil context:nil];
            //            [UIView setAnimationDelay:0];
            //            [UIView setAnimationDuration:0.5];
            //            _barView.top=-40;
            //            [UIView commitAnimations];
            //        }
        }];
        
        
        
        
    }else{
        
        [UIView animateWithDuration:0.2 animations:^{
            _barView.top=-60;
        }completion:^(BOOL finish){
            //
            //        if (finish) {
            //            [UIView beginAnimations:nil context:nil];
            //            [UIView setAnimationDelay:0];
            //            [UIView setAnimationDuration:0.5];
            //            _barView.top=-40;
            //            [UIView commitAnimations];
            //        }
        }];
 
        
        
        
    }
    
    
    isDown=!isDown;
    
    
    
    
    
    
}


-(void)createGroupAction
{
    
    CreatOrSelectGroupChatVC *createorselectVc=[[CreatOrSelectGroupChatVC alloc]init];
    
    
    
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:createorselectVc];
    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:nav animated:YES completion:^{
        
        
    }];
    
    
    
}



-(void)showFriendList
{
    
    
    NSLog(@"%p",_cmd);
    
    FriendsMainVC *friendMain=[[FriendsMainVC alloc]init];
    [self.navigationController pushViewController:friendMain animated:YES];
    
    
}


-(void)showMyInfo
{
    MeMainVC *memainVc=[[MeMainVC alloc]init];
    [self.navigationController pushViewController:memainVc animated:YES];
    
    
    
    
}



#pragma mark-privite Method
-(void)loadListView
{
    
 
    
    _listView=[[BaseTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-28) style:UITableViewStyleGrouped];
    
        
        
  
    
    // _listView.eventdelegate=self;
    _listView.dataSource=self;
    _listView.delegate=self;
    _listView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    _listView.indicatorStyle=UIScrollViewIndicatorStyleBlack;
    [self.view addSubview:_listView];
    
    
    
}

-(void)refreshUI
{
    
        [_listView reloadData];
    
    
    
}

- (void)removeNotify
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFY_CHAT_MSG object:nil];
}

- (void)chatNotify:(NSNotification *)noti
{
    
    
    //通知接收到消息了
    NSLog(@"%@",@"通知接收到消息了");
    NSMutableDictionary *chatDict = [noti object];
    BOOL isOutgoing = [[chatDict objectForKey:@"isOutgoing"] boolValue];
    BOOL isExist = NO;
    NSUInteger index = 0;
    if (_chatArray) {
        for (NSMutableDictionary *obj in _chatArray)
        {
            if ([self isGroupChatType:chatDict])
            {
                if ([obj[@"chatType"] isEqualToString:@"groupchat"] && [obj[@"roomJID"] isEqualToString: chatDict[@"roomJID"]])
                {
                    isExist = YES;
                    index = [_chatArray indexOfObject:obj];
                    break;
                }
            }
            else
            {
                if ([[obj objectForKey:@"chatwith"] isEqualToString:chatDict[@"chatwith"]])
                {
                    isExist = YES;
                    index = [_chatArray indexOfObject:obj];
                    break;
                }
            }
            
        }
        if (isExist)
        {
            [_chatArray removeObjectAtIndex:index];
            [_chatArray insertObject:chatDict atIndex:0];
        }
        else
        {
            [_chatArray insertObject:chatDict atIndex:0];
        }
    }
    else{
        [_chatArray insertObject:chatDict atIndex:0];
    }
    
    NSUInteger selectedIndex = [(UITabBarController *)self.parentViewController.parentViewController selectedIndex];
    if (!isOutgoing && (selectedIndex != 0))
    {
        [self.parentViewController.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%d",++_msgNum]];
    }
    
    [_listView reloadData];
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:XMPP_USER_NAME];
    [[NSUserDefaults standardUserDefaults] setObject:_chatArray forKey:[NSString stringWithFormat:@"%@_chatRecord",userName]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)friendsRequestNotify:(NSNotification *)noti
{
    NSString *requestType = [noti object];
    if ([requestType isEqualToString:@"friendsInvite"])
    {
        [[(UINavigationController *)[[self.tabBarController viewControllers] objectAtIndex:3] tabBarItem] setBadgeValue:@"New"];
    }

}
#pragma mark - Intermediate Methods
    
    -(BOOL)isGroupChatType:(NSDictionary *)dict
    {
        if (dict[@"chatType"] && [dict[@"chatType"] isEqualToString:@"groupchat"])
        {
            return YES;
        }
        return NO;
    }










#pragma mark -TableView Delegate
//代理方法可以修改每一个行的高度
/*
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
 - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
 - (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
 
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_chatArray count] == 0){
        return 300.0;
    }
    else{
        return 60.0;
    }

}
//用户点击单元格调用此方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *chatDict = [_chatArray objectAtIndex:indexPath.row];
    
    if ([self isGroupChatType:chatDict])
    {
        
        
        GroupsChatVC *groupChatVc=[[GroupsChatVC alloc]init];
        NSDictionary *chatDict = [_chatArray objectAtIndex:indexPath.row];
        
      groupChatVc.roomJID= [XMPPJID jidWithString:chatDict[@"roomJID"]];
        [self.navigationController pushViewController:groupChatVc animated:YES];
        
        
//        [self performSegueWithIdentifier:@"chatMain2GroupsChat" sender:self];
    }
    else{
        _chatUserName = (NSString *)[[_chatArray objectAtIndex:[indexPath row]] objectForKey:@"chatwith"];
        
//        [self performSegueWithIdentifier:@"Chat2Chat" sender:self];
        
        ChatViewController *chatVc=[[ChatViewController alloc]init];
        chatVc.chatName = _chatUserName;
        
        NSIndexPath *indexPath = _listView.indexPathForSelectedRow;
       
        NSDictionary *chatDict = [_chatArray objectAtIndex:indexPath.row];
        
        NSData *data = [chatDict objectForKey:@"chatWithAvatar"];
        
        if (data) {
            chatVc.chatWithAvatar = data;
        }
        
        
        
        
        [self.navigationController pushViewController:chatVc animated:YES];
        
        
        
        
        
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    
    
    
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -TableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{if([_chatArray count] == 0){
    _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _listView.scrollEnabled = NO;
    _listView.userInteractionEnabled = NO;
    return 1;
}
else{
     _listView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
     _listView.scrollEnabled = YES;
     _listView.userInteractionEnabled = YES;
    return [_chatArray count];
}

}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if([_chatArray count] == 0){
        static NSString *NoChatCellIdentifier = @"No Chat Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NoChatCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NoChatCellIdentifier];
        }
        cell.textLabel.text = @"没有对话...";
        return cell;
    }
    
    static NSString *CellIdentifier = @"chatList";
    MessageListCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"MessageListCell" owner:self options:nil] lastObject];
    }
    
    NSDictionary *chatDict = [_chatArray objectAtIndex:indexPath.row];
    NSString *body = [chatDict objectForKey:@"body"];
    NSMutableString *bodyString = [NSMutableString stringWithCapacity:40];
    if ([body hasPrefix:@"voiceBase64"]) {
        [bodyString appendString:@"[语音]"];
    }
    else if ([body hasPrefix:@"photoBase64"]){
        [bodyString appendString:@"[图片]"];
        
    }
    else if ([body hasPrefix:@"locationBase64"]){
        [bodyString appendString:@"[位置]"];
    }
    else
        [bodyString appendString:body];
    
    
    NSDate *timestamp = [chatDict objectForKey:@"timestamp"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM-dd hh:mm"];
    NSString *sendDate = [dateFormatter stringFromDate:timestamp];
    
    if ([self isGroupChatType:chatDict])
    {
        cell.avatar.image = [UIImage imageNamed:@"groupContact.png"];
        cell.chatWithName.text = [[XMPPJID jidWithString:chatDict[@"roomJID"]] user] ;
        cell.chatMessage.text = [NSString stringWithFormat:@"%@:%@",chatDict[@"from"],bodyString];
    }
    else
    {
        cell.avatar.image = [chatDict objectForKey:@"chatWithAvatar"] ? [UIImage imageWithData:[chatDict objectForKey:@"chatWithAvatar"]] : [UIImage imageNamed:@"avatar_default.png"];
        cell.chatWithName.text = chatDict[@"chatwith"];
        cell.chatMessage.text= bodyString;
        
    }
    
    
    cell.chatDate.text = sendDate;
    
    return cell;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *t=@"";
    return t;
}// fixed font style. use custom view (UILabel) if you want something different
/*- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
 
 }
 
 */
//配置表视图中section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



-(void)push
{
    ChatViewController *chat=[[ChatViewController alloc]init];
    [self.navigationController pushViewController:chat animated:YES];
    
    
    
}

#pragma mark-ASIRequsetDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {
    NSLog(@"ChatController.requestFinished:%@", request.responseString);
    NSData *dataSource = request.responseData;
    if (dataSource.length != 0)
    {  NSMutableDictionary *dic = [dataSource objectFromJSONData];
        
        
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"ChatController.requestFailed");
    
}





@end
