
//
//  LoginVC.m
//  HCJD-User
//
//  Created by ZhangZi Long on 16/12/27.
//  Copyright © 2016年 JinNing. All rights reserved.
//

#import "LoginVC.h"
#import "RegisterVC.h"
#import "CustomView.h"
#import "TarbarViewController.h"

@interface LoginVC (){
    
    MNDownLoad *_download;//网络请求指针
    
    NSInteger h;//view的高度
    NSInteger w;//view距离左右两侧的宽度
    
    TPKeyboardAvoidingScrollView *_tpScrollView;
    
    CustomView *_accountView;//账号视图
    CustomView *_passView;//密码视图
    NSInteger cart_num;//车队数量
}

@end

@implementation LoginVC

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _download = [MNDownLoad shareManager];
    
    [self createUI];
    
}

- (void)createUI{
    
    _tpScrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight+64)];
    _tpScrollView.backgroundColor = kRGB(248, 248, 248);
    [self.view addSubview:_tpScrollView];
    
    
    //logo图片
    UIImageView *logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-logo"]];
    [_tpScrollView addSubview:logo];
    logo.sd_layout
    .topSpaceToView(_tpScrollView,kScreenHeight/8)
    .centerXEqualToView(_tpScrollView)
    .heightIs(130*kScaleHeight)
    .widthIs(112*kScaleWidth);
    
    h = 40*kScaleHeight;//view的高度
    w = 20*kScaleWidth;//view距离左右两侧的宽度
    //账号
    _accountView = [[CustomView alloc]init];
    [_accountView setupPlaceholderWith:@"输入手机号码" withLeftImage:@"icon_username"];
    [_tpScrollView addSubview:_accountView];
    _accountView.sd_layout
    .topSpaceToView(logo,kScreenHeight/10)
    .leftSpaceToView(_tpScrollView,20*kScaleWidth)
    .heightIs(40*kScaleHeight)
    .widthIs(kScreenWidth-2*w);
    
    
    //密码
    _passView = [[CustomView alloc]init];
    [_passView setupPlaceholderWith:@"输入密码" withLeftImage:@"icon_password"];
    _passView.customTF.secureTextEntry = YES;
    [_tpScrollView addSubview:_passView];
    _passView.sd_layout
    .topSpaceToView(_accountView,15)
    .leftEqualToView(_accountView)
    .rightEqualToView(_accountView)
    .heightIs(40*kScaleHeight);
    
    
    //登录按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"用户登录" forState:UIControlStateNormal];
    loginBtn.backgroundColor = kRGB(249, 30, 51);
    loginBtn.layer.cornerRadius = 5;
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_tpScrollView addSubview:loginBtn];
    loginBtn.sd_layout
    .topSpaceToView(_passView,15)
    .leftEqualToView(_passView)
    .rightEqualToView(_passView)
    .heightIs(h);
    
    
    //忘记密码
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(forgetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_tpScrollView addSubview:forgetBtn];
    forgetBtn.sd_layout
    .topSpaceToView(loginBtn,15)
    .leftEqualToView(loginBtn)
    .widthIs(kScreenWidth/3)
    .heightIs(h);
    
    
    //注册按钮
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setTitle:@"现在去注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_tpScrollView addSubview:registerBtn];
    registerBtn.sd_layout
    .topSpaceToView(loginBtn,15)
    .rightEqualToView(loginBtn)
    .widthIs(kScreenWidth/3)
    .heightIs(h);
}

#pragma mark--登录按钮点击事件
- (void)loginBtnClick{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_accountView.customTF.text forKey:@"phone"];
    [param setObject:_passView.customTF.text forKey:@"password"];
    [_download POST:@"login" param:param success:^(NSDictionary *dic) {
        
//        NSLog(@"%@--%@",dic,dic[@"info"]);
        
        NSString *info = dic[@"info"];
        NSInteger status = [dic[@"status"] integerValue];
        if (status == 1) {
            
#pragma mark -- 保存账号和密码
            NSString *password = dic[@"return"][@"password"];
            NSString *phone = dic[@"return"][@"phone"];
            
            NSString *name = dic[@"return"][@"name"];
            NSString *photoUtl = dic[@"return"][@"photo"];
            
            [[NSUserDefaults standardUserDefaults] setObject:password forKey:HCJDPassword];
            [[NSUserDefaults standardUserDefaults] setObject:phone forKey:HCJDPhone];
            
            [[NSUserDefaults standardUserDefaults] setObject:name forKey:HCJDName];
            [[NSUserDefaults standardUserDefaults] setObject:photoUtl forKey:HCJDPhoto];
            
            //请求获取车队数量
            [self getCartNum];
            
            
        }else{
            [MBProgressHUD showSuccess:info toView:self.view];
        }
        
    } failure:^(NSError *error) {
        
    } withSuperView:self];
}
#pragma mark--请求获取车队数量
- (void)getCartNum{
    [[MNDownLoad shareManager] POSTWithoutGitHUD:@"cartNum" param:nil success:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        NSInteger status = [dic[@"status"] integerValue];
        if (status == 1) {
            cart_num = [dic[@"return"][@"cart_num"] integerValue];
            //保存cart_num
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)cart_num] forKey:HCJDCart_num];
            
            [self presentViewController:[[TarbarViewController alloc]init] animated:YES completion:nil];
        }
    } failure:^(NSError *error) {
        
    } withSuperView:self];
    
}
#pragma mark--忘记密码点击事件
- (void)forgetBtnClick{
    
}
#pragma mark--注册按钮点击事件
- (void)registerBtnClick{
    RegisterVC *vc = [[RegisterVC alloc]init];
    vc.view.backgroundColor = kRGB(248, 248, 248);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
