 //
//  GroupsChatVC.m
//  woaibaobao
//
//  Created by 梁建 on 14/10/25.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import "GroupsChatVC.h"
#import "UIUtils.h"
#import "UIViewExt.h"
#import "GroupInfoVC.h"
#define MSG_BODY        @"body"
#define MSG_TIMESTAMP   @"timestamp"
#define MSG_AVATAR      @"chatWithAvatar"
#define MSG_ISOUTGOING  @"isOutgoing"


@interface GroupsChatVC ()
{
    UIButton *addFriendButton;
    
}
@property (strong,nonatomic) NSData *myAvatar;
@property (strong,nonatomic) GroupChatUtils *groupChatUtils;
@property (strong,nonatomic) XMPPUtils *sharedXMPP;
@property (strong,nonatomic) NSMutableArray *bubbleMessages;
@property (strong,nonatomic) NSMutableArray *rawMessages;

@property (strong, nonatomic) UIBubbleTableView *bubbleTable;

@end

//水平方向上表情的个数
static NSInteger FACE_COUNT_HORIZCONTALLY = 7;
//水平间隔
static CGFloat FACE_INTERCVAL_HORIZCONTALLY = 10.0;
//垂直方向上表情的间隔
static CGFloat FACE_INTERCVAL_VERTICALLY = 15.0;
//垂直方向上表情的个数
static CGFloat FACE_VALUE =  30.0;








@implementation GroupsChatVC

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        addFriendButton =[UIButton buttonWithType:UIButtonTypeCustom];
        addFriendButton.frame=CGRectMake(0, 5, 20, 20);
        [addFriendButton setBackgroundImage:[UIImage imageNamed:@"icon_addfriend"] forState:UIControlStateNormal];
        [addFriendButton setBackgroundImage:[UIImage imageNamed:@"icon_addfriend"] forState:UIControlStateSelected];
        [addFriendButton addTarget:self action:@selector(getGroupInfo)forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *back2=[[UIBarButtonItem alloc]initWithCustomView:addFriendButton];
        self.navigationItem.rightBarButtonItem=back2;
    }
    
    
    return self;
    
    
}
  


-(void)loadView
{
    [super loadView];
    UIView *view=[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view=view;
    NSLog(@"%f",self.view.frame.size.height);
    
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    _isKey=YES;
    
    [self loadListView];
    [self setup];
    
    [self setupToolViews];
    [self setupvideoView];
    
    [_messageField setText:@""];
    [self.bubbleTable.panGestureRecognizer addTarget:self action:@selector(scrollHandlePan:)];
    
    // Do any additional setup after loading the view from its nib.
    
    //设置整个表情视图
    
    for (int i = 0; i < 100; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"face_%03d.png", i+1]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onItemClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat x = i % FACE_COUNT_HORIZCONTALLY * (FACE_VALUE + FACE_INTERCVAL_HORIZCONTALLY) + 20;
        CGFloat y = i / FACE_COUNT_HORIZCONTALLY * (FACE_VALUE + FACE_INTERCVAL_VERTICALLY) + 20;
        [btn setFrame:CGRectMake(x, y, FACE_VALUE, FACE_VALUE)];
        [btn setTag:i+1];
        [_faceView addSubview:btn];
    }
    //  表情背景的高度[[_faceView.subviews lastObject] frame].origin.y + FACE_VALUE + 10
    [_faceView setContentSize:CGSizeMake(320, [[_faceView.subviews lastObject] frame].origin.y + FACE_VALUE + 10)];
    [self.bubbleTable scrollBubbleViewToBottomAnimated:YES];
    
    [self scrollToBottom];
    
    
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    _toolView.hidden = NO;
    _videoView.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShown:) name:UIKeyboardWillShowNotification object:nil];
    
    //发送消息按钮隐藏
    _btn_send.hidden = YES;
    //取消按钮隐藏
    //_btn_quxiao.hidden = YES;
    
    
    
}

