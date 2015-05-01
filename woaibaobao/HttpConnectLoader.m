//
//  HttpConnectLoader.m
//  woaibaobao
//
//  Created by 梁建 on 14/10/17.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import "HttpConnectLoader.h"
#import "JSONKit.h"
@implementation HttpConnectLoader
//调用ASIHttpRequest请求网络,这个类包装了ASIHttpRequest

/*
 *发送post请求的公共方法
 *@parame url      请求地址
 *@parame delegate 实现ASIHttpRequest委托的对象
 *@parame tag      ASIHttpRequest请求的标识
 *@parame value    接口需要的参数，其中key是参数名，value是参数值
 *@parame dic      需要上传到服务器的文件名和地址，其中key是服务器需要的文件名，value是文件的本地路径，可为空
 */



+ (void)loadInBackgroundWithUrl:(NSString *)url setDelegate:(id <ASIHTTPRequestDelegate>)delegate setID:(int)tag setParams:(NSDictionary *)paramsDic setFiles:(NSDictionary *)dic{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[@"" stringByAppendingString:url]]];
    [request setTimeOutSeconds:dic ? 60.0 : 10.0];
    [request setDelegate:delegate];
    [request setTag:tag];
    if (dic)
    {
        for (NSString *key in [dic allKeys])
        {
            [request setFile:[dic objectForKey:key] forKey:key];
            NSLog(@"file is %@ and key is %@", [dic objectForKey:key], key);
        }
    }
    if (paramsDic)
    {
        for (NSString *key in [paramsDic allKeys])
        {
            [request setPostValue:[paramsDic objectForKey:key] forKey:key];
        }
    }
    //开始异步请求
    [request startAsynchronous];
}










@end
