//
//  WebView.m
//  webViewApi
//
//  Created by jiang on 16/12/5.
//  Copyright © 2016年 com.meiniucn. All rights reserved.
//

#import "WebView.h"
#import "Request.h"
#import "JSEvent.h"
#import "JSAlipay.h"
#import "JSWechat.h"


@interface WebView()
{
    UIWebView *_webView;
    UIViewController *_viewController;
    
}

@end

@implementation WebView

- (instancetype)initWithFrame:(UIViewController*) viewController with:(CGRect) cgrect
{
    self = [super init];
    if (self) {
        _viewController = viewController;
        
        _webView = [[UIWebView alloc] initWithFrame:cgrect];
        _webView.delegate = _viewController;
        
        [_viewController.view addSubview: _webView];
        
        [self loadJS];
        
    }
    return self;
}

- (void)loadJS
{
    JSContext *context = [_webView  valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    Request *req = [[Request alloc]initSetSuperController:_viewController withWebView:_webView];
    context[@"_req"] = req;
    
    JSEvent *je = [[JSEvent alloc]initSetSuperController:_viewController withWebView:_webView];
    context[@"_event"] = je;
    
    JSAlipay *jsAplipay = [[JSAlipay alloc]initSetSuperController:_viewController withWebView:_webView];
    context[@"_alipay"] = jsAplipay;
    
    
    JSWechat *jsWechat = [[JSWechat alloc]initSetSuperController:_viewController withWebView:_webView];
    context[@"_wechat"] = jsWechat;
    
}

- (void)loadUrl:(NSString*) url{
//    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    [_webView loadRequest:request];
}

- (void)loadUrl:(NSString*) url withparam:(NSString*) param{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: [NSURL URLWithString:url]];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: [param dataUsingEncoding: NSUTF8StringEncoding]];
    [_webView loadRequest:request];
    
}

- (void)goBack{
    
    if (_webView.canGoBack) {
        [_webView goBack];
    }else{
         [_viewController.navigationController popViewControllerAnimated:YES];
    }
}

//32.webView加载开始的时候调用。
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

//33.webView加载完毕的时候调用。
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    //清除webView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    [self loadJS];
    NSString *newPath = [[NSBundle mainBundle] pathForResource:@"JSRequest" ofType:@"js"];
    NSString *str=[NSString stringWithContentsOfFile:newPath encoding:NSUTF8StringEncoding error:nil];
    
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@",str]];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
   
}

@end
