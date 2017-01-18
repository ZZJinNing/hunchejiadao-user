//
//  Camera.m
//  webViewApi
//
//  Created by jiang on 16/12/5.
//  Copyright © 2016年 com.meiniucn. All rights reserved.
//

#import "Camera.h"

@interface Camera()

@property (nonatomic)NSString *path;

@property (nonatomic)FnDictionary *fndic;

@end

@implementation Camera

- (id)initSetSuperController:(UIViewController*)superC withWebView:(UIWebView *)webView with:(FnDictionary*) dic
{
    self = [super init];
    if (self) {
        self.superController = superC;
        self.webView = webView;
        self.fndic = dic;
    }
    return self;
}

- (void)open{
    //添加拍照按钮，判断是否支持摄像头
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [self showImagePickerController:UIImagePickerControllerSourceTypeCamera];
    }else{
        return;
    }
}

/**
 打开相册
 */
- (void)openPhotoAlbum{
     [self showImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
}



-(void)showImagePickerController:(UIImagePickerControllerSourceType)sourceType {
    //创建
    UIImagePickerController * pickerController=[[UIImagePickerController alloc]init];
    //设置代理
    pickerController.delegate = self;
    //设置是否允许编辑
    pickerController.allowsEditing = YES;
    //设置图片来源
    pickerController.sourceType = sourceType;
    
    //推出
    [self.superController presentViewController:pickerController animated:YES completion:nil];
}


#pragma mark - UIImagePickerController代理方法 -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    self.path = info[@"UIImagePickerControllerReferenceURL"];
    
    NSDictionary *dic = [self.fndic getModel:@"camera"];
    
    for (NSString *key in dic) {
        NSString *fn = dic[key];
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@('%@')", fn, self.path]];
    }
    
    [self.fndic removeModel:@"camera"];
    
    //消失
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
