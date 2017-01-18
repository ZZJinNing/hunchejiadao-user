//
//  JSWechat.h
//  marriedCarComeIng
//
//  Created by jiang on 16/12/21.
//  Copyright © 2016年 com.meiniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <CoreLocation/CoreLocation.h>
#import "FnDictionary.h"

@protocol JSWechatProtocol <JSExport>

// 分享
- (void)share:(NSString*) data;

//支付
- (void)pay:(NSString*) data;

@end

@interface JSWechat : NSObject<JSWechatProtocol, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

// 当前Controller
@property (nonatomic,weak)UIViewController *superController;
// 当前WebView
@property (nonatomic,strong)UIWebView *webView;
// 初始化
- (id)initSetSuperController:(UIViewController*)superC withWebView:(UIWebView*)webView;

@end
