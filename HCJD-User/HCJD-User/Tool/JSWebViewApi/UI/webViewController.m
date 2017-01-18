//
//  webViewController.m
//  marriedCarComeIng
//
//  Created by jiang on 16/12/15.
//  Copyright © 2016年 com.meiniu. All rights reserved.
//

#import "webViewController.h"
#import "WebView.h"
#import "WYWebProgressLayer.h"
#import "UIView+Frame.h"
#import "LoginVC.h"

#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface webViewController ()
{
    WebView *_JSwebView;
    WYWebProgressLayer *_progressLayer; ///< 网页加载进度条
}
@end

@implementation webViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (self.url.length < 1) {
         [MBProgressHUD showSuccess:@"亲，网络开小差啦" toView:self.view];
    }
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem * item1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"jiantou.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    self.navigationItem.leftBarButtonItems = @[item1,item2];
    self.navigationItem.leftBarButtonItems[0].tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItems[1].tintColor = [UIColor whiteColor];
    
    _progressLayer = [WYWebProgressLayer new];
    _progressLayer.frame = CGRectMake(0, 41, SCREEN_WIDTH, 1);
    [self.navigationController.navigationBar.layer addSublayer:_progressLayer];
    
    
    
    
    
    _JSwebView = [[WebView alloc]initWithFrame:self with:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT - 64)];
    
    NSString *password = [[NSUserDefaults standardUserDefaults]objectForKey:HCJDPassword];
    NSString *phone = [[NSUserDefaults standardUserDefaults]objectForKey:HCJDPhone];
    NSString *param = [NSString stringWithFormat:@"_account=%@&_password=%@",phone,password];
    
    [_JSwebView loadUrl:self.url withparam:param];
    
    [self broadCastUserExit];
    [self broadCastWebViewExit];
    
}

- (void)back{
    
    [_JSwebView goBack];
}

- (void)close{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startProgress{
    _progressLayer = [WYWebProgressLayer new];
    _progressLayer.frame = CGRectMake(0, 41, SCREEN_WIDTH, 1);
    [self.navigationController.navigationBar.layer addSublayer:_progressLayer];
    
}

#pragma mark - 网页加载事件
//32.webView加载开始的时候调用。
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self startProgress];
    
    [_JSwebView webViewDidStartLoad:webView];
    self.title = @"加载中...";
    [_progressLayer startLoad];
    
}

//33.webView加载完毕的时候调用。
- (void)webViewDidFinishLoad:(UIWebView *)webView{
   
    [_JSwebView webViewDidFinishLoad:webView];
    [_progressLayer finishedLoad];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if ([title isEqualToString:@"找不到网页"]) {
        [MBProgressHUD showSuccess:@"亲，网络开小差啦" toView:self.view];
    }
    
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_JSwebView webView:webView didFailLoadWithError:error];
    self.title = @"加载失败";
    
    [_progressLayer finishedLoad];
    [_progressLayer removeFromSuperlayer];
}

- (void)dealloc {
    
    [_progressLayer closeTimer];
    [_progressLayer removeFromSuperlayer];
    _progressLayer = nil;
    
}

- (void)broadCastWebViewExit
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webViewBroadCastExit) name:@"MN_WEBVIEWAPI_CLOSE" object:nil];
}

- (void)webViewBroadCastExit
{
    [self close];
}

- (void)broadCastUserExit
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userBroadCastExit) name:@"MN_WEBVIEWAPI_EXIT" object:nil];
}

- (void)userBroadCastExit
{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:HCJDPassword];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:HCJDPhone];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:HCJDName];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:HCJDPhoto];
    
    
    LoginVC *vc = [[LoginVC alloc]init];
    vc.view.backgroundColor = grayBG;
    [self presentViewController:vc animated:YES completion:nil];
    
}


@end












