
//
//  CityViewController.m
//  HCJD-User
//
//  Created by jiang on 17/1/6.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import "CityViewController.h"

@interface CityViewController ()
{
    //当前城市
    UILabel *_cityLabel;
}
@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"城市选择";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.view.backgroundColor = grayBG;

    
    //当前城市
    [self currentCity];
    //已开通城市
    [self openCity];
    
}


//当前城市
- (void)currentCity{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];

    _cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 500, 50)];
    _cityLabel.text = @"当前城市：郑州";
    _cityLabel.textColor = wordColorDark;
    [bgView addSubview:_cityLabel];
    
}

//已开通城市
- (void)openCity{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 70, kScreenWidth, 100)];
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

- (void)crateCityButtonWithView:(UIView*)view{
    NSArray *array = @[@"郑州",@"厦门"];
    float width = kScreenWidth/3;
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100+i;
        [button setTitleColor:wordColorDark forState:UIControlStateNormal];
        button.frame = CGRectMake(width*i, 50, width, 50);
        button.layer.borderWidth = 1;
        button.layer.borderColor = [[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1] CGColor];
        [view addSubview:button];
        
    }
  
}
- (void)selectCity:(UIButton*)button{
    _cityLabel.text = [NSString stringWithFormat:@"当前城市：%@",button.titleLabel.text];
    
    if (self.MyBlock != nil) {
        self.MyBlock(button.titleLabel.text);
    }

    [self.navigationController popViewControllerAnimated:YES];
}


- (void)chuanZhi:(NewBlock)block{
    self.MyBlock = block;
}








@end


















