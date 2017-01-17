
//
//  CityViewController.m
//  HCJD-User
//
//  Created by jiang on 17/1/6.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import "CityViewController.h"
#import "CityModel.h"
@interface CityViewController ()
{
    //当前城市
    UILabel *_cityLabel;
    //数据源
    NSMutableArray *_cityArray;
    
}
@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"城市选择";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.view.backgroundColor = grayBG;
     UIBarButtonItem * item1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = item1;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    _cityArray = [[NSMutableArray alloc]init];
    
    //当前城市
    [self currentCity];
    
    //获取已开通的所有城市
    [self getOpenCityDataSource];
    
}

#pragma mark--重写返回的方法
- (void)back{
    
    if (self.MyBlock != nil) {
        self.MyBlock();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)chuanZhi:(NewBlock)block{
    self.MyBlock = block;
}


#pragma mark--当前城市
- (void)currentCity{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];

    _cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 500, 50)];
    _cityLabel.text = [NSString stringWithFormat:@"当前城市：%@",self.cityTitle];
    _cityLabel.textColor = wordColorDark;
    [bgView addSubview:_cityLabel];
    
}

#pragma mark--获取已开通的所有城市
- (void)getOpenCityDataSource{
    NSString *url = @"cityOpenAll";
    
    [[MNDownLoad shareManager]POST:url param:nil success:^(NSDictionary *dic) {
        NSString *info = dic[@"info"];
        NSString *status = [NSString stringWithFormat:@"%@",dic[@"status"]];
        if ([status integerValue] == 1) {
            NSArray *returnArray = dic[@"return"];
            for (NSDictionary *returnDic in returnArray) {
                CityModel *model = [[CityModel alloc]init];
                model.city = [NSString stringWithFormat:@"%@",returnDic[@"city"]];
                model.city_id = [NSString stringWithFormat:@"%@",returnDic[@"city_id"]];
                [_cityArray addObject:model];
            }
            //已开通城市
            [self openCity];
   
        }else{
            [MBProgressHUD showSuccess:info toView:self.view];
        }
        
        
        
        
    } failure:^(NSError *error) {
        
    } withSuperView:self];
}

#pragma mark--已开通城市
- (void)openCity{
    NSInteger allNum;
    NSInteger num = _cityArray.count/3;
    NSInteger num1 = _cityArray.count%3;
    if (num1 > 0) {
        allNum = num + 1;
    }else{
        allNum = num;
    }
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 70, kScreenWidth, 50 + 50 * allNum)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 500, 50)];
    label.textColor = wordColorDark;
    label.text = @"已开通城市";
    [bgView addSubview:label];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, kScreenWidth, 1)];
    lineLabel.backgroundColor = LineColor;
    [bgView addSubview:lineLabel];
    
    [self crateCityButtonWithView:bgView];
    
}
#pragma mark--初始化视图
- (void)crateCityButtonWithView:(UIView*)view{
    NSInteger flag = 0;
    
    NSInteger num = _cityArray.count/3;
    NSInteger num1 = _cityArray.count%3;
   
    if (_cityArray.count < 3) {
        for (int i = 0; i < 2; i++) {
            [self createCityButtonWithI:i withJ:0 with:flag withView:view];
            flag++;
        }
    }else{
       
        for (int j = 0; j < num; j++) {
            for (int i = 0; i < 3; i++) {
                [self createCityButtonWithI:i withJ:j with:flag withView:view];
                flag++;
            }
        }
        
        for (int k = 0; k < num1; k++) {
            [self createCityButtonWithI:k withJ:num with:flag withView:view];
            flag++;
        }
        
        
    }

}

- (void)createCityButtonWithI:(NSInteger)i withJ:(NSInteger)j with:(NSInteger)flag withView:(UIView*)view{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CityModel *model = _cityArray[flag];
    [button setTitle:model.city forState:UIControlStateNormal];
    [button addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 100+i;
    [button setTitleColor:wordColorDark forState:UIControlStateNormal];
    float width = kScreenWidth/3;
    button.frame = CGRectMake(width*i, 50+50*j, width, 50);
    button.layer.borderWidth = 1;
    button.layer.borderColor = [[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1] CGColor];
    [view addSubview:button];
}

#pragma mark - 手动切换城市
- (void)selectCity:(UIButton*)button{
    NSInteger flag = button.tag - 100;
    //手动切换城市
    [self SwitchTheCityWithFlag:flag];
}
- (void)SwitchTheCityWithFlag:(NSInteger)flag{
    CityModel *model = _cityArray[flag];
    NSDictionary *param = @{@"city_id":model.city_id};
    [[MNDownLoad shareManager]POST:@"switchCity" param:param success:^(NSDictionary *dic) {
        NSString *info = dic[@"info"];
        NSString *status = [NSString stringWithFormat:@"%@",dic[@"status"]];
        if ([status integerValue] == 1) {
            _cityLabel.text = [NSString stringWithFormat:@"当前城市：%@",dic[@"return"][@"city"]];
        }else{
            [MBProgressHUD showSuccess:info toView:self.view];
        }
    } failure:^(NSError *error) {
        
    } withSuperView:self];
    
    
}








@end


















