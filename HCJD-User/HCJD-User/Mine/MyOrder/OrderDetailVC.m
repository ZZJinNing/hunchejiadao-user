//
//  OrderDetailVC.m
//  HCJD-User
//
//  Created by ZhangZi Long on 17/1/6.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import "OrderDetailVC.h"
#import "WayViewController.h"

@interface OrderDetailVC ()

@end

@implementation OrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"订单详情";
    
    [self createUI];
    
}


- (void)createUI{
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight-50-64)];
    scrollView.contentOffset = CGPointMake(0, 0);
    scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
    [self.view addSubview:scrollView];
    
    
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:topView];
    topView.sd_layout
    .topSpaceToView(scrollView,5)
    .leftSpaceToView(scrollView,0)
    .heightIs(80)
    .widthIs(kScreenWidth);
    
    UIImageView *headImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"image"]];
    [topView addSubview:headImage];
    headImage.sd_layout
    .topSpaceToView(topView,10)
    .leftSpaceToView(topView,20)
    .heightIs(60)
    .widthIs(60);
    headImage.layer.cornerRadius = 30;
    headImage.layer.masksToBounds = YES;
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"幽魂车";
    nameLabel.textColor = wordColorDark;
    nameLabel.font = [UIFont systemFontOfSize:15];
    [topView addSubview:nameLabel];
    nameLabel.sd_layout
    .topEqualToView(headImage)
    .leftSpaceToView(headImage,10)
    .heightIs(25)
    .rightSpaceToView(topView,0);
    
    UILabel *phoneLabel = [[UILabel alloc]init];
    phoneLabel.text = @"12345678901";
    phoneLabel.textColor = wordColorDark;
    phoneLabel.font = [UIFont systemFontOfSize:15];
    [topView addSubview:phoneLabel];
    phoneLabel.sd_layout
    .bottomEqualToView(headImage)
    .leftEqualToView(nameLabel)
    .heightIs(25)
    .rightEqualToView(nameLabel);
    
    
    NSInteger h = 40;
    NSInteger font = 15;
    
    UIView *midView = [[UIView alloc]init];
    midView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:midView];
    midView.sd_layout
    .topSpaceToView(topView,5)
    .leftSpaceToView(scrollView,0)
    .widthIs(kScreenWidth)
    .heightIs(h*9);
    
    NSArray *leftArr = @[@"定金:",@"预计金额:",@"婚礼日期:",@"集合时间:",@"集合时间:",@"集合地点:",@"途经点(新娘家):",@"结束地点(酒店):",@"订单状态:"];
    
    NSArray *rightArr = @[@"600元",@"4000元",@"2017-11-11",@"00:00",@"1小时",@"郑州市金水区",@"XXXX:",@"XXXX:",@"等待配车"];
    
    for (int i = 0; i<9; i++) {
        UILabel *leftlabel = [[UILabel alloc]init];
        leftlabel.frame = CGRectMake(10, h*i, kScreenWidth/2-10, h);
        leftlabel.text = leftArr[i];
        leftlabel.font = [UIFont systemFontOfSize:font];
        leftlabel.textColor = wordColorDark;
        [midView addSubview:leftlabel];
        
        UILabel *rightLabel = [[UILabel alloc]init];
        rightLabel.frame = CGRectMake(kScreenWidth/2, h*i, kScreenWidth/2-10, h);
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.text = rightArr[i];
        rightLabel.font = [UIFont systemFontOfSize:font];
        rightLabel.textColor = wordColorDark;
        [midView addSubview:rightLabel];
    }
    
    
    UIButton *roadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    roadButton.backgroundColor = [UIColor whiteColor];
    [roadButton setImage:[UIImage imageNamed:@"icon_map"] forState:UIControlStateNormal];
    [roadButton addTarget:self action:@selector(lookRoadMap) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:roadButton];
    roadButton.sd_layout
    .topSpaceToView(midView,0)
    .leftSpaceToView(scrollView,0)
    .heightIs(h)
    .widthEqualToHeight();
    
    UILabel *roadLabel = [[UILabel alloc]init];
    roadLabel.text = @"查看线路";
    roadLabel.backgroundColor = [UIColor whiteColor];
    roadLabel.textColor = wordColorDark;
    roadLabel.font = [UIFont systemFontOfSize:15];
    [scrollView addSubview:roadLabel];
    roadLabel.sd_layout
    .leftSpaceToView(roadButton,0)
    .heightIs(h)
    .rightSpaceToView(scrollView,0)
    .topEqualToView(roadButton);
    
    UILabel *tuiKuanLabel = [[UILabel alloc]init];
    tuiKuanLabel.text = @"退款手续费说明";
    tuiKuanLabel.textColor = wordColorDark;
    tuiKuanLabel.backgroundColor = [UIColor whiteColor];
    tuiKuanLabel.font = [UIFont systemFontOfSize:18];
    tuiKuanLabel.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:tuiKuanLabel];
    tuiKuanLabel.sd_layout
    .topSpaceToView(roadButton,5)
    .widthIs(kScreenWidth)
    .leftSpaceToView(scrollView,0)
    .heightIs(30);
    
    UILabel *shuoMingLabel = [[UILabel alloc]init];
    shuoMingLabel.text = @"    1.距离婚期2个月以上取消，扣除订单金额10%;\n    2.距离婚期15天以上取消，扣除订单金额30%;";
    shuoMingLabel.numberOfLines = 0;
    shuoMingLabel.backgroundColor = [UIColor whiteColor];
    shuoMingLabel.font = [UIFont systemFontOfSize:15];
    shuoMingLabel.textColor = wordColorDark;
    float labelHeight = [self getHeightWithString:shuoMingLabel.text andWidth:kScreenWidth andLabelTextSize:15];
    
    [scrollView addSubview:shuoMingLabel];
    shuoMingLabel.sd_layout
    .topSpaceToView(tuiKuanLabel,0)
    .heightIs(labelHeight)
    .widthIs(kScreenWidth)
    .leftSpaceToView(scrollView,0);
    
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.backgroundColor = kRGB(249, 30, 51);
    [cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelOrderClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    cancelBtn.sd_layout
    .leftSpaceToView(self.view,0)
    .widthIs(kScreenWidth)
    .heightIs(50)
    .bottomSpaceToView(self.view,0);
    
}

# pragma mark -- 计算label高度
- (float)getHeightWithString:(NSString *)string andWidth:(float)width andLabelTextSize:(float)Mysize{
    
    UILabel *label = [[UILabel alloc]init];
    label.text = string;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    UIFont *font = [UIFont fontWithName:@"Verdana" size:Mysize];
    label.font = font;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    CGSize stringSize = [string boundingRectWithSize:CGSizeMake(width,2000)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:dic
                                             context:nil].size;
    label.frame = CGRectMake(10, 50, stringSize.width, stringSize.height);
    
    
    float height = stringSize.height;
    
    return height;
}

# pragma mark -- 查看线路
- (void)lookRoadMap{
    
    WayViewController*wayVC = [[WayViewController alloc]init];
    wayVC.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController pushViewController:wayVC animated:YES];
    
    
}
# pragma make -- 取消订单
- (void)cancelOrderClick{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