-(void)getGroupInfo
{
    
    GroupInfoVC *groupinfo=[[GroupInfoVC alloc]init];
    groupinfo.roomJID=_roomJID;
    [self.navigationController pushViewController:groupinfo animated:YES];
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(void)setup
{
    self.title = [_roomJID user];
    [self setupBubbleTableView];
    _bubbleMessages = [NSMutableArray array];
    _rawMessages = [NSMutableArray array];
    _groupChatUtils = [[GroupChatUtils alloc]init];
    _sharedXMPP = [XMPPUtils sharedInstance];
    _sharedXMPP.messageDelegate = self;
    
//   
//    [self setupTapGestureRecognizer];
    [self setupMyAvatar];
    
    [self getMessageData];
    
    if ([_bubbleMessages count] > 1) {
        [self.bubbleTable scrollBubbleViewToBottomAnimated:YES];
    }
    
    
    
    
    
}

- (void)setupMyAvatar
{
    XMPPJID *myJid = _sharedXMPP.xmppStream.myJID;
    XMPPvCardTempModule *vCardModule = _sharedXMPP.xmppvCardTempModule;
    XMPPvCardTemp *myCard = [vCardModule vCardTempForJID:myJid shouldFetch:YES];
    NSData *avatarData = myCard.photo;
    if (avatarData) {
        _myAvatar = avatarData;
    }

    
}
- (void)setupBubbleTableView
{
 self.bubbleTable.bubbleDataSource = self;
 self.bubbleTable.snapInterval = 120;
 self.bubbleTable.showAvatars = YES;
    
}
#pragma mark - Get Data From CoreData

- (void)getMessageData
{
    NSManagedObjectContext *context = [[XMPPRoomCoreDataStorage sharedInstance] mainThreadManagedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPRoomMessageCoreDataStorageObject" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(roomJIDStr == %@) AND (streamBareJidStr == %@)",_roomJID,[_sharedXMPP.xmppStream.myJID bare]];
    [request setPredicate:predicate];
    NSError *error ;
    NSArray *dataArray = [context executeFetchRequest:request error:&error];
    
    [_bubbleMessages removeAllObjects];
    [_rawMessages removeAllObjects];
    
    for (XMPPRoomMessageCoreDataStorageObject *messageObject in dataArray)
    {
        if ([[messageObject jid] isFull])
        {
            
            NSString *sendString = [messageObject body];
            NSDate *sendDate = [messageObject localTimestamp];
            BOOL isFromMe = [[messageObject fromMe] boolValue];
            XMPPJID *fromJID = [messageObject jid];
            XMPPJID *sendJID = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",[fromJID resource],XMPP_HOST_NAME]];
            
            NSData *avatarData = nil;
            if (isFromMe)
            {
                avatarData = _myAvatar;
            }
            else
            {
                [_sharedXMPP.xmppvCardTempModule fetchvCardTempForJID:sendJID];
                XMPPvCardTemp *vCard = [_sharedXMPP.xmppvCardTempModule vCardTempForJID:sendJID shouldFetch:YES];
                avatarData = vCard.photo;
            }
            
            
            NSMutableDictionary *messageDict = [NSMutableDictionary dictionary];
            [messageDict setObject:sendString forKey:MSG_BODY];
            [messageDict setObject:sendDate forKey:MSG_TIMESTAMP];
            [messageDict setObject:@(messageObject.isFromMe) forKey:MSG_ISOUTGOING];
            
            if (avatarData)
            {
                [messageDict setObject:avatarData forKey:MSG_AVATAR];
            }
            
            NSBubbleData *bubdata = [self dictToBubbleData:messageDict];
            
            [_bubbleMessages addObject:bubdata];
            [_rawMessages addObject:messageDict];
            
            
            
            
            
            
            
        }
  
    
    }
    [self.bubbleTable reloadData];
    
    
    
}

//滑动聊天界面,将键盘进行隐藏
- (void)scrollHandlePan:(UIPanGestureRecognizer *)panParam
{
    [self hidenKeyboard];
    _btnAdd.hidden = NO;
    _btn_send.hidden = YES;
    [self.videoView setHidden:YES];
    
}

- (void)hidenKeyboard
{
    [_messageField resignFirstResponder];
    [self handleView:0 setAnimationDuration:0.3];
    
    [self animateTextField:_messageField up:NO moveDistance:0];
    
    
    
    
    
    
    
    
}

- (void)onKeyboardShown:(NSNotification *)notify
{
    //通知显示键盘
    CGFloat keyboardHeight = [[notify.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    NSLog(@"%ff",keyboardHeight);
    NSTimeInterval duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [self handleView:keyboardHeight setAnimationDuration:duration];
    [self.bubbleTable scrollBubbleViewToBottomAnimated:YES];
    
    
    CGRect viewFrame = CGRectMake(0.0, 0.0, self.bubbleTable.frame.size.width, self.bubbleTable.frame.size.height);
    
    
    [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bubbleTable.frame = CGRectOffset(viewFrame, 0, -keyboardHeight+20);
        //        self.toolView.frame=CGRectOffset(toolViewFrame,0, keyboardHeight+44);
    } completion:nil];
    
    
    
    
    
    
    
    
    
    
}







- (void)handleView:(CGFloat)height setAnimationDuration:(NSTimeInterval)duration
{
    CGFloat selfHeight = self.view.frame.size.height;
    CGRect sendRect = self.toolView.frame;
    sendRect.origin.y = selfHeight - height - 40;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:duration];
    
    [self.toolView setFrame:sendRect];
    [UIView commitAnimations];
}

//点击表情的方法
- (void)onItemClick:(UIButton *)sender
{
    [_messageField setText:[NSString stringWithFormat:@"%@[face_%03d]",_messageField.text, sender.tag]];
}



-(void)setupToolViews
{
    
    
    
    //<UIView: 0x79651c40; frame = (0 440; 320 240); autoresize = RM+TM; layer = <CALayer: 0x7961e5a0>>
    //460
    self.toolView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-88, ScreenWidth, 240)];
    self.toolViewbg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    self.toolView.userInteractionEnabled=YES;
    
    [self.toolViewbg setImage:[UIImage imageNamed:@"tbbg"]];
    self.toolViewbg.userInteractionEnabled=YES;
    [self.toolView addSubview:self.toolViewbg];
    
    self.btnVideo=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnVideo setBackgroundImage:[UIImage imageNamed:@"skin_aio_voice_nor"] forState:UIControlStateNormal];
    self.btnVideo.frame=CGRectMake(8, 4, 33, 33);
    [self.btnVideo addTarget:self action:@selector(btnVideoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.toolView addSubview:self.btnVideo];
    
    self.btnFace=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnFace setBackgroundImage:[UIImage imageNamed:@"icon_face_nor"] forState:UIControlStateNormal];
    self.btnFace.frame=CGRectMake(239, 2, 35, 35);
    [self.btnFace addTarget:self action:@selector(btn_faceAction) forControlEvents:UIControlEventTouchUpInside];
    [self.toolView addSubview:self.btnFace];
    
    self.btnAdd=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnAdd setBackgroundImage:[UIImage imageNamed:@"skin_aio_more_nor"] forState:UIControlStateNormal];
    [self.btnAdd addTarget:self action:@selector(btnAddAction) forControlEvents:UIControlEventTouchUpInside];
    self.btnAdd.frame=CGRectMake(277, 2, 34, 34);
    [self.toolView addSubview:self.btnAdd];
    
    self.btn_send=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn_send setBackgroundImage:[UIImage imageNamed:@"btn_send"] forState:UIControlStateNormal];
    self.btn_send.frame=CGRectMake(280, 4, 32, 32);
    [self.btn_send addTarget:self action:@selector(btn_sendAction) forControlEvents:UIControlEventTouchUpInside];
    [self.toolView addSubview:self.btn_send];
    
    self.messageField=[[UITextField alloc]initWithFrame:CGRectMake(54, 5, 177, 30)];
    self.messageField.backgroundColor=[UIColor whiteColor];
    self.messageField.delegate=self;
    [self.toolView addSubview:self.messageField];
    
    self.faceView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, 200)];
    [self.toolView addSubview:self.faceView];
    [self.view addSubview:self.toolView];
    /*
     2014-10-20 00:30:30.521 Carpool[2686:607] <UIImageView: 0x7c161e50; frame = (0 0; 320 44); autoresize = RM+BM; userInteractionEnabled = NO; layer = <CALayer: 0x7c162e40>>
     2014-10-20 00:30:42.386 Carpool[2686:607] <UIButton: 0x7bfef0c0; frame = (239 0; 30 40); opaque = NO; autoresize = RM+BM; tag = 3; layer = <CALayer: 0x7bfee7a0>>
     2014-10-20 00:30:58.488 Carpool[2686:607] <UIButton: 0x7bfec590; frame = (8 -2; 39 44); opaque = NO; autoresize = RM+BM; layer = <CALayer: 0x7bfc6710>>
     2014-10-20 00:31:01.670 Carpool[2686:607] <UIButton: 0x7bfbf9b0; frame = (277 -2; 39 44); opaque = NO; autoresize = RM+BM; layer = <CALayer: 0x7bfb75a0>>
     2014-10-20 00:31:03.123 Carpool[2686:607] <UIButton: 0x7c0ec2e0; frame = (280 7; 30 25); opaque = NO; autoresize = RM+BM; layer = <CALayer: 0x7c0e6ed0>>
     2014-10-20 00:31:04.574 Carpool[2686:607] <UITextField: 0x7bff4ca0; frame = (54 5; 177 30); text = ''; clipsToBounds = YES; opaque = NO; autoresize = RM+BM; layer = <CALayer: 0x7bff4bf0>>
     2014-10-20 00:31:06.113 Carpool[2686:607] <UIScrollView: 0x7c175c70; frame = (0 40; 320 200); clipsToBounds = YES; autoresize = RM+TM; gestureRecognizers = <NSArray: 0x7c176010>; layer = <CALayer: 0x7c175e40>; contentOffset: {0, 0}>
     
     */
    
    
    
    
    
    
    
    
    
    
    
}


