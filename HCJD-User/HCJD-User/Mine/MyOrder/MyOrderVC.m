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
    
    MNDownLoad *_downLoad;
    
    NSMutableArray *_orderArr;//订单数组
    
    
    
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
    
    _downLoad = [MNDownLoad shareManager];
    
    [self createSgcView];
    
    [self getDataSourceWithType:@"all"];
}
#pragma mark--数据源
- (void)getDataSourceWithType:(NSString *)type{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:type forKey:@"type"];
    [_downLoad POST:@"orderList" param:param success:^(NSDictionary *dic) {
        
        NSLog(@"%@",dic);
        
    } failure:^(NSError *error) {
        
    } withSuperView:self];
}
#pragma mark--分段控制器
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
#pragma mark--分段显示订单的不同状态
- (void)changeIndex:(UISegmentedControl *)sgc{
    _line.sd_layout
    .topSpaceToView(sgc,0)
    .heightIs(2)
    .widthIs(kScreenWidth/4)
    .leftSpaceToView(self.view,kScreenWidth/4*sgc.selectedSegmentIndex);
    //刷新视图
    [self.view layoutSubviews];
    
    
    if (sgc.selectedSegmentIndex == 0) {//所有
        [self getDataSourceWithType:@"all"];
    }else if (sgc.selectedSegmentIndex == 1){//等待配车
        [self getDataSourceWithType:@"no_match"];
    }else if (sgc.selectedSegmentIndex == 2){//等待用车
        [self getDataSourceWithType:@"no_use"];
    }else{//已完成
        [self getDataSourceWithType:@"is_finish"];
    }
    
}
#pragma mark--TableView代理方法
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


@end
