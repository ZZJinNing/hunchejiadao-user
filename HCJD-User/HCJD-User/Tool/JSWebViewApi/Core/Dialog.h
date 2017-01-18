//
//  Dialog.h
//  webViewApi
//
//  Created by jiang on 16/12/5.
//  Copyright © 2016年 com.meiniucn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Dialog : NSObject

// 当前Controller
@property (nonatomic,weak)UIViewController *superController;

// 当前WebView
@property (nonatomic,strong)UIWebView *webView;

// 初始化
- (id)initSetSuperController:(UIViewController*)superC withWebView:(UIWebView*)webView;

- (void)actionSheet:(NSString*)title with:(NSMutableArray*)actions;

- (void)toast:(NSString *)msg;

- (void)showWaitting:(NSString *)msg;

- (void)closeWaitting;

@end
