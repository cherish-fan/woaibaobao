//
//  MainViewController.m
//  woaibaobao
//
//  Created by 梁建 on 14/10/15.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import "MainViewController.h"
#import "MessageViewController.h"
#import "CircleViewController.h"
#import "ClassViewController.h"
#import "PlaygroundViewController.h"
#import "MoreViewController.h"
#import "BaseNavigationController.h"
#import "UIViewExt.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        
        
        
        
        
        
        
        
    }
    return self;
}
















- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initViewController];
     self.tabBar.hidden=YES;
    [self _initTabarView];
    
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





//初始化子控制器
- (void)_initViewController
{
    MessageViewController *message=[[MessageViewController alloc]init];
    
    
    
    CircleViewController  *circle=[[CircleViewController alloc]init];
    ClassViewController   *class=[[ClassViewController alloc]init];
    PlaygroundViewController *playground=[[PlaygroundViewController alloc]init];
    MoreViewController    *more=[[MoreViewController alloc]init];
    NSArray *views=@[message,circle,class,playground,more];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:5];
    for (UIViewController *viewController in views)
    {
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:viewController];
        [viewControllers addObject:nav];
        nav.delegate=self;
        
    }
    
    self.viewControllers=viewControllers;
    
}


//  自定义tabbar
#pragma mark-UI
//调整高度
-(void)_resizeView:(BOOL)showTabbar
{
    for (UIView *subviews in self.view.subviews)
    {
        NSLog(@"%@",subviews);
        if ([subviews isKindOfClass:NSClassFromString(@"UITransitionView")])
        {
            if (showTabbar)
            {
                subviews.height=ScreenHeight-49-20;
            }else{
                subviews.height=ScreenHeight-20;
                
            }
        }
    }
    
}
-(void)_initTabarView
{
    
    _tabarbg=[[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-49,ScreenWidth ,49 )];
    _tabarbg.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"tbbg"]];

    [self.view addSubview:_tabarbg];
    NSArray *imgs=@[@"message_normal",@"circle_normal",@"class_normal",@"playground_normal",@"more_normal"];
    NSArray *heightimgs=@[@"message_heighted",@"circle_heighted",@"class_heighted",@"playground_heighted",@"more_heighted"];
  
    
    
    
    int y=0;
    UIButton *button=nil;
    for (int i=0; i<imgs.count; i++) {
        NSString *backImage = imgs[i];
        NSString *heightImage = heightimgs[i];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(y, 0, ScreenWidth/5, 49);
        button.tag = i;
        [button setImage:[UIImage imageNamed:backImage] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:heightImage] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [_tabarbg addSubview:button];
        y+=ScreenWidth/5;
        //设置刚进入时,第一个按钮为选中状态
        if (0 == i) {
            button.selected = YES;
            self.selectedBtn = button;  //设置该按钮为选中的按钮
        }
        
        
        
        
        
    }
    
   
    
    
    
    
    

    
}

- (void)selectedTab:(UIButton *)button {
    
    self.selectedBtn.selected=NO;
    button.selected=YES;
    self.selectedBtn=button;
    
    self.selectedIndex = button.tag;
   
}







//是否隐藏Tabbar
-(void)showTabbar:(BOOL)isShow
{
    [UIView animateWithDuration:0.2 animations:^{
        if (isShow) {
            _tabarbg.left=0;
        }else{
            _tabarbg.left=-ScreenWidth;
        }
    }];
    //[self _resizeView:isShow];
}

























#pragma mark-UInavigationControllerdelgate
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    //导航控制器的字控制器的个数
    NSUInteger conunt=navigationController.viewControllers.count;
    if (conunt==2)
    {
        [self showTabbar:NO];
    }else if(conunt==1)
    {
        [self showTabbar:YES];
    }
    
    
}
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    
    
    
}







@end
