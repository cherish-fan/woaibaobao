//
//  ContactInfo.m
//  woaibaobao
//
//  Created by 梁建 on 14/10/25.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import "ContactInfo.h"
#import "XMPPvCardTemp.h"
#import "XMPPUtils.h"
#import "XMPPvCardTempModule.h"
#import "MBProgressHUD.h"
#import "vCard.h"
@interface ContactInfo ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordLabel;
@property (weak, nonatomic) IBOutlet UIButton *addOrRemoveBtn;

@property (strong,nonatomic) vCard *card;
@property (nonatomic,strong) XMPPvCardTempModule *vCardTempModule;





- (IBAction)addOrRemoveContact:(id)sender;

@end

@implementation ContactInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_contactName) {
        [self initUserInfo:_contactName];
    }
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initUserInfo:(NSString *)contactName
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    XMPPJID *contactJID = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",contactName,XMPP_HOST_NAME]];
    _vCardTempModule = [[XMPPUtils sharedInstance] xmppvCardTempModule];
    [_vCardTempModule fetchvCardTempForJID:contactJID ignoreStorage:YES];
    [_vCardTempModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    
    
}

- (void)setupUserInfo
{
    NSString *blackString = @"未填写";
    _sexLabel.text = _card.sex ? _card.sex :blackString;
    _recordLabel.text = _card.introduce ? _card.introduce :blackString;
    if (_card.avatarData) {
        [_avatarImage setImage:[UIImage imageWithData:_card.avatarData]];
    }
    if (_isFromChatVC) {
        [_addOrRemoveBtn setTitle:@"解除好友关系" forState:UIControlStateNormal];
        [_addOrRemoveBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
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

- (IBAction)addOrRemoveContact:(id)sender {
}

#pragma mark -XMPPvCardTempModuleDelegate methods

- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule
        didReceivevCardTemp:(XMPPvCardTemp *)vCardTemp
                     forJID:(XMPPJID *)jid
{
    NSLog(@"didReceivevCardTemp");
    
    
    _card = [[vCard alloc]init];
    if (vCardTemp.photo) {
        _card.avatarData = vCardTemp.photo;
    }
    if (vCardTemp.sex) {
        _card.sex = vCardTemp.sex;
    }
    if (vCardTemp.title) {
        _card.introduce = vCardTemp.title;
    }
    if (vCardTemp.mailer) {
        _card.location = vCardTemp.mailer;
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [self setupUserInfo];
}

- (void)xmppvCardTempModuleDidUpdateMyvCard:(XMPPvCardTempModule *)vCardTempModule
{
    NSLog(@"DidUpdateMyvCard");
    
}

- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule failedToUpdateMyvCard:(NSXMLElement *)error
{
    NSLog(@"failedToUpdateMyvCard");
    
}























@end
