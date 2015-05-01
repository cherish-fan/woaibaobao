//
//  FacialLable.h
//  FaceChatDemo
//
//  Created by Acer on 14-4-18.
//
//

#import <UIKit/UIKit.h>

#define BEGIN_FLAG          @"["
#define END_FLAG            @"]"
#define KFacialSizeWidth    30
#define KFacialSizeHeight   30
#define KTextFontSize       15
#define MAX_WIDTH           200

@interface FacialLable : UIView

@property (strong, nonatomic) NSString *text;

@end