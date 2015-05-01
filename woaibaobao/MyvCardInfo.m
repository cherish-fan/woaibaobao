//
//  MyvCardInfo.m
//  woaibaobao
//
//  Created by 梁建 on 14/10/26.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import "MyvCardInfo.h"
#import "QSUtils.h"
@interface MyvCardInfo ()<UITextFieldDelegate>
@property(strong,nonatomic) UITextField *myIntroduce;
@end


@implementation MyvCardInfo

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myIntroduce=[[UITextField alloc]initWithFrame:CGRectMake(10, 100, 300, 50)];
    [self.view addSubview:self.myIntroduce];
    if (_introduce) {
        _myIntroduce.text = _introduce;
    }
    [_myIntroduce becomeFirstResponder];
    _myIntroduce.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark -UITextFieldDelegate methods
//- (void)textFieldDidEndEditing:(UITextField *)textField
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_myIntroduce resignFirstResponder];
    if ([QSUtils isEmpty:textField.text]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您没有写任何内容哦" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        [_delegate didEditIntroduce:textField.text];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}


@end
