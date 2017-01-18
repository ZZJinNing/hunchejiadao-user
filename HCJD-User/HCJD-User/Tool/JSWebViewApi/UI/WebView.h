//
//  WebView.h
//  webViewApi
//
//  Created by jiang on 16/12/5.
//  Copyright © 2016年 com.meiniucn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface WebView : NSObject<UIWebViewDelegate>

// 初始化
- (instancetype)initWithFrame:(UIViewController*) viewController with:(CGRect) cgrect;

// GET请求
- (void)loadUrl:(NSString*) url;
// POST请求
- (void)loadUrl:(NSString*) url withparam:(NSString*) param;

- (void)goBack;

- (void)webViewDidStartLoad:(UIWebView *)webView;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

@end
