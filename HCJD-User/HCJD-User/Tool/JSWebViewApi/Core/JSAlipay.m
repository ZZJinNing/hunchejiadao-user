//
//  JSAlipay.m
//  marriedCarComeIng
//
//  Created by jiang on 16/12/20.
//  Copyright © 2016年 com.meiniu. All rights reserved.
//

#import "JSAlipay.h"
#import <AlipaySDK/AlipaySDK.h>

@interface JSAlipay()
{
    FnDictionary* _fnDic;
    
}
@end

@implementation JSAlipay

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

// 支付
- (void)pay:(NSString*) data
{
    NSDictionary *dic = [self dictionaryWithJsonString:data];
    self.MYDic = dic;
    
    NSString *orderString = dic[@"order"];
    NSLog(@"%@", orderString);
    NSString *indexPay = [_fnDic add:@"alipay_pay" value:dic[@"onSuccess"]];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getNotification:) name:@"MN_notificationAlipay" object:nil];
    
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"hunchejiadaodriver" callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        NSInteger resultStatus = [resultDic[@"resultStatus"] integerValue];
        NSString *info = @"NULL";
        NSString *status = @"NULL";
        
        if (resultStatus == 9000) {
            status = @"OK";
            info = @"支付成功";
        }else if (resultStatus == 8000){
            status = @"PROCESSING";
            info = @"正在处理中";
        }else if (resultStatus == 4000){
            status = @"FAIL";
            info = @"订单支付失败";
        }else if (resultStatus == 6001){
            status = @"CANCEL";
            info = @"用户中途取消";
        }else if (resultStatus == 6002){
            status = @"ERROR";
            info = @"网络连接错误";
        }
        
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@('%@','%@')", [_fnDic getFn:@"alipay_pay" andindex:indexPay], status, info]];
        
    }];
    
    
}


- (void)getNotification:(NSNotification*)notfication{
    
    NSString *MYresultStatus = notfication.userInfo[@"status"];
    NSInteger resultStatus = [MYresultStatus integerValue];
    NSString *indexPay = [_fnDic add:@"alipay_pay" value:self.MYDic[@"onSuccess"]];
    
    NSString *info = @"NULL";
    NSString *status = @"NULL";
    
    if (resultStatus == 9000) {
        status = @"OK";
        info = @"支付成功";
    }else if (resultStatus == 8000){
        status = @"PROCESSING";
        info = @"正在处理中";
    }else if (resultStatus == 4000){
        status = @"FAIL";
        info = @"订单支付失败";
    }else if (resultStatus == 6001){
        status = @"CANCEL";
        info = @"用户中途取消";
    }else if (resultStatus == 6002){
        status = @"ERROR";
        info = @"网络连接错误";
    }
    
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@('%@','%@')", [_fnDic getFn:@"alipay_pay" andindex:indexPay], status, info]];
    
    
}
/*
 千万不要忘记了在注册观察者通知的控制器dealloc方法中移除要观察的通知
 */
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:@"MN_notificationAlipay"];
}


@end
