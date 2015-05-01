//
//  MainViewController.h
//  woaibaobao
//
//  Created by 梁建 on 14/10/15.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface MainViewController : UITabBarController<UINavigationControllerDelegate>
{
@private
   
    UIView *_tabarbg;
    UIImageView *_selectView;
    NSArray *_titles;
    NSArray *imgs2;
    UIImageView *item;
    
    
}


@property(nonatomic,retain)UIButton *selectedBtn;

-(void)showTabbar:(BOOL)isShow;
@end
