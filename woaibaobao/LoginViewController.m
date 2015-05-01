//
//  LoginViewController.m
//  woaibaobao
//
//  Created by 梁建 on 14/10/17.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import "LoginViewController.h"
#import "NSString+Helper.h"
#import "AppDelegate.h"
#import "DDXML.h"
#import "NSString+DDXML.h"
#import "GCDAsyncSocket.h"
#import "MainViewController.h"
//获取手机的Mac地址
////#include <sys sysctl.h="">
//#include <net if.h="">
//#include <net if_dl.h=""></net></net></sys>

@interface LoginViewController ()<GCDAsyncSocketDelegate,xmppConnectDelegate,UIAlertViewDelegate>
{
    GCDAsyncSocket *_socket;
    BOOL _ConnectStatus;

    
    
    
}
@property (nonatomic,strong) XMPPUtils *sharedXMPP;
@end

@implementation LoginViewController

#pragma mark - AppDelegate 的助手方法
- (AppDelegate *)appDelegate
{
    return [[UIApplication sharedApplication] delegate];
}








- (void)viewDidLoad
{
    [super viewDidLoad];
    _sharedXMPP = [XMPPUtils sharedInstance];
    _sharedXMPP.connectDelegate = self;
    
    
    
    
    
    //设置文本焦点
    if ([_Username.text isEmptyString])
    {
        [_Username becomeFirstResponder];
    }else{
        
        [_PassWord becomeFirstResponder];
        
        
        
    }
    
   }

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _sharedXMPP.connectDelegate = self;
}








- (void)didReceiveMemoryWarning
{
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

- (IBAction)RegisterAction:(id)sender
{
    NSString *userName = [_Username.text trimString];
    // 用些用户会使用空格做密码，因此密码不能去除空白字符
    NSString *password = _PassWord.text;
    
    
    
    
    if ([userName isEmptyString] ||[password isEmptyString])
    {
        
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录信息不完整" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alter show];
        
        return;
    }else{
    
    
    
    
    
    
    [_sharedXMPP anonymousConnect];
    }
    
    
}

- (IBAction)Login:(id)sender
{
    // 1. 检查用户输入是否完整，在商业软件中，处理用户输入时
    // 通常会截断字符串前后的空格（密码除外），从而可以最大程度地降低用户输入错误
//    _Username.text=@"admin";
//    _PassWord.text=@"171228";
    NSString *userName = [_Username.text trimString];
    // 用些用户会使用空格做密码，因此密码不能去除空白字符
    NSString *password = _PassWord.text;
    if ([userName isEmptyString] ||[password isEmptyString])
    {
    
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录信息不完整" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alter show];
        
        return;
    }
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userName forKey:XMPP_USER_NAME];
    [userDefaults setObject:password forKey:XMPP_USER_PASS];
    [userDefaults synchronize];
    
    
    [_sharedXMPP connect];
    
    
    
    
    
    
    
    
}


#pragma mark XMPPConnectionDelegate methods



- (void)registerSuccess
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注册帐号成功"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    alertView.tag = 11;
    [alertView show];
    
    
}


- (void)registerFailed:(NSXMLElement *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注册帐号失败"
                                                        message:@"用户名冲突"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}


- (void)anonymousConnected
{
    NSString *userName = [_Username text];
    NSString *pass = [_PassWord text];
    XMPPUtils *sharedXMPP = [XMPPUtils sharedInstance];
    [sharedXMPP enrollWithUserName:userName andPassword:pass];
}



- (void)didAuthenticate
{
    if(_isFromME)
        [_backToChatDelegate backToChatTab];
    
    
   
        MainViewController *main=[[MainViewController alloc]init];
        
        main.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        
        
        
        
        
        
        [self presentViewController:main animated:YES completion:^{
            NSLog(@"call back");
            
            
        }];
 
      
        
    
    
    
    
    
    
    
}



- (void)didNotAuthenticate:(NSXMLElement *)error
{
    [self clearUserDefaults];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"用户名或密码不正确" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark-UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 11) {
        NSString *userName = [_Username text];
        NSString *pass = [_PassWord text];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:userName forKey:XMPP_USER_NAME];
        [userDefaults setObject:pass forKey:XMPP_USER_PASS];
        [userDefaults synchronize];
        XMPPUtils *sharedXMPP = [XMPPUtils sharedInstance];
        [sharedXMPP connect];
        
    }
}





#pragma mark-UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    
    
    return YES;
    
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
    
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
   
    if (textField==_Username)
    {
        
        
        
        
        
        [_PassWord becomeFirstResponder];
    }else{
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    return YES;
}


- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    // NSLog(@"shouldChangeCharactersInRange : %@", string);
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    //NSLog(@"textFieldShouldClear");
    return YES;
}











//复写UIView的TouchBegin方法,触摸键盘让键盘自动落下
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.PassWord resignFirstResponder];
    [self.Username resignFirstResponder];
    
    
}







- (void)clearUserDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:XMPP_USER_NAME];
    [userDefaults removeObjectForKey:XMPP_USER_PASS];
    [userDefaults synchronize];
}


@end
