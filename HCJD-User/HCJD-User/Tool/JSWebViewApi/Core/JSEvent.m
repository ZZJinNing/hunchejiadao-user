//
//  JSEvent.m
//  WebViewApi
//
//  Created by jiang on 16/12/19.
//  Copyright © 2016年 com.meiniucn. All rights reserved.
//

#import "JSEvent.h"


@interface JSEvent()
{
    FnDictionary* _fnDic;
    
}
@end

@implementation JSEvent

- (id)initSetSuperController:(UIViewController*)superC withWebView:(UIWebView *)webView
{
    self = [super init];
    if (self) {
        _fnDic = [FnDictionary new];
        self.superController = superC;
        self.webView = webView;
    }
    return self;
}

// json to dic
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                               options:NSJSONReadingMutableContainers
                                                                 error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    
    return dic;
    
}

- (void)listenCallBack:(NSDictionary*) dic
{
    NSDictionary *fndic = [_fnDic getModel:dic[@"id"]];
    
    for (NSString *key in fndic) {
        NSString *fn = fndic[key];
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@('%@')", fn, dic[@"data"]]];
    }
}

- (void)listen:(NSString *)data
{
    NSDictionary *dic = [self dictionaryWithJsonString:data];
    NSString *channelId = [NSString stringWithFormat:@"MN_WEBVIEWAPI_%@", dic[@"id"]];
    [_fnDic add:channelId value:dic[@"onSuccess"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenCallBack:) name:channelId object:nil];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)publish:(NSString *)data
{
    NSDictionary *dic = [self dictionaryWithJsonString:data];
    NSString *channelId = [NSString stringWithFormat:@"MN_WEBVIEWAPI_%@", dic[@"id"]];
    NSMutableDictionary *mdic = [NSMutableDictionary new];
    [mdic setObject:channelId forKey:@"id"];
    [mdic setObject:dic[@"data"] forKey:@"data"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:channelId object:mdic];
}


@end







