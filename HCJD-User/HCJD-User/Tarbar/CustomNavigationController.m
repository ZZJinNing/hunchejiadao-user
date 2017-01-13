//
//  CustomNavigationController.m
//  TabBar
//
//  Created by ZhangZi Long on 16/11/25.
//  Copyright © 2016年 JinNing. All rights reserved.
//

#import "CustomNavigationController.h"

@interface CustomNavigationController ()
@property(nonatomic,assign)BOOL canPush;//处理同一界面可多次push的问题
@end

@implementation CustomNavigationController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.translucent = NO;//设置tabbar是否透明
    
    //设置导航栏title的颜色
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    
    //设置自定义导航栏的背景颜色,通过RGB展示
    self.navigationBar.barTintColor = kRGBA(249, 30, 51, 1);
    
    
    
    //设置导航栏按钮和文字的颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    //处理同一界面可多次push的问题
    if (self.canPush) {
        return;
    }
    self.canPush = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:1];
        self.canPush = NO;
    });
    
    
    if (self.viewControllers.count > 0 ) {
        //当导航控制器跳转时隐藏tabbar
        viewController.hidesBottomBarWhenPushed=YES;
        
    }
    //设置返回按钮的文字
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:@"点我返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    //重置导航栏返回按钮
    viewController.navigationItem.backBarButtonItem = left;
    
    [super pushViewController:viewController animated:YES];
}
- (void)back{
    [self popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
