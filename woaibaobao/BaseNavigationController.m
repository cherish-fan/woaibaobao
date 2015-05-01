//
//  BaseNavigationController.m
//  woaibaobao
//
//  Created by 梁建 on 14/10/15.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    //[self.navigationBar setBackgroundColor:[UIColor colorWithRed:72.0/255.0 green:116.0/255.0 blue:199.0/255.0 alpha:1.0]];
    //self.navigationBar.barTintColor=[UIColor colorWithRed:54.0/255.0 green:127.0/255.0 blue:169.0/255.0 alpha:1.0];
    UISwipeGestureRecognizer *swipGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipAction:)];
    swipGesture.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipGesture];
    
    [self.navigationItem setHidesBackButton:YES];
    
    self.navigationItem.backBarButtonItem.tintColor=[UIColor whiteColor];
     
    
    
    
    
    
    
    
    
    
    
}


#pragma mark-Actions
//为所有视图添加右滑手势
-(void)swipAction:(UISwipeGestureRecognizer *)Gesture
{
    if (self.viewControllers.count>1) {
        if (Gesture.direction==UISwipeGestureRecognizerDirectionRight) {
            [self popViewControllerAnimated:YES];
        }
    }
    
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

@end
