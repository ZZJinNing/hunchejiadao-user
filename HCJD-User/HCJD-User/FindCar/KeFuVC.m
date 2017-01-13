//
//  KeFuVC.m
//  HCJD-User
//
//  Created by ZhangZi Long on 17/1/5.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import "KeFuVC.h"

@interface KeFuVC ()

@end

@implementation KeFuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"客服";
    
    UIWebView *_webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    NSMutableString *URL = [NSMutableString stringWithFormat:@"%@",@"https://www.baidu.com"];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    //    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    [_webView loadRequest:request];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
