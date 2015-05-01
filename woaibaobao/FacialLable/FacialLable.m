//
//  FacialLable.m
//  FaceChatDemo
//
//  Created by Acer on 14-4-18.
//
//

#import "FacialLable.h"

#define KTextSizeValue      10

@implementation FacialLable

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setText:(NSString *)text {
    UIView *assembleView = [self assembleMessageAndFacial:text];
    CGRect selfRect = self.frame;
    selfRect.size = assembleView.bounds.size;
    [self setFrame:selfRect];
    [self removeAllSubviews];
    [self addSubview:assembleView];
}

- (void)removeAllSubviews {
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

- (UIView *)assembleMessageAndFacial:(NSString *)message {//图文混排
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [self handleMessage:message withArray:data];
    CGFloat upX = 0, upY = 0, X = 0, Y = 0;
    if (data) {
        for (int i = 0; i < [data count]; i++) {
            NSString *str = [data objectAtIndex:i];
            if ([str hasPrefix:BEGIN_FLAG] && [str hasSuffix:END_FLAG]) {//表情时进入，按表情/ImageView加入View
                if (upX >= MAX_WIDTH || upX + KFacialSizeHeight >= MAX_WIDTH) {
                    upY = upY + KFacialSizeHeight; Y = KFacialSizeHeight + Y;
                    upX = 0; X = MAX_WIDTH;
                }
                NSString *imgName = [str substringWithRange:NSMakeRange(1, str.length - 2)];
                UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgName]];
                [imgView setFrame:CGRectMake(upX, upY, KFacialSizeWidth, KFacialSizeHeight)];
                [returnView addSubview:imgView];
                upX = KFacialSizeWidth + upX;
                if (X < MAX_WIDTH) X = upX;
                if (Y == 0) Y = KFacialSizeHeight;
            } else {//文字时进入，按文字/Lable加入View
                for (int j = 0; j < [str length]; j++) {
                    NSString *temp = [str substringWithRange:NSMakeRange(j, 1)];
                    if (upX >= MAX_WIDTH || upX + KFacialSizeHeight >= MAX_WIDTH) {
                        upY = upY + KFacialSizeHeight; Y = KFacialSizeHeight + Y;
                        upX = 0; X = MAX_WIDTH;
                    }
                    UIFont *font = [UIFont systemFontOfSize:KTextFontSize];
                    CGSize size = [temp sizeWithFont:font constrainedToSize:CGSizeMake(MAX_WIDTH, KFacialSizeHeight)];
                    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(upX, upY, size.width, size.height)];
                    [lab setBackgroundColor:[UIColor clearColor]]; [lab setFont:font]; [lab setText:temp];
                    [returnView addSubview:lab];
                    upX = upX + size.width;
                    if (X < MAX_WIDTH) X = upX;
                    if (Y == 0) Y = KFacialSizeHeight;
                }
            }
        }
    }
    [returnView setFrame:CGRectMake(0, 0, X, Y)];//需要将该view的尺寸记下，方便以后使用
    return returnView;
}

- (void)handleMessage:(NSString *)message withArray:(NSMutableArray *)array {//拆分字符串
    NSRange beginRange = [message rangeOfString:BEGIN_FLAG];
    NSRange endRange = [message rangeOfString:END_FLAG];
    if (beginRange.length > 0 && endRange.length > 0) {//判断当前字符串是否还有表情的标志。
        NSUInteger beginLoc = beginRange.location, endLoc = endRange.location;
        if (beginRange.location > 0) {
            [array addObject:[message substringToIndex:beginRange.location]];
            [array addObject:[message substringWithRange:NSMakeRange(beginLoc, endLoc + 1 - beginLoc)]];
            [self handleMessage:[message substringFromIndex:endLoc + 1] withArray:array];
        } else {
            NSString *nextStr = [message substringWithRange:NSMakeRange(beginLoc, endLoc + 1 - beginLoc)];
            if (![nextStr isEqualToString:@""]) {//排除文字是 "" 的
                [array addObject:nextStr];
                [self handleMessage:[message substringFromIndex:endRange.location + 1] withArray:array];
            }
            return;
        }
    } else if (message != nil) {
        [array addObject:message];
    }
}
@end