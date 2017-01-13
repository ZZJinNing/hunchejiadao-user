//
//  TarbarViewController.m
//  TabBar
//
//  Created by ZhangZi Long on 16/11/25.
//  Copyright © 2016年 JinNing. All rights reserved.
//

#import "TarbarViewController.h"
#import "CustomNavigationController.h"
#import "HomeVC.h"
#import "FindCarVC.h"
#import "MineVC.h"


@interface TarbarViewController ()

@end

@implementation TarbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    HomeVC *first = [[HomeVC alloc]init];
    [self setupChildVC:first withChildVCTitle:@"首页" withNormalImage:@"icon_sy_nor" withSelectedImage:@"icon_sy_red"];
    
    FindCarVC *second = [[FindCarVC alloc]init];
    [self setupChildVC:second withChildVCTitle:@"找婚车" withNormalImage:@"icon_z_nor" withSelectedImage:@"icon_zhc_red"];
    
    MineVC *third = [[MineVC alloc]init];
    [self setupChildVC:third withChildVCTitle:@"我的" withNormalImage:@"icon_w_nor" withSelectedImage:@"icon_w_red"];
    
    //设置tarbar字体的颜色（UIControlState）
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor], NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
    
}

- (void)setupChildVC:(UIViewController *)vc withChildVCTitle:(NSString *)title withNormalImage:(NSString *)normalImageName withSelectedImage:(NSString *)selectedImageName{
    
    
        vc.view.backgroundColor = kRGBA(243, 243, 243, 1);
        //tabbar上边显示的名字
        vc.tabBarItem.title = title;
        
        //nav上边显示的名字
//        vc.navigationItem.title = title;
        
        //tabbar正常状态下的图片
        vc.tabBarItem.image = [UIImage imageNamed:normalImageName];
        
        //tabbar选中状态下的图片
        vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    
    
        //设置tarbar选中图片的type（默认为蓝色）（UIImageRenderingMode）
        UIImage *selectImage =[UIImage imageNamed:selectedImageName];
        vc.tabBarItem.selectedImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        //使用图片作为导航栏标题
//        vc.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"contentview_hd_loading_logo"]];
        
        //设置导航栏图标大小
        vc.navigationItem.titleView.frame = CGRectMake(0, 0, 100, 100);
        
        //通过根视图的改变，改变nav所展示的VC
        CustomNavigationController *nav = [[CustomNavigationController alloc]initWithRootViewController:vc];
        
        //设置自定义导航栏的背景颜色，通过图片展示
//        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_navigation_background"] forBarMetrics:UIBarMetricsDefault];
        
        
        
        [self addChildViewController:nav];
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
