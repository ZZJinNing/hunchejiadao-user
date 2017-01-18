//
//  MyMessageVC.m
//  HCJD-User
//
//  Created by ZhangZi Long on 17/1/3.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import "MyMessageVC.h"
#import "ChangeNickNameVC.h"
#import "ChangePasswordVC.h"
#import "LoginVC.h"
#import "GestureView.h"
#import "UIButton+WebCache.h"

@interface MyMessageVC ()<ChangeNickNameDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    MNDownLoad *_downLoad;
    
    UIButton *_headBtn;//头像按钮
    UILabel *_nameLabel;//用户昵称
    
    //添加手势视图
    GestureView *_accountView;
    GestureView *_nickNameView;
    
    NSString *_phoneStr;//电话
    NSString *_nameStr;//昵称
}

@end

@implementation MyMessageVC

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _downLoad = [MNDownLoad shareManager];
    
    self.title = @"个人资料";
    
    [self getMessage];
    
    [self createUI];
    
}
#pragma mark--获取个人资料
- (void)getMessage{
    
    [_downLoad POST:@"userInfo" param:nil success:^(NSDictionary *dic) {
        
        _phoneStr = [NSString stringWithFormat:@"%@",dic[@"return"][@"phone"]];
        _nameStr = [NSString stringWithFormat:@"%@",dic[@"return"][@"name"]];
        
        _nameLabel.text = _nameStr;
        _accountView.rightLabel.text = _phoneStr;
        _nickNameView.rightLabel.text = _nameStr;
        
    } failure:^(NSError *error) {
        
    } withSuperView:self];
}
#pragma mark--初始化UI
- (void)createUI{
    //头像按钮
    _headBtn = [[UIButton alloc]init];
    [_headBtn setTitle:@"头像" forState:UIControlStateNormal];
    [_headBtn sd_setImageWithURL:[NSURL URLWithString:self.headUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"image"]];
    _headBtn.layer.cornerRadius = kScreenWidth/8;
    _headBtn.layer.masksToBounds = YES;
    [_headBtn addTarget:self action:@selector(changeHeadImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_headBtn];
    _headBtn.sd_layout
    .topSpaceToView(self.view,kScreenHeight/12)
    .heightIs(kScreenWidth/4)
    .centerXEqualToView(self.view)
    .widthEqualToHeight();
    
    //用户名
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.text = @"婚车驾到";
    _nameLabel.font = [UIFont systemFontOfSize:18];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = kRGB(102, 102, 102);
    [self.view addSubview:_nameLabel];
    _nameLabel.sd_layout
    .topSpaceToView(_headBtn,5)
    .widthIs(kScreenWidth/4)
    .heightIs(25)
    .centerXEqualToView(self.view);
    
    //账号
    _accountView = [[GestureView alloc]init];
    [_accountView createViewWithLeftTitle:@"账号" withRightTitle:@"12345678901" withImageName:@""];
    [self.view addSubview:_accountView];
    _accountView.sd_layout
    .topSpaceToView(_nameLabel,kScreenHeight/15)
    .leftSpaceToView(self.view,0)
    .widthIs(kScreenWidth)
    .heightIs(40);
    
    //昵称（添加手势）
    _nickNameView = [[GestureView alloc]init];
    [_nickNameView createViewWithLeftTitle:@"昵称" withRightTitle:@"婚车驾到" withImageName:@"icon_jt"];
    [self.view addSubview:_nickNameView];
    _nickNameView.sd_layout
    .topSpaceToView(_accountView,0)
    .leftSpaceToView(self.view,0)
    .widthIs(kScreenWidth)
    .heightIs(40);
    
    UITapGestureRecognizer *nickGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeNickName)];
    [_nickNameView addGestureRecognizer:nickGesture];
    
    //密码（添加手势）
    GestureView *passwordView = [[GestureView alloc]init];
    [passwordView createViewWithLeftTitle:@"密码" withRightTitle:@"" withImageName:@"icon_jt"];
    [self.view addSubview:passwordView];
    passwordView.sd_layout
    .topSpaceToView(_nickNameView,0)
    .leftSpaceToView(self.view,0)
    .widthIs(kScreenWidth)
    .heightIs(40);
    
    UITapGestureRecognizer *passwordGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePassword)];
    [passwordView addGestureRecognizer:passwordGesture];
    
    //退出登录按钮
    UIButton *logout = [UIButton buttonWithType:UIButtonTypeCustom];
    [logout setTitle:@"退出登录" forState:UIControlStateNormal];
    logout.titleLabel.font = [UIFont systemFontOfSize:18];
    [logout addTarget:self action:@selector(logoutApp) forControlEvents:UIControlEventTouchUpInside];
    logout.layer.cornerRadius = 5;
    logout.backgroundColor = kRGB(249, 30, 51);
    [self.view addSubview:logout];
    logout.sd_layout
    .topSpaceToView(passwordView,30)
    .centerXEqualToView(self.view)
    .widthIs(kScreenWidth/2)
    .heightIs(40);
    
}
#pragma mark--代理
- (void)newNickName:(NSString *)newName{
    _nickNameView.rightLabel.text = newName;
    _nameLabel.text = newName;
}
#pragma mark--更换头像
- (void)changeHeadImage{
    
    //初始化 UIImagePickerController 对象
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    
    //设置代理
    imagePickerController.delegate = self;
    
    //设置是否需要做图片编辑   默认  NO
    imagePickerController.allowsEditing = YES;
    
    //判断数据来源是否可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        //设置数据来源
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        //打开相机、相册、图库
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        //设置数据来源
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        //打开相机
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    
}
#pragma mark--imagePicker代理
//取消选择
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
//选择完成
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //获取点击的图片
    UIImage *imageSelected = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //图片数据转化
    NSData *data;
    if (UIImagePNGRepresentation(imageSelected)) {
        data = UIImageJPEGRepresentation(imageSelected, 1);
    }else{
        data = UIImagePNGRepresentation(imageSelected);
    }
    
    //上传图片
    [self uploadImageActionWith:data withURL:@""];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//上传
-(void)uploadImageActionWith:(NSData *)data withURL:(NSString *)URL{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.headUrl forKey:@"photo"];
    
    [_downLoad POST:@"updatePhoto" param:param success:^(NSDictionary *dic) {

    } failure:^(NSError *error) {
        
    } withSuperView:self];
    
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //2.上传文件
    
    [manager POST:URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //使用日期生成图片名称
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        
        NSString *fileName = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
        
        
        //上传文件参数
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //打印上传进度
        CGFloat progress = 100.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        //NSLog(@"%.2lf%%", progress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //请求成功
        //NSLog(@"请求成功：%@===%@",responseObject,responseObject[@"info"]);
        
        NSString *url = responseObject[@"obj"][@"url"];
        
        const char *imageUrl = [url UTF8String];
        
        NSLog(@"%s",imageUrl);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //请求失败
        NSLog(@"请求失败：%@",error);
        
    }];
}


#pragma mark--修改昵称
- (void)changeNickName{
    ChangeNickNameVC *vc = [[ChangeNickNameVC alloc]init];
    vc.view.backgroundColor = grayBG;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark--修改密码
- (void)changePassword{
    ChangePasswordVC *vc = [[ChangePasswordVC alloc]init];
    vc.accountNumber = _phoneStr;
    vc.view.backgroundColor = grayBG;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark--退出登录
- (void)logoutApp{
    
    [_downLoad POST:@"logout" param:nil success:^(NSDictionary *dic) {
        
        NSInteger status = [dic[@"status"] integerValue];
        
        if (status == 1) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:HCJDPassword];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:HCJDPhone];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:HCJDName];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:HCJDPhoto];
            
            LoginVC *vc = [[LoginVC alloc]init];
            vc.view.backgroundColor = grayBG;
            [self presentViewController:vc animated:YES completion:nil];
        }
    } failure:^(NSError *error) {
        
    } withSuperView:self];
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
