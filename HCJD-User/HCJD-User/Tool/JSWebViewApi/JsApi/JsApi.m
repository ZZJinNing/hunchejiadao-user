//
//  JsApi.m
//  webViewApi
//
//  Created by jiang on 16/12/5.
//  Copyright © 2016年 com.meiniucn. All rights reserved.
//

#import "JsApi.h"
#import "Camera.h"
#import "Dialog.h"

@interface JsApi()

@property (nonatomic)FnDictionary* fnDic;
@property (nonatomic)Camera* camera;
@property (nonatomic)Dialog* dialog;


@end

@implementation JsApi

- (id)initSetSuperController:(UIViewController*)superC withWebView:(UIWebView *)webView
{
    self = [super init];
    if (self) {
        self.superController = superC;
        self.webView = webView;
        self.fnDic = [FnDictionary new];
        self.camera = [[Camera alloc]initSetSuperController:self.superController withWebView:self.webView with:self.fnDic];
        self.dialog = [[Dialog alloc]initSetSuperController:self.superController withWebView:self.webView];
    }
    return self;
}

//===================多媒体==================================
//================相机  相册==================================
//==========================================================
- (void)getPicture:(NSString *)choosePhotos{
    
    [self.fnDic add:@"camera" value:choosePhotos];
    
    NSMutableArray *tary = [NSMutableArray new];
    
   
    //添加拍照按钮，判断是否支持摄像头
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIAlertAction * cameraAction=[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.camera open];
        }];
        [tary addObject:cameraAction];
    }
    
    //从相册获取
    UIAlertAction * photoAction=[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.camera openPhotoAlbum];
    }];
    [tary addObject:photoAction];

    
    
    
    //取消 按钮
    UIAlertAction * cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [tary addObject:cancelAction];
    
    [self.dialog actionSheet:@"选择照片来源" with:tary];
}



//==========================================================
//================ UI组件 ===================================
//==========================================================


//==========================================================
//=================  弹出视图 ===============================
//==========================================================
/**
 弹出消息
 @param msg JS方法名
 */
- (void)toast:(NSString *)msg {
    [self.dialog toast:msg];
}

- (void)showWaitting:(NSString *)msg{
    [self.dialog showWaitting:msg];
}

/**
 关闭消息
 */
- (void)closeWaitting{
    [self.dialog closeWaitting];
}





@end


















