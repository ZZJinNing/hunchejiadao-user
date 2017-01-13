//
//  RegisterVC.m
//  HCJD-User
//
//  Created by ZhangZi Long on 17/1/9.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import "RegisterVC.h"
#import "CustomView.h"
#import "CountDown.h"

@interface RegisterVC (){
    
    CustomView *_accountView;//账号视图
    CustomView *_passView;//密码视图
    UITextField *_yanzhengTF;//验证码输入TF
    
    
    NSInteger h;//view的高度
    NSInteger w;//view距离左右两侧的宽度
    
    TPKeyboardAvoidingScrollView *_tpScrollView;//控制键盘，不让键盘覆盖控件
    
    MNDownLoad *_download;//网络请求指针
    
    CountDown *_countDown;//倒计时指针
    
    UIButton *_yanzhengBtn;
}

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"注册";
    
    _download = [MNDownLoad shareManager];
    _countDown = [[CountDown alloc]init];
    [self createUI];
    
}


//此方法用两个NSDate对象做参数进行倒计时
-(void)startWithStartDate:(NSDate *)strtDate finishDate:(NSDate *)finishDate{
    __weak __typeof(self) weakSelf= self;
    
    [_countDown countDownWithStratDate:strtDate finishDate:finishDate completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
        
        //        NSLog(@"用两个NSDate对象进行倒计时，second = %li",(long)second);
        
        NSInteger totoalSecond =day*24*60*60+hour*60*60 + minute*60+second;
        if (totoalSecond==0) {
            //倒计时为 0 时，按钮可以使用
            _yanzhengBtn.enabled = YES;
            [_yanzhengBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        }else{
            //倒计时不为 0 时，按钮不可以使用
            _yanzhengBtn.enabled = NO;
            [_yanzhengBtn setTitle:[NSString stringWithFormat:@"%lis后重新获取",(long)totoalSecond] forState:UIControlStateNormal];
        }
        
    }];
}


- (void)createUI{
    
    _tpScrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
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
    [_tpScrollView addSubview:_passView];
    _passView.sd_layout
    .topSpaceToView(_accountView,15)
    .leftEqualToView(_accountView)
    .rightEqualToView(_accountView)
    .heightIs(40*kScaleHeight);
    
    
    //获取验证码按钮
    _yanzhengBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _yanzhengBtn.backgroundColor = kRGB(249, 30, 51);
    [_yanzhengBtn setTitle:@"验证码" forState:UIControlStateNormal];
    _yanzhengBtn.layer.cornerRadius = 5;
    _yanzhengBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_yanzhengBtn addTarget:self action:@selector(getYanZhengMaBtn) forControlEvents:UIControlEventTouchUpInside];
    [_tpScrollView addSubview:_yanzhengBtn];
    _yanzhengBtn.sd_layout
    .rightEqualToView(_passView)
    .heightIs(h)
    .widthIs(kScreenWidth/3)
    .topSpaceToView(_passView,15);
    
    
    //验证码输入框
    UIView *yanzhengView = [[UIView alloc]init];
    yanzhengView.layer.cornerRadius = 5;
    yanzhengView.layer.masksToBounds = YES;
    yanzhengView.layer.borderWidth = 1;
    yanzhengView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    yanzhengView.backgroundColor = [UIColor whiteColor];
    [_tpScrollView addSubview:yanzhengView];
    yanzhengView.sd_layout
    .topSpaceToView(_passView,15)
    .leftSpaceToView(_tpScrollView,w)
    .heightIs(h)
    .rightSpaceToView(_yanzhengBtn,5);
    
    _yanzhengTF = [[UITextField alloc]init];
    _yanzhengTF.placeholder = @"输入验证码";
    _yanzhengTF.textAlignment = NSTextAlignmentCenter;
    [yanzhengView addSubview:_yanzhengTF];
    _yanzhengTF.sd_layout
    .leftSpaceToView(yanzhengView,0)
    .centerYEqualToView(yanzhengView)
    .heightIs(30)
    .rightSpaceToView(yanzhengView,0);
    
    
    
    //注册按钮
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    registerBtn.backgroundColor = kRGB(249, 30, 51);
    registerBtn.layer.cornerRadius = 5;
    [registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_tpScrollView addSubview:registerBtn];
    registerBtn.sd_layout
    .topSpaceToView(yanzhengView,15)
    .leftEqualToView(_passView)
    .rightEqualToView(_passView)
    .heightIs(h);
    
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"iocn-back"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    
    backBtn.sd_layout
    .topSpaceToView(self.view,15)
    .heightIs(25)
    .widthIs(25)
    .leftSpaceToView(self.view,15);
    
}

//注册按钮点击事件
- (void)registerBtnClick{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_accountView.customTF.text forKey:@"phone"];
    [param setObject:_passView.customTF.text forKey:@"password"];
    [param setObject:_yanzhengTF.text forKey:@"code"];
    
    [_download POST:@"register" param:param success:^(NSDictionary *dic) {
//        NSLog(@"%@",dic);
        
        NSString *info = dic[@"info"];
        NSInteger status = [dic[@"status"] integerValue];
        if (status == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showSuccess:info toView:self.view];
        }
        
    } failure:^(NSError *error) {
        
    } withSuperView:self];
    
    
}

//获取验证码
- (void)getYanZhengMaBtn{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_accountView.customTF.text forKey:@"phone"];
    
    [_download POST:@"sendSmsCode" param:param success:^(NSDictionary *dic) {
//        NSLog(@"%@",dic);
        NSString *info = dic[@"info"];
        NSInteger status = [dic[@"status"] integerValue];
        if (status == 1) {
            //    60s的倒计时
            NSTimeInterval aMinutes = 60;
            [self startWithStartDate:[NSDate date] finishDate:[NSDate dateWithTimeIntervalSinceNow:aMinutes]];
        }else{
            [MBProgressHUD showSuccess:info toView:self.view];
        }
        
    } failure:^(NSError *error) {
        
    } withSuperView:self];
    
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

//销毁定时器
- (void)dealloc{
    [_countDown destoryTimer];
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
