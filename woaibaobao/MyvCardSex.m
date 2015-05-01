//
//  MyvCardSex.m
//  woaibaobao
//
//  Created by 梁建 on 14/10/26.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import "MyvCardSex.h"

@interface MyvCardSex ()
@property (strong, nonatomic) UIImageView *manCheckMark;
@property (strong, nonatomic) UIImageView *womanCheckMark;
@property (strong, nonatomic) UITableView *tableView;
@end



@implementation MyvCardSex

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
       
    }
    return self;
}


-(void)loadView{
    [super loadView];
    
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    _manCheckMark=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"checkmark"]];
    _manCheckMark.frame=CGRectMake(180, 10, 40, 40);
    _womanCheckMark=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"checkmark"]];
    _womanCheckMark.frame=CGRectMake(180, 10, 40, 40);
    [self loadTableView];
    [self setupSex];
}











- (void)setupSex
{
    if (_sex)
    {
        if ([_sex isEqualToString:@"男"])
        {
            _womanCheckMark.hidden = YES;
        }
        else
        {
            _manCheckMark.hidden = YES;
        }
    }
    else
    {
        _manCheckMark.hidden = YES;
        _womanCheckMark.hidden = YES;
    }
}

-(void)loadTableView
{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-28) style:UITableViewStyleGrouped];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.userInteractionEnabled=YES;
   
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [_delegate didSelectMan:YES];
    }
    else
    {
        [_delegate didSelectMan:NO];
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60.0;
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (indexPath.row==0) {
        cell.textLabel.text=@"男";
        [cell.contentView addSubview:self.manCheckMark];
    }
    if (indexPath.row==1)
    {
        cell.textLabel.text=@"女";
        [cell.contentView addSubview:self.womanCheckMark];
        
    }
    
    
    
    return cell;
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    
    
    return 1;
}




@end
