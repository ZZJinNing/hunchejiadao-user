//
//  MyOrderVC.m
//  HCJD-User
//
//  Created by ZhangZi Long on 17/1/5.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import "MyOrderVC.h"
#import "OrderCell.h"
#import "OrderDetailVC.h"

@interface MyOrderVC ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_orderTableView;
    UISegmentedControl *_sgc;
    UILabel *_line;//红线
}

@end

@implementation MyOrderVC

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的订单";
    [self createSgcView];
    
    
}
- (void)createSgcView{
    _sgc = [[UISegmentedControl alloc]initWithItems:@[@"所有订单",@"等待配车",@"等待用车",@"已完成"]];
    //设置大小和位置
    _sgc.frame = CGRectMake(0, 0, kScreenWidth, 40);
    //设置默认选中板块
    _sgc.selectedSegmentIndex = 0;
    //设置填充色
    _sgc.tintColor = [UIColor whiteColor];
    //设置选中状态下字体的颜色和大小
    [_sgc setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    //设置正常状态下字体的颜色和大小
    [_sgc setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    //添加点击事件
    [_sgc addTarget:self action:@selector(changeIndex:) forControlEvents:UIControlEventValueChanged];
    _sgc.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_sgc];
    
    
    _line = [[UILabel alloc]init];
    _line.backgroundColor = [UIColor redColor];
    [self.view addSubview:_line];
    _line.sd_layout
    .topSpaceToView(_sgc,0)
    .heightIs(2)
    .widthIs(kScreenWidth/4)
    .leftSpaceToView(self.view,0);
    
    
    
    //初始化_orderTableView
    _orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    _orderTableView.delegate = self;
    _orderTableView.dataSource = self;
    _orderTableView.backgroundColor = grayBG;
    [self.view addSubview:_orderTableView];
    _orderTableView.sd_layout
    .topSpaceToView(_line,0)
    .widthIs(kScreenWidth)
    .bottomSpaceToView(self.view,0)
    .leftSpaceToView(self.view,0);
    
    
    [_orderTableView registerNib:[UINib nibWithNibName:@"OrderCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    if (_orderTableView == 0) {
        UIImageView *logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
        logo.frame = CGRectMake(kScreenWidth/3, kScreenHeight/6, kScreenWidth/3, kScreenWidth*2/9);
        [_orderTableView addSubview:logo];
    }
    
    
}
- (void)changeIndex:(UISegmentedControl *)sgc{
    _line.sd_layout
    .topSpaceToView(sgc,0)
    .heightIs(2)
    .widthIs(kScreenWidth/4)
    .leftSpaceToView(self.view,kScreenWidth/4*sgc.selectedSegmentIndex);
    //刷新视图
    [self.view layoutSubviews];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 111;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderDetailVC *vc = [[OrderDetailVC alloc]init];
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