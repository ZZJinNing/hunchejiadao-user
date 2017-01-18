//
//  JsApi.h
//  webViewApi
//
//  Created by jiang on 16/12/5.
//  Copyright © 2016年 com.meiniucn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <CoreLocation/CoreLocation.h>
#import "FnDictionary.h"

@protocol JsApiProtocol <JSExport>

// 参数choosePhotos JS打开选择相册的方法名，该方法在底部弹出相册、打开相机，取消按钮。该方法的目的就是JS调用OC的打开相册
- (void)getPicture:(NSString *)choosePhotos;

// 开启位置监听
//- (void) startLocation:(NSString*)fnstartLocation;

//弹出消息   参数：参数msg JS方法名
- (void)toast:(NSString *)msg;


- (void)showWaitting:(NSString *)msg;

//关闭消息
-(void)closeWaitting;


@end


@interface JsApi : NSObject<UINavigationControllerDelegate, UIImagePickerControllerDelegate, JsApiProtocol,CLLocationManagerDelegate>

// 当前Controller
@property (nonatomic,weak)UIViewController *superController;

// 当前WebView
@property (nonatomic,strong)UIWebView *webView;

// 初始化
- (id)initSetSuperController:(UIViewController*)superC withWebView:(UIWebView*)webView;


@end
