//
//  ChangePasswordVC.m
//  HCJD-User
//
//  Created by ZhangZi Long on 17/1/4.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import "ChangePasswordVC.h"
#import "CountDown.h"

@interface ChangePasswordVC (){
    UITextField *_yanzhengTF;//验证码
    UILabel *_accountLabel;//账号
    UITextField *_passwordTF1;//新密码
    UITextField *_passwordTF2;//确认新密码
    
    MNDownLoad *_downLoad;
}

@property (strong, nonatomic)  CountDown *countDown;
@property (strong, nonatomic)  UIButton *getYZBtn;


@end

@implementation ChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"修改密码";
    
    _downLoad = [MNDownLoad shareManager];
    
    //初始化button上的倒计时指针
    _countDown = [[CountDown alloc] init];
    
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
            weakSelf.getYZBtn.enabled = YES;
            [weakSelf.getYZBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        }else{
            //倒计时不为 0 时，按钮不可以使用
            weakSelf.getYZBtn.enabled = NO;
            [weakSelf.getYZBtn setTitle:[NSString stringWithFormat:@"%lis后重新获取",(long)totoalSecond] forState:UIControlStateNormal];
        }
        
    }];
}



- (void)createUI{
    
    NSInteger f = 18;//字体大小
    
    UIImageView *topImage = [[UIImageView alloc]init];
    topImage.backgroundColor = [UIColor redColor];
    [self.view addSubview:topImage];
    topImage.sd_layout
    .topSpaceToView(self.view,30)
    .centerXEqualToView(self.view)
    .heightIs(70)
    .widthIs(200);
    
    
#pragma mark--账号部分
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"账号";
    label1.font = [UIFont systemFontOfSize:f];
    label1.textColor = kRGB(102, 102, 102);
    [self.view addSubview:label1];
    label1.sd_layout
    .topSpaceToView(topImage,30)
    .heightIs(25)
    .widthIs(80)
    .leftSpaceToView(self.view,40);
    
    //账号
    _accountLabel = [[UILabel alloc]init];
    _accountLabel.text = self.accountNumber;
    _accountLabel.textColor = kRGB(102, 102, 102);
    _accountLabel.font = [UIFont systemFontOfSize:f];
    [self.view addSubview:_accountLabel];
    _accountLabel.sd_layout
    .leftSpaceToView(label1,10)
    .heightIs(25)
    .centerYEqualToView(label1)
    .widthIs(kScreenWidth/2);
    
    UILabel *lineLabel1 = [[UILabel alloc]init];
    lineLabel1.backgroundColor = kRGB(153, 153, 153);
    [self.view addSubview:lineLabel1];
    lineLabel1.sd_layout
    .heightIs(1)
    .leftSpaceToView(self.view,30)
    .rightSpaceToView(self.view,30)
    .topSpaceToView(label1,5);
    
    
    
#pragma mark--验证码部分
    //验证码输入框
    _yanzhengTF = [[UITextField alloc]init];
    _yanzhengTF.placeholder = @"验证码";
    _yanzhengTF.textColor = kRGB(102, 102, 102);
    _yanzhengTF.textAlignment = NSTextAlignmentCenter;
    _yanzhengTF.font = [UIFont systemFontOfSize:f];
    [self.view addSubview:_yanzhengTF];
    _yanzhengTF.sd_layout
    .heightIs(25)
    .widthIs(kScreenWidth/2)
    .leftEqualToView(label1)
    .topSpaceToView(lineLabel1,15);
    
    //获取验证码按钮
    _getYZBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _getYZBtn.backgroundColor = kRGB(249, 30, 51);
    [_getYZBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _getYZBtn.layer.cornerRadius = 3;
    _getYZBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_getYZBtn addTarget:self action:@selector(getYanZhengBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_getYZBtn];
    _getYZBtn.sd_layout
    .rightSpaceToView(self.view,40)
    .heightIs(25)
    .widthIs(100)
    .centerYEqualToView(_yanzhengTF);
    
    
    UILabel *lineLabel2 = [[UILabel alloc]init];
    lineLabel2.backgroundColor = kRGB(153, 153, 153);
    [self.view addSubview:lineLabel2];
    lineLabel2.sd_layout
    .heightIs(1)
    .leftSpaceToView(self.view,30)
    .rightSpaceToView(self.view,30)
    .topSpaceToView(_yanzhengTF,5);
    
    
#pragma mark--新密码和确认密码部分
    //新密码
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = @"新密码";
    label2.textColor = kRGB(102, 102, 102);
    label2.font = [UIFont systemFontOfSize:f];
    [self.view addSubview:label2];
    label2.sd_layout
    .topSpaceToView(lineLabel2,15)
    .heightIs(25)
    .widthIs(80)
    .leftSpaceToView(self.view,40);
    
    UIImageView *lockImage1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    [self.view addSubview:lockImage1];
    lockImage1.sd_layout
    .rightSpaceToView(self.view,40)
    .heightIs(25)
    .widthIs(25)
    .topSpaceToView(lineLabel2,15);
    
    _passwordTF1 = [[UITextField alloc]init];
    _passwordTF1.placeholder = @"请设置6~20位字符";
    _passwordTF1.textColor = kRGB(102, 102, 102);
    _passwordTF1.font = [UIFont systemFontOfSize:f];
    [self.view addSubview:_passwordTF1];
    _passwordTF1.sd_layout
    .leftEqualToView(_accountLabel)
    .topEqualToView(label2)
    .heightIs(25)
    .rightSpaceToView(lockImage1,0);
    
    UILabel *lineLabel3 = [[UILabel alloc]init];
    lineLabel3.backgroundColor = kRGB(153, 153, 153);
    [self.view addSubview:lineLabel3];
    lineLabel3.sd_layout
    .heightIs(1)
    .leftSpaceToView(self.view,30)
    .rightSpaceToView(self.view,30)
    .topSpaceToView(_passwordTF1,5);
    
    
    
    //确认密码
    UILabel *label3 = [[UILabel alloc]init];
    label3.text = @"确认密码";
    label3.textColor = kRGB(102, 102, 102);
    label3.font = [UIFont systemFontOfSize:f];
    [self.view addSubview:label3];
    label3.sd_layout
    .topSpaceToView(lineLabel3,15)
    .heightIs(25)
    .widthIs(80)
    .leftSpaceToView(self.view,40);
    
    UIImageView *lockImage2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    [self.view addSubview:lockImage2];
    lockImage2.sd_layout
    .rightSpaceToView(self.view,40)
    .heightIs(25)
    .widthIs(25)
    .topSpaceToView(lineLabel3,15);
    
    
    _passwordTF2 = [[UITextField alloc]init];
    _passwordTF2.placeholder = @"确认密码";
    _passwordTF2.font = [UIFont systemFontOfSize:f];
    _passwordTF2.textColor = kRGB(102, 102, 102);
    [self.view addSubview:_passwordTF2];
    _passwordTF2.sd_layout
    .leftEqualToView(_accountLabel)
    .topEqualToView(label3)
    .heightIs(25)
    .rightSpaceToView(lockImage2,0);
    
    
    UILabel *lineLabel4 = [[UILabel alloc]init];
    lineLabel4.backgroundColor = kRGB(153, 153, 153);
    [self.view addSubview:lineLabel4];
    lineLabel4.sd_layout
    .heightIs(1)
    .leftSpaceToView(self.view,30)
    .rightSpaceToView(self.view,30)
    .topSpaceToView(_passwordTF2,5);
    
    
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    changeBtn.backgroundColor = kRGB(249, 30, 51);
    changeBtn.layer.cornerRadius = 3;
    changeBtn.titleLabel.font = [UIFont systemFontOfSize:f];
    [changeBtn addTarget:self action:@selector(changePasswordBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];
    changeBtn.sd_layout
    .topSpaceToView(lineLabel4,30)
    .leftSpaceToView(self.view,15)
    .rightSpaceToView(self.view,15)
    .heightIs(40);
}

#pragma mark--点击获取验证码
- (void)getYanZhengBtnClick{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_accountLabel.text forKey:@"phone"];
    
    [_downLoad POST:@"sendSmsCode" param:param success:^(NSDictionary *dic) {
        
//        NSLog(@"%@",dic);
        
        NSString *info = dic[@"info"];
        NSInteger status = [dic[@"status"] integerValue];
        if (status == 1) {
            //    60s的倒计时
            NSTimeInterval aMinutes = 60;
            //此方法用两个NSDate对象做参数进行倒计时
            [self startWithStartDate:[NSDate date] finishDate:[NSDate dateWithTimeIntervalSinceNow:aMinutes]];
        }else{
            [MBProgressHUD showSuccess:info toView:self.view];
        }
        
    } failure:^(NSError *error) {
        
    } withSuperView:self];
    
}

#pragma mark--修改密码
- (void)changePasswordBtnClick{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_accountLabel.text forKey:@"phone"];
    [param setObject:_yanzhengTF.text forKey:@"code"];
    [param setObject:_passwordTF1.text forKey:@"password"];
    [param setObject:_passwordTF2.text forKey:@"password_rep"];
    
    [_downLoad POST:@"updatePassword" param:param success:^(NSDictionary *dic) {
        
//        NSLog(@"%@",dic);
        
        NSInteger status = [dic[@"status"] integerValue];
        NSString *info = dic[@"info"];
        if (status == 1) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showSuccess:info toView:self.view];
        }
        
    } failure:^(NSError *error) {
        
    } withSuperView:self];
    
}

#pragma mark——销毁定时器
-(void)dealloc{
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
