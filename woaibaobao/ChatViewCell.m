//
//  ChatViewCell.m
//  woaibaobao
//
//  Created by 梁建 on 14/10/18.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import "ChatViewCell.h"

@implementation ChatViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
        
        
        
        [self _initSubviews];
        
    }
    return self;
}











- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)_initSubviews
{
    UIImageView *imgAvatar=[[UIImageView alloc]initWithFrame:CGRectZero];
    UIImageView *imgBg=[[UIImageView alloc]initWithFrame:CGRectZero];;
    FacialLable *txtMessage=[[FacialLable alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:imgAvatar];
    [imgBg addSubview:txtMessage];
    [self.contentView addSubview:txtMessage];
    
    
    
    
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    if (self.isOutgoing)
    {
        self.imgAvatar.frame=CGRectMake(270, 11, 40, 40);
        self.imgBg.frame=CGRectMake(205, 10, 60, 30);
        self.txtMessage.frame=CGRectMake(210, 15, 50, 20);
        
        
        
        
    }else{
        
        self.imgAvatar.frame=CGRectMake(10, 10, 40, 40);
        self.imgBg.frame=CGRectMake(55, 10, 60, 30);
        self.txtMessage.frame=CGRectMake(60, 15, 50, 20);
        
        
        
        
    }
    
    
    
    
}







@end
