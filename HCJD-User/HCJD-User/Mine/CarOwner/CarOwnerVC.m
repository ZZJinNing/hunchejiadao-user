//
//  CarOwnerVC.m
//  HCJD-User
//
//  Created by ZhangZi Long on 17/1/5.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import "CarOwnerVC.h"

@interface CarOwnerVC ()

@end

@implementation CarOwnerVC

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"车主登录";
    
    UIWebView *_webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    NSMutableString *URL = [NSMutableString stringWithFormat:@"%@",@"http://test.m.hunchejiadao.com/ApiDriverWeb/registerNewOne"];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    //_webView.delegate = self;
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
