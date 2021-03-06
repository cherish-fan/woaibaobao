//
//  XMLElement.h
//  iSdnu
//
//  Created by 梁建 on 14/8/12.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLElement : NSObject


// 标签名称

@property (nonatomic,strong) NSString *name;

// 标签的文本(注意在上一级标签和下一级标签之间室友文本的)

@property (nonatomic,strong) NSString *text;

// 标签的属性

@property (nonatomic,strong) NSDictionary *attributes;

// 子标签集合

@property (nonatomic,strong) NSMutableArray *subElements;

// 上一级标签

@property (nonatomic,strong) XMLElement *parent;











@end