-(void)setupvideoView
{
    
    self.videoView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.bottom-80-44, ScreenWidth, 80)];
    self.videoView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.videoView];
    self.btn_voice=[UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_voice.frame=CGRectMake(131, 0, 59, 59);
    [self.btn_voice setBackgroundImage:[UIImage imageNamed:@"btn_video"] forState:UIControlStateNormal];
    [self.videoView addSubview:self.btn_voice];
    
    self.btn_picture=[UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_picture.frame=CGRectMake(12, 0, 59, 59);
    [self.btn_picture setBackgroundImage:[UIImage imageNamed:@"chat_tool_photo"] forState:UIControlStateNormal];
    [self.btn_picture addTarget:self action:@selector(btn_pictureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.videoView addSubview:self.btn_picture];
    
    self.btn_takephoto=[UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_takephoto.frame=CGRectMake(92, 0, 59, 59);
    [self.btn_takephoto setBackgroundImage:[UIImage imageNamed:@"chat_tool_camera"] forState:UIControlStateNormal];
    [self.videoView addSubview:self.btn_takephoto];
    
    self.btn_homework=[UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_homework.frame=CGRectMake(172, 0, 59, 59);
    [self.btn_homework setBackgroundImage:[UIImage imageNamed:@"chat_tool_send_file"] forState:UIControlStateNormal];
    [self.videoView addSubview:self.btn_homework];
    
    
    self.btn_place=[UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_place.frame=CGRectMake(252, 0, 59, 59);
    [self.btn_place setBackgroundImage:[UIImage imageNamed:@"chat_tool_location"] forState:UIControlStateNormal];
    [self.btn_place addTarget:self action:@selector(btn_placeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.videoView addSubview:self.btn_place];
    
    
    
    
    //加上4个按钮
    
    
    
    
    
    
    
    
    
}



-(void)btnAddAction
{
    [self.videoView setHidden:NO];
    [self.view endEditing:YES];
    
    CGRect rectTool = self.toolView.frame;
    rectTool.origin.y =self.videoView.top-44;//[UIScreen mainScreen].bounds.size.height   self.view.height - self.videoView.frame.size.height-44
    [self.toolView setFrame:rectTool];
    _videoView.hidden = NO;
    _btn_voice.hidden = YES;
    _btn_picture.hidden = NO;
    _btn_place.hidden = NO;
    _btn_takephoto.hidden=NO;
    _btn_homework.hidden=NO;
    _faceView.hidden = YES;
    
}
-(void)btnVideoAction
{
    if (_isKey== YES) {
        [self.messageField becomeFirstResponder];
        [_btnVideo setBackgroundImage:[UIImage imageNamed:@"skin_aio_voice_nor"] forState:UIControlStateNormal];
        _isKey = NO;
    }else{
        [self.videoView setHidden:NO];
        [self.view endEditing:YES];
        CGRect rectTool = self.toolView.frame;
        rectTool.origin.y = self.videoView.top-44;//-44
        [self.toolView setFrame:rectTool];
        _videoView.hidden = NO;
        _btn_voice.hidden = NO;
        _btn_picture.hidden = YES;
        _btn_takephoto.hidden=YES;
        _btn_place.hidden = YES;
        _btn_homework.hidden=YES;
        _faceView.hidden = YES;
        [_btnVideo setBackgroundImage:[UIImage imageNamed:@"skin_aio_keyboard_nor"] forState:UIControlStateNormal];
        _isKey = YES;
    }
    _btnAdd.hidden = NO;
    _btn_send.hidden = YES;
    
}
-(void)btn_sendAction{
    [self performSelector:@selector(showKeyboard) withObject:nil afterDelay:0];
    
    //本地输入框中的信息
    NSString *message = self.messageField.text;
    
    if (message.length > 0) {
        
        [self sendWithType:@"text" andBody:message];
    }
    
    self.messageField.text = @"";
    
    
    
    
}
- (void)showKeyboard
{
    [_messageField becomeFirstResponder];
}


-(void)btn_pictureAction
{
    
    if (![QBImagePickerController isAccessible]) {
        NSLog(@"Error: Source is not accessible.");
    }
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.maximumNumberOfSelection = 6;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
    
    
    
    
    
    
    
}

- (void)dismissImagePickerController
{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}



#pragma mark - QBImagePickerControllerDelegate

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    NSLog(@"*** imagePickerController:didSelectAsset:");
    NSLog(@"%@", asset);
    
    [self dismissImagePickerController];
}

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    for (ALAsset *asset in assets)
    {
        CGImageRef imageRef = [[asset defaultRepresentation]fullResolutionImage];
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        NSData *data = UIImageJPEGRepresentation(image, 1.0f);
        NSString *imageBase64Str = [data base64EncodedString];
        [self sendWithType:@"photo" andBody:imageBase64Str];
    }
    [self dismissImagePickerController];
}

- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    
    [self dismissImagePickerController];
}









-(void)btn_takePhotoAction
{
    
}
-(void)btn_placeAction
{
    MyLocation *myLocation=[[MyLocation alloc] init];
    myLocation.delegate=self;
    [self.navigationController pushViewController:myLocation animated:YES];
    
    
    
    
    
    
}
-(void)btn_faceAction
{
    _faceView.hidden = NO;
    _videoView.hidden = YES;
    _btnAdd.hidden = YES;
    _btn_send.hidden = NO;
    [_messageField resignFirstResponder];
    [_faceView setContentOffset:CGPointZero];
    [self handleView:200 setAnimationDuration:0.3];
    [self scrollToBottom];
    
    CGRect viewFrame = CGRectMake(0.0, 0.0, self.bubbleTable.frame.size.width, self.bubbleTable.frame.size.height);
    
    
    [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bubbleTable.frame = CGRectOffset(viewFrame, 0, -216-10);
        //        self.toolView.frame=CGRectOffset(toolViewFrame,0, keyboardHeight+44);
    } completion:nil];
    
    
    
    
}
-(void)btn_homeWorkAction
{
    
}

- (void)scrollToBottom
{
    if (self.bubbleTable.contentSize.height > self.bubbleTable.bounds.size.height)
        [self.bubbleTable setContentOffset:CGPointMake(0, self.bubbleTable.contentSize.height - self.bubbleTable.frame.size.height)];
}

//关闭键盘
-(void)hideKeyBoard
{
    [self.view endEditing:YES];
}



-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _videoView.hidden = YES;
    _btnAdd.hidden = NO;
    _btn_send.hidden = YES;
    _isKey = NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string length] == 0) {
        NSString *endStr = [textField.text substringWithRange:range];
        if ([endStr hasSuffix:@"]"] && [textField.text length] >= 10) {
            NSString *startStr = [textField.text substringWithRange:NSMakeRange(range.location - 9, range.length)];
            if ([startStr hasPrefix:@"["]) {
                NSMutableString *text = [NSMutableString stringWithString:textField.text];
                [text deleteCharactersInRange:NSMakeRange(range.location - 9, range.length + 9)];
                [textField setText:text];
                return NO;
            }
        }
    }
    return YES;
}




