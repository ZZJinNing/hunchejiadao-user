//
//  Camera.h
//  webViewApi
//
//  Created by jiang on 16/12/5.
//  Copyright © 2016年 com.meiniucn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FnDictionary.h"

@interface Camera : NSObject<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

// 当前Controller
@property (nonatomic,weak)UIViewController *superController;

// 当前WebView
@property (nonatomic,strong)UIWebView *webView;

// 初始化
- (id)initSetSuperController:(UIViewController*)superC withWebView:(UIWebView*)webView with:(FnDictionary*) dic;

// 打开相机
- (void)open;
/**
 打开相册
 */
- (void)openPhotoAlbum;



@end
