//
//  MineVC.m
//  HCJD-User
//
//  Created by ZhangZi Long on 16/12/27.
//  Copyright © 2016年 JinNing. All rights reserved.
//

#import "MineVC.h"
#import "MyMessageVC.h"
#import "MyFavoriteVC.h"
#import "MyOrderVC.h"
#import "CarOwnerVC.h"
#import "MyTeamViewController.h"
#import "LoginVC.h"

@interface MineVC ()

@end

@implementation MineVC

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"个人中心";
    
    [self createUI];
}

- (void)createUI{
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg"]];
    bgImageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-49+64);
    [self.view addSubview:bgImageView];
    
    
    //头像按钮
    UIButton *headBtn = [[UIButton alloc]init];
    [headBtn setTitle:@"头像" forState:UIControlStateNormal];
    [headBtn setImage:[UIImage imageNamed:@"image"] forState:UIControlStateNormal];
    headBtn.layer.cornerRadius = kScreenWidth/8;
    headBtn.layer.masksToBounds = YES;
    [headBtn addTarget:self action:@selector(changeMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headBtn];
    headBtn.sd_layout
    .topSpaceToView(self.view,kScreenHeight/10)
    .heightIs(kScreenWidth/4)
    .centerXEqualToView(self.view)
    .widthEqualToHeight();
    
    
    //用户名
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"婚车驾到";
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:nameLabel];
    nameLabel.sd_layout
    .topSpaceToView(headBtn,5)
    .widthIs(kScreenWidth/4)
    .heightIs(25)
    .centerXEqualToView(self.view);
    
    
    //成为车主view
    UIView *carOwnerView = [self createClickViewWith:headBtn withImageName:@"icon_my_cz" withTitle:@"成为车主" withTopFloat:kScreenHeight/10 withLeftToView:self.view];
    //给view添加点击事件
    UITapGestureRecognizer * ownertarget = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(carOwnerViewClick)];
    [carOwnerView addGestureRecognizer:ownertarget];
    
    //我的车队
    UIView *myCarsView = [self createClickViewWith:headBtn withImageName:@"icon_my_hc" withTitle:@"我的车队" withTopFloat:kScreenHeight/10 withLeftToView:carOwnerView];
    UITapGestureRecognizer *carsTarget = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myCarsViewClick)];
    [myCarsView addGestureRecognizer:carsTarget];
    
    //我的收藏
    UIView *myFavoriteView = [self createClickViewWith:carOwnerView withImageName:@"icon_my_zixc" withTitle:@"我的收藏" withTopFloat:0 withLeftToView:self.view];
    UITapGestureRecognizer *favoriteTarget = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myFavoriteViewClick)];
    [myFavoriteView addGestureRecognizer:favoriteTarget];
    
    
    //我的订单
    UIView *myOrderView = [self createClickViewWith:myCarsView withImageName:@"icon_my_dd" withTitle:@"我的订单"  withTopFloat:0 withLeftToView:myFavoriteView];
    UITapGestureRecognizer *orderTarget = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myOrderViewClick)];
    [myOrderView addGestureRecognizer:orderTarget];
    
}
#pragma mark--创建添加了点击事件的view（车主，车队，收藏，订单）
- (UIView *)createClickViewWith:(id)topView withImageName:(NSString *)imageName withTitle:(NSString *)title withTopFloat:(CGFloat)space withLeftToView:(UIView *)LeftView{
    UIView *mineview = [[UIView alloc]init];
    [self.view addSubview:mineview];
    mineview.sd_layout
    .heightIs(kScreenHeight/5)
    .widthIs(kScreenWidth/2)
    .topSpaceToView(topView,space)
    .leftSpaceToView(LeftView,0);
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:imageName];
    [mineview addSubview:imageView];
    imageView.sd_layout
    .heightIs(50)
    .widthIs(50)
    .centerXEqualToView(mineview)
    .centerYEqualToView(mineview);
    
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.text = title;
    contentLabel.font = [UIFont systemFontOfSize:13];
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [mineview addSubview:contentLabel];
    contentLabel.sd_layout
    .topSpaceToView(imageView,5)
    .centerXEqualToView(mineview)
    .heightIs(25)
    .widthIs(60);
    
    return mineview;
}


#pragma mark--修改资料
- (void)changeMessage{
    
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:HCJDPassword];
    
    if (![password isEqualToString:@""]) {
        MyMessageVC *vc = [[MyMessageVC alloc]init];
        vc.view.backgroundColor = grayBG;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        LoginVC *vc = [[LoginVC alloc]init];
        vc.view.backgroundColor = grayBG;
        [self presentViewController:vc animated:YES completion:nil];
    }
}
#pragma mark--成为车主
- (void)carOwnerViewClick{
//    NSLog(@"成为车主");
    CarOwnerVC *vc = [[CarOwnerVC alloc]init];
    vc.view.backgroundColor = grayBG;
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark--我的车队
- (void)myCarsViewClick{
//    NSLog(@"我的车队");
    MyTeamViewController *vc = [[MyTeamViewController alloc]init];
    vc.view.backgroundColor = grayBG;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark--我的收藏
- (void)myFavoriteViewClick{
//    NSLog(@"我的收藏");
    MyFavoriteVC *vc = [[MyFavoriteVC alloc]init];
    vc.view.backgroundColor = grayBG;
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark--我的订单
- (void)myOrderViewClick{
//    NSLog(@"我的订单");
    MyOrderVC *vc = [[MyOrderVC alloc]init];
    vc.view.backgroundColor = grayBG;
    [self.navigationController pushViewController:vc animated:YES];
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