#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


















- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
   
    return YES;
}




#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    
    
    
    return [_bubbleMessages count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [_bubbleMessages objectAtIndex:row];
}

- (void)didSelectBubbleRowAtIndexRow:(NSInteger)indexRow
{
    NSDictionary *msgDict = [_rawMessages objectAtIndex:indexRow];
    if ([msgDict objectForKey:MSG_BODY]) {
        if ([msgDict[MSG_BODY]  hasPrefix:@"voiceBase64"]) {
            NSString *voiceBase64Str = [msgDict[MSG_BODY] substringFromIndex:11];
            NSData *data = [voiceBase64Str base64DecodedData];
            
            NSError *playerError;
            
            //播放
            
            //            _player = [[AVAudioPlayer alloc] initWithData:data error:&playerError];
            //
            //            if (_player == nil)
            //            {
            //                NSLog(@"ERror creating player: %@", [playerError description]);
            //            }else{
            //                [_player play];
            //            }
        }
        
        else if ([msgDict[MSG_BODY]  hasPrefix:@"photoBase64"]){
            NSString *photoBase64Str = [msgDict[MSG_BODY] substringFromIndex:11];
            NSData *data = [photoBase64Str base64DecodedData];
            ChatDetailVC *chatDetil=[[ChatDetailVC alloc]init];
            chatDetil.data=data;
            [self.navigationController pushViewController:chatDetil animated:YES];
            
            
            
            
            //            [self performSegueWithIdentifier:SEGUE_CHAT_DETAIL sender:data];
        }
        
        else if ([msgDict[MSG_BODY]  hasPrefix:@"locationBase64"]){
            NSArray *array = [msgDict[MSG_BODY] componentsSeparatedByString:@"locationBase64"];
            double longitude = [[array objectAtIndex:1] doubleValue];
            double latitude = [[array objectAtIndex:2] doubleValue];
            NSDictionary *locationDict = @{@"longitude":[NSNumber numberWithDouble:longitude] , @"latitude":[NSNumber numberWithDouble:latitude]};
            //            [self performSegueWithIdentifier:SEGUE_CHAT_VIEWLOCATION sender:locationDict];
        }
    }
    
    
}


