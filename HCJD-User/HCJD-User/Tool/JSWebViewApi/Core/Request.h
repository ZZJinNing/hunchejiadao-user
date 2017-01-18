//
//  Request.h
//  WebViewApi
//
//  Created by jiang on 16/12/14.
//  Copyright © 2016年 com.meiniucn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <CoreLocation/CoreLocation.h>
#import "FnDictionary.h"

@protocol RequestProtocol <JSExport>

// 上传
- (void)upload:(NSString*) data;

@end

@interface Request : NSObject<RequestProtocol, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

// 当前Controller
@property (nonatomic,weak)UIViewController *superController;
// 当前WebView
@property (nonatomic,strong)UIWebView *webView;
// 初始化
- (id)initSetSuperController:(UIViewController*)superC withWebView:(UIWebView*)webView;

@end
