//
//  ChatViewController.h
//  woaibaobao
//
//  Created by 梁建 on 14/10/18.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"
#import "XMPPUtils.h"



@interface ChatViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,UIBubbleTableViewDataSource,xmppMessageDelegate>
{
  UITableView *_listView;  
    
}

@property (nonatomic,strong) NSString *chatName;
@property (nonatomic,strong) NSData *chatWithAvatar;
@property (nonatomic,strong) NSData *myAvatar;
@property (strong, nonatomic) UIBubbleTableView *bubbleTable;

@property (nonatomic,strong) XMPPUtils *sharedXMPP;




//这四个bool形的变量是干嘛的呢
@property (nonatomic) BOOL isKey;
@property (nonatomic) BOOL isNear;
@property (nonatomic) BOOL isMap;
@property (nonatomic) BOOL isQun;

@property (nonatomic,assign) BOOL isVocie;
@property (nonatomic,assign) BOOL isFace;
@property(nonatomic,retain) UITableView *tableView;
//文本输入框，声音输入按钮图片按钮等的父视图
@property(nonatomic,strong) UIView *toolView;
@property(strong,nonatomic) UIImageView *toolViewbg;
//聊天消息文本输入框
@property(strong,nonatomic) UITextField *messageField;
//表情父视图
@property(strong,nonatomic) UIScrollView *faceView;
//输入框右边声音录音按钮
@property(strong,nonatomic) UIButton *btnVideo;
//输入框右边加号按钮
@property(strong,nonatomic) UIButton *btnAdd;
//输入框右边表情按钮
@property(strong,nonatomic) UIButton *btnFace;


//发送位置,图片,等按钮的父视图
@property(strong,nonatomic) UIView *videoView;
//发送图片按钮
@property(strong,nonatomic) UIButton *btn_picture;
//拍照发送图片按钮
@property(strong,nonatomic) UIButton *btn_takephoto;
//发送位置按钮
@property(strong,nonatomic) UIButton *btn_place;
//发送作业按钮
@property(strong,nonatomic) UIButton *btn_homework;

//开始录音按钮
@property(strong,nonatomic) UIButton *btn_voice;
//发送按钮
@property(strong,nonatomic) UIButton *btn_send;
//取消按钮
@property(strong,nonatomic) UIButton *btn_cancel;


-(void)btnAddAction;
-(void)btnVideoAction;
-(void)btn_sendAction;
-(void)btn_pictureAction;
-(void)btn_takePhotoAction;
-(void)btn_placeAction;
-(void)btn_faceAction;
-(void)btn_homeWorkAction;





@end