- (void)animateTextField:(UITextField *)textField up:(BOOL)dir moveDistance:(CGFloat)distance
{
    
    CGFloat movementDistance = distance;
    CGFloat movementDuration = 0;
    CGRect viewFrame = CGRectMake(0.0, 0.0, self.bubbleTable.frame.size.width, self.bubbleTable.frame.size.height);
    
    int movement = (dir ? -movementDistance : movementDistance);
    
    [UIView animateWithDuration:movementDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bubbleTable.frame = CGRectOffset(viewFrame, 0, movement);
    } completion:nil];
}












#pragma mark - MyLocationDelegate

-(void)sendLocationImage:(UIImage *)image andLongitude:(double)longitude andLatitude:(double)latitude
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *imageBase64Str = [data base64EncodedString];
    
    NSString *locationBase64 = @"locationBase64";
    NSString *locationString = [NSString stringWithFormat:@"%@%f%@%f%@%@",locationBase64,longitude,locationBase64,latitude,locationBase64,imageBase64Str];
    
    [self sendWithType:@"location" andBody:locationString];
}





#pragma mark - Intermediate Methods

- (void)sendWithType:(NSString *)type andBody:(id)bodyObj
{
    NSMutableString *sendString = [NSMutableString stringWithCapacity:20];
    
    if ([type isEqualToString:@"text"])
    {
        [sendString appendString:(NSString *)bodyObj];
    }
    else if ([type isEqualToString:@"voice"])
    {
        [sendString appendFormat:@"%@%@",@"voiceBase64",(NSString *)bodyObj];
    }
    else if ([type isEqualToString:@"photo"])
    {
        [sendString appendFormat:@"%@%@",@"photoBase64",(NSString *)bodyObj];
    }
    else if ([type isEqualToString:@"location"])
    {
        [sendString appendString:(NSString *)bodyObj];
    }
    
    [_groupChatUtils sendMessageWithBody:sendString andRoomJID:_roomJID];
    
//        NSMutableDictionary *messageDict = [NSMutableDictionary dictionary];
//        [messageDict setObject:sendString forKey:MSG_BODY];
//        [messageDict setObject:[NSDate dateWithTimeIntervalSinceNow:0] forKey:MSG_TIMESTAMP];
//        [messageDict setObject:@(YES) forKey:MSG_ISOUTGOING];
//    
//        if (_myAvatar) {
//            [messageDict setObject:_myAvatar forKey:MSG_AVATAR];
//        }
//    
//        NSBubbleData *bubdata = [self dictToBubbleData:messageDict];
//    
//        [_bubbleMessages addObject:bubdata];
//        [_rawMessages addObject:messageDict];
//    
//        [self.bubbleTable reloadData];
//    
//        if ([_bubbleMessages count] > 1) {
//            [self.bubbleTable scrollBubbleViewToBottomAnimated:YES];
//        }
//    
//        NSMutableDictionary *notifiMessage = [messageDict mutableCopy];
//    
//        [notifiMessage setObject:@"groupchat" forKey:@"chatType"];
//        [notifiMessage setObject:[_roomJID bare] forKey:@"roomJID"];
//    
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CHAT_MSG object:notifiMessage];
//    
    
}




