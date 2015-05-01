//
//  LoginViewController.h
//  woaibaobao
//
//  Created by 梁建 on 14/10/17.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginUserModel.h"
#import "XMLElement.h"
#import "XMPPUtils.h"
@protocol BackToChatTabDelegate <NSObject>

@optional
-(void)backToChatTab;

@end









@interface LoginViewController : UIViewController<UITextFieldDelegate,NSXMLParserDelegate,XMPPStreamDelegate>
{
    
   NSMutableArray *elementArray;
    
    
    
    
}




@property (weak, nonatomic) IBOutlet UITextField *Username;

@property (weak, nonatomic) IBOutlet UITextField *PassWord;

//******************************xml解析*******************************


@property (nonatomic,strong) NSXMLParser *parser;

// 根元素

@property (nonatomic,strong) XMLElement *rootElement;

// 当前的元素

@property (nonatomic,strong) XMLElement *currentElementPointer;


@property(nonatomic,copy) NSString *updatestring;

@property (weak,nonatomic) id<BackToChatTabDelegate> backToChatDelegate;


@property (nonatomic) BOOL isFromME;

- (IBAction)RegisterAction:(id)sender;

- (IBAction)Login:(id)sender;

@end
