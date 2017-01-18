//
//  JSEvent.h
//  WebViewApi
//
//  Created by jiang on 16/12/19.
//  Copyright © 2016年 com.meiniucn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <CoreLocation/CoreLocation.h>
#import "FnDictionary.h"

@protocol JSEventProtocol <JSExport>

// 广播监听
- (void)listen:(NSString*) data;
// 广播发布
- (void)publish:(NSString*) data;

@end

@interface JSEvent : NSObject<JSEventProtocol, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

// 当前Controller
@property (nonatomic,weak)UIViewController *superController;
// 当前WebView
@property (nonatomic,strong)UIWebView *webView;
// 初始化
- (id)initSetSuperController:(UIViewController*)superC withWebView:(UIWebView*)webView;

@end