#pragma mark-privite Method
-(void)loadListView
{
    
    self.bubbleTable=[[UIBubbleTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-70) style:UITableViewStyleGrouped];
    
   
    //    [self.view addSubview:_listView];
    [self.view addSubview:self.bubbleTable];
    
    
}

- (NSBubbleData *)dictToBubbleData:(NSDictionary *)dict
{
    NSBubbleData *bubbleData;
    BOOL isOutgoing = [dict[MSG_ISOUTGOING] boolValue];
    NSDate *msgDate = dict[MSG_TIMESTAMP];
    NSString *body = dict[MSG_BODY];
    NSBubbleType bubbleType = isOutgoing?BubbleTypeMine:BubbleTypeSomeoneElse;
    if (body) {
        if ([body hasPrefix:@"voiceBase64"])
        {
            bubbleData = [NSBubbleData dataWithText:@"[语音文件]" date:msgDate type:bubbleType];
        }
        else if ([body hasPrefix:@"photoBase64"])
        {
            NSString *photoBase64Str = [body substringFromIndex:11];
            NSData *data = [photoBase64Str base64DecodedData];
            UIImage *image = [UIImage imageWithData:data];
            bubbleData = [NSBubbleData dataWithImage:image date:msgDate type:bubbleType];
        }
        else if ([body hasPrefix:@"locationBase64"])
        {
            NSArray *array = [body componentsSeparatedByString:@"locationBase64"];
            NSString *locationImageBase64Str = [array lastObject];
            NSData *data = [locationImageBase64Str base64DecodedData];
            UIImage *image = [UIImage imageWithData:data];
            bubbleData = [NSBubbleData dataWithImage:image date:msgDate type:bubbleType];
            
        }
        else
        {
            bubbleData = [NSBubbleData dataWithText:body date:msgDate type:bubbleType];
        }
        
        bubbleData.avatar = dict[MSG_AVATAR] ? [UIImage imageWithData:dict[MSG_AVATAR]] : [UIImage imageNamed:@"avatar_default.png"] ;
        
        
    }
    return bubbleData;
}


#pragma mark - xmppMessageDelegate

-(void)newMessageReceived:(NSDictionary *)messageContent
{
    if ([self isMessageOfTheRoom:messageContent])
    {
        
        NSBubbleData *bubdata = [self dictToBubbleData:messageContent];
        
        [_bubbleMessages addObject:bubdata];
        [_rawMessages addObject:messageContent];
        
        [self.bubbleTable reloadData];
        
        if ([_bubbleMessages count] > 1)
        {
            [self.bubbleTable scrollBubbleViewToBottomAnimated:YES];
        }
    }
}

- (BOOL)isMessageOfTheRoom:(NSDictionary *)messageDict
{
    if ([messageDict[@"chatType"] isEqualToString:@"groupchat"] && [messageDict[@"roomJID"] isEqualToString:[_roomJID bare]]) {
        return YES;
    }
    return NO;
}



@end
