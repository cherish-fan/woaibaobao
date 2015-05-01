//
//  XMLElement.m
//  iSdnu
//
//  Created by 梁建 on 14/8/12.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import "XMLElement.h"

@implementation XMLElement


@synthesize name,text,attributes,subElements,parent;


-(NSMutableArray *)subElements

{
    
    if(subElements == nil){
        
        subElements = [[NSMutableArray alloc]init];
        
    }
    
    return subElements;
    
}
















@end
