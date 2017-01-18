//
//  ChangeNickNameVC.m
//  HCJD-User
//
//  Created by ZhangZi Long on 17/1/4.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import "ChangeNickNameVC.h"

@interface ChangeNickNameVC (){
    MNDownLoad *_downLoad;
    
    UITextField *_nickTF;//昵称输入框
}

@end

@implementation ChangeNickNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改昵称";
    
    _downLoad = [MNDownLoad shareManager];
    
    [self createUI];
    
    
}
#pragma mark--初始化UI
- (void)createUI{
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"昵称";
    label1.textColor = kRGB(102, 102, 102);
    label1.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:label1];
    label1.sd_layout
    .topSpaceToView(self.view,30)
    .leftSpaceToView(self.view,40)
    .heightIs(25)
    .widthIs(40);
    
    
    _nickTF  = [[UITextField alloc]init];
    _nickTF.font = [UIFont systemFontOfSize:18];
    _nickTF.placeholder = @"我的昵称";
    _nickTF.textColor = kRGB(102, 102, 102);
    [self.view addSubview:_nickTF];
    _nickTF.sd_layout
    .centerYEqualToView (label1)
    .leftSpaceToView(label1,10)
    .heightIs(25)
    .widthIs(kScreenWidth/2);
    
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = kRGB(153, 153, 153);
    [self.view addSubview:lineLabel];
    lineLabel.sd_layout
    .heightIs(1)
    .leftSpaceToView(self.view,30)
    .rightSpaceToView(self.view,30)
    .topSpaceToView(label1,0);
    
    
    
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    changeBtn.backgroundColor = kRGB(249, 30, 51);
    changeBtn.layer.cornerRadius = 3;
    changeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [changeBtn addTarget:self action:@selector(changeNickName) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];
    changeBtn.sd_layout
    .topSpaceToView(self.view,kScreenHeight/5)
    .leftSpaceToView(self.view,15)
    .rightSpaceToView(self.view,15)
    .heightIs(40);
}
#pragma mark--修改昵称
- (void)changeNickName{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_nickTF.text forKey:@"name"];
    
    [_downLoad POST:@"updateName" param:param success:^(NSDictionary *dic) {
        
        NSInteger status = [dic[@"status"] integerValue];
        if (status == 1) {
            
            if (self.delegate) {
                [self.delegate newNickName:_nickTF.text];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    } withSuperView:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
