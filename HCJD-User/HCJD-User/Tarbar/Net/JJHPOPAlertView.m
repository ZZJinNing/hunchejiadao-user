//
//  JJHPOPAlertView.m
//  marriedCarComeIng
//
//  Created by jiang on 16/12/7.
//  Copyright © 2016年 com.meiniu. All rights reserved.
//

#import "JJHPOPAlertView.h"
#import "LoginVC.h"


@implementation JJHPOPAlertView


- (id)initWithSuperView:(UIViewController*)superController withCode:(NSString *)code
{
    self = [super init];
    if (self) {
        self.superController = superController;
        self.code = code;
    }
    return self;
}


- (void)popView{
    
    if ([self.code isEqualToString:@"login"]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"请登录" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:HCJDPassword];
            LoginVC *vc = [[LoginVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.superController.navigationController
             pushViewController:vc animated:YES];
           
            }]];
        
        [self.superController presentViewController:alert animated:YES completion:nil];
    }
    
}






@end


















