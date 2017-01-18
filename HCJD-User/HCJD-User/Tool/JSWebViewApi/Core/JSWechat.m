//
//  JSWechat.m
//  marriedCarComeIng
//
//  Created by jiang on 16/12/21.
//  Copyright © 2016年 com.meiniu. All rights reserved.
//

#import "JSWechat.h"
#import "WXApi.h"

@interface JSWechat()
{
    FnDictionary* _fnDic;
    // 分享回调名称index
    NSString *_indexShare;
}
@end

@implementation JSWechat

- (id)initSetSuperController:(UIViewController*)superC withWebView:(UIWebView *)webView
{
    self = [super init];
    if (self) {
        _fnDic = [FnDictionary new];
        self.superController = superC;
        self.webView = webView;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onShareResp:) name:@"mn_wechat_onresp" object:nil];
        
        
    }
    return self;
}

/*
 千万不要忘记了在注册观察者通知的控制器dealloc方法中移除要观察的通知
 */
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:@"notification"];
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

-(void) onShareResp:(NSNotification*)notfication{
    BaseResp *resp = notfication.userInfo[@"aaa"];
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    
    NSString *status = @"NULL";
    NSString *info = @"NULL";
    
    if([@"0" isEqualToString:strMsg]) {
        status = @"OK";
        info = @"分享成功";
    }else if([@"-1" isEqualToString:strMsg]) {
        status = @"ERROR";
        info = @"分享错误";
    }else if([@"-2" isEqualToString:strMsg]) {
        status = @"CANCEL";
        info = @"用户取消";
    }else if([@"-3" isEqualToString:strMsg]) {
        status = @"FAIL";
        info = @"分享失败";
    }else if([@"-4" isEqualToString:strMsg]) {
        status = @"AUTH_DENY";
        info = @"授权失败";
    }else if([@"-5" isEqualToString:strMsg]) {
        status = @"UNSUPORT";
        info = @"微信版本不支持";
    }
    
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@('%@','%@')", [_fnDic getFn:@"wechat_share" andindex:_indexShare], status, info]];
}

- (void)share:(NSString *)data
{
    NSDictionary *dic = [self dictionaryWithJsonString:data];
    _indexShare = [_fnDic add:@"wechat_share" value:dic[@"onSuccess"]];
  
    if([@"text" isEqualToString:dic[@"type"]])
    {
        [self shareTxt:dic[@"content"] withWXScene:WXSceneTimeline];
    }else if ([@"url" isEqualToString:dic[@"type"]])
    {
        [self shareUrl:dic[@"title"] withcontent:dic[@"content"] withicon:dic[@"icon"] withurl:dic[@"url"] withWXScene:WXSceneTimeline];
    }
    
    
}

// 文字类型
- (void)shareTxt:(NSString *) content withWXScene:(int) wxScene
{
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.text = content;
    req.bText = YES;
    req.scene = wxScene;
    [WXApi sendReq:req];
}

// 图片类型
- (void)shareImage
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@""]];
    // 缩略图
    WXImageObject *imageObject = [WXImageObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res1" ofType:@"jpg"];
    imageObject.imageData = [NSData dataWithContentsOfFile:filePath];
    message.mediaObject = imageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.message = message;
    req.bText = NO;
    req.scene = WXSceneTimeline;
    [WXApi sendReq:req];
}

// 网页类型
- (void)shareUrl:(NSString*) title withcontent:(NSString*) content withicon:(NSString*) icon withurl:(NSString*) url withWXScene:(int) wxScene
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = content;
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:icon]];
    UIImage *image = [UIImage imageWithData:data];
    if (!image) {
        image = [UIImage imageNamed:@""];
    }
    [message setThumbImage:image];
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = url;
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.message = message;
    req.bText = NO;
    req.scene = wxScene;
    [WXApi sendReq:req];
}

//=====================================================
// 支付
- (void)pay:(NSString*) data
{
    NSDictionary *dic = [self dictionaryWithJsonString:data];
    
    PayReq *request = [[PayReq alloc] init] ;
    request.partnerId = dic[@"partnerId"];
    request.prepayId= dic[@"prepayId"];
    request.package = dic[@"package"];
    request.nonceStr= dic[@"nonceStr"];
    
    NSDate *senddate = [NSDate date];
    UInt32 dateStamp = [senddate timeIntervalSince1970];
    request.timeStamp = dateStamp;
    request.sign= dic[@"sign"];
    [WXApi sendReq:request];
    

    
}


-(void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        
        PayResp *response = (PayResp*)resp;
        switch(response.errCode){
            caseWXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"成功");
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
    }
}

@end
