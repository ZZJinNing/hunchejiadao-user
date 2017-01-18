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
#import "JJHFoundViewController.h"


@interface TarbarViewController ()

@end

@implementation TarbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HomeVC *first = [[HomeVC alloc]init];
    [self setupChildVC:first withChildVCTitle:@"首页" withNormalImage:@"icon_sy_nor" withSelectedImage:@"icon_sy_red"];
    
    FindCarVC *second = [[FindCarVC alloc]init];
    [self setupChildVC:second withChildVCTitle:@"找婚车" withNormalImage:@"icon_z_nor" withSelectedImage:@"icon_zhc_red"];
    
    MineVC *third = [[MineVC alloc]init];
    [self setupChildVC:third withChildVCTitle:@"我的" withNormalImage:@"icon_w_nor" withSelectedImage:@"icon_w_red"];
    
    JJHFoundViewController *forth = [[JJHFoundViewController alloc]init];
    [self setupChildVC:forth withChildVCTitle:@"发现" withNormalImage:@"icon_find_nor" withSelectedImage:@"icon_find_red"];
    
    //设置tarbar字体的颜色（UIControlState）
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor], NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
    
}

- (void)setupChildVC:(UIViewController *)vc withChildVCTitle:(NSString *)title withNormalImage:(NSString *)normalImageName withSelectedImage:(NSString *)selectedImageName{
    
        vc.view.backgroundColor = kRGBA(243, 243, 243, 1);
        //tabbar上边显示的名字
        vc.tabBarItem.title = title;
        
        //tabbar正常状态下的图片
        vc.tabBarItem.image = [UIImage imageNamed:normalImageName];
        
        //tabbar选中状态下的图片
        vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    
        //设置tarbar选中图片的type（默认为蓝色）（UIImageRenderingMode）
        UIImage *selectImage =[UIImage imageNamed:selectedImageName];
        vc.tabBarItem.selectedImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        //设置导航栏图标大小
        vc.navigationItem.titleView.frame = CGRectMake(0, 0, 100, 100);
        
        //通过根视图的改变，改变nav所展示的VC
        CustomNavigationController *nav = [[CustomNavigationController alloc]initWithRootViewController:vc];
    
        [self addChildViewController:nav];
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
