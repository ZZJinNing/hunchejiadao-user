//
//  Dialog.m
//  webViewApi
//
//  Created by jiang on 16/12/5.
//  Copyright © 2016年 com.meiniucn. All rights reserved.
//

#import "Dialog.h"
#import "MBProgressHUD+Add.h"

@implementation Dialog

- (id)initSetSuperController:(UIViewController*)superC withWebView:(UIWebView *)webView
{
    self = [super init];
    if (self) {
        self.superController = superC;
        self.webView = webView;
    }
    return self;
}


- (void)actionSheet:(NSString*)title with:(NSMutableArray*)actions {
    //操作列表
    UIAlertController * alertControler=[UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (UIAlertAction *action in actions) {
        [alertControler addAction:action];
    }
    
    //弹出操作表
    [self.superController presentViewController:alertControler animated:YES completion:nil];
}


//=======================================================
//=============== UI组件 =================================
//=======================================================

//=======================================================
//================= 弹出视图 ==============================
//=======================================================
- (void)toast:(NSString *)msg {
    [MBProgressHUD showSuccess:msg toView:self.superController.view];
}

- (void)showWaitting:(NSString *)msg{
    [MBProgressHUD showMessag:msg toView:self.superController.view];
}

- (void)closeWaitting{
    [MBProgressHUD hideHUDForView:self.superController.view animated:YES];
}


@end














