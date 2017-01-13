//
//  FindCarVC.m
//  HCJD-User
//
//  Created by ZhangZi Long on 16/12/27.
//  Copyright © 2016年 JinNing. All rights reserved.
//

#import "FindCarVC.h"
#import "HCYXCell.h"//套餐cell
#import "HCYXSelfCell.h"//自选车cell
#import "ZiXuanDetailViewController.h"//自选Cell详情
#import "TaoCanDetailViewController.h"//套餐Cell详情
#import "CarCollectionView.h"//购物车悬浮按钮
#import "MyTeamViewController.h"//我的车队


#import "ProductModel.h"
#import "ProductGroupModel.h"


@interface FindCarVC ()<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *_findSelfTableView;//自选
    
    UITableView *_findTableView;//套餐
    
    NSInteger _flag;//判断分段控制器在哪一段
    
    CarCollectionView *carView;//收藏
    
    UIView *segmentView;//分段控制器
    
    MNDownLoad *_downLoad;
    
    NSInteger page;//当前页
    NSInteger pages;//总页数
    
    NSMutableArray *_modelArr;
    
}

@end

@implementation FindCarVC

- (void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (_findTableView || _findSelfTableView || carView || segmentView) {
        [_findTableView removeFromSuperview];//移除套餐
        [_findSelfTableView removeFromSuperview];//移除自选
        [carView removeFromSuperview];//移除右下角悬浮按钮
        [segmentView removeFromSuperview];//移除分段控制视图
    }
    
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"car"];
    if (str.length > 1) {
        if ([str isEqualToString:@"carOne"]) {
            _flag = 0;
        }else{
            _flag = 1;
        }
        
    }
    //把默认选中的分段控制重置
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"car"];
    
    [self createSgcView];
    
    [self createFindCarTableView];
    
    [self carCollection];
}
 
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"婚车预选";
    
    _downLoad = [MNDownLoad shareManager];
    
    
    page = 0;//默认初始第一页
    
}


#pragma mark--数据源
- (void)getDataWithCtl:(NSString *)ctl withTableView:(UITableView *)tableview{
    
    //产品数据模块
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)page]  forKey:@"page"];
    
    [_downLoad POST:ctl param:param success:^(NSDictionary *dic) {
        
        
//        NSLog(@"%@---%@---%@",dic,dic[@"info"],param);
        
        NSArray *returnArr = dic[@"return"];
        
        for (NSDictionary *productDic in returnArr) {
            //判断ctl
            if ([ctl isEqualToString:@"productList"]) {
                ProductModel *model = [[ProductModel alloc]init];
                [model setupValueWith:productDic];
                [_modelArr addObject:model];
            }else if ([ctl isEqualToString:@"productGroupList"]){
                ProductGroupModel *model = [[ProductGroupModel alloc]init];
                [model setupValueWith:productDic];
                [_modelArr addObject:model];
            }
            
        }
        
        [tableview reloadData];
        
    } failure:^(NSError *error) {
        
    } withSuperView:self];
}

#pragma mark - 收藏车的数量
- (void)carCollection{
    
   carView = [[CarCollectionView alloc]initWithFrame:CGRectMake(kScreenWidth-80, kScreenHeight-150-64, 60, 60) withNumber:1];
    carView.layer.cornerRadius = 30;
    carView.layer.masksToBounds = YES;
    [self.view addSubview:carView];
   
    
    //添加点击事件
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handle)];
    [carView addGestureRecognizer:tgr];
    
}
- (void)handle{
    MyTeamViewController *vc = [[MyTeamViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark--创建UISegmentedControl（分段控制）
- (void)createSgcView{
    segmentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    segmentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:segmentView];
    
    UISegmentedControl *sgc = [[UISegmentedControl alloc]initWithItems:@[@"自选车",@"套餐"]];
    sgc.frame = CGRectMake(50, 12, kScreenWidth-100, 40);
    //设置默认选中板块
    sgc.selectedSegmentIndex = _flag;
    //设置填充颜色
    sgc.tintColor = [UIColor redColor];
    //设置选中状态字体颜色和大小
    [sgc setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    //设置正常状态字体颜色和大小
    [sgc setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
    //添加点击事件
    [sgc addTarget:self action:@selector(changeIndex:) forControlEvents:UIControlEventValueChanged];
    
    [segmentView addSubview:sgc];
}
//sgc点击事件
- (void)changeIndex:(UISegmentedControl *)sgc{
    
    [_modelArr removeAllObjects];//清空数据
    
    if (sgc.selectedSegmentIndex == 0) {
        
        _flag = 0;
        
        //自选
        NSLog(@"-----%ld",(long)sgc.selectedSegmentIndex);
        
        [_findTableView removeFromSuperview];//移除套餐
        
        _findSelfTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49-64) style:UITableViewStylePlain];
        _findSelfTableView.backgroundColor = grayBG;
        _findSelfTableView.delegate = self;
        _findSelfTableView.dataSource = self;
        [self.view addSubview:_findSelfTableView];//添加自选
        [_findSelfTableView registerNib:[UINib nibWithNibName:@"HCYXSelfCell" bundle:nil] forCellReuseIdentifier:@"firstcell"];
        [self.view bringSubviewToFront:carView];
        
        [self getDataWithCtl:@"productList" withTableView:_findSelfTableView];//自选数据
        
    }else if (sgc.selectedSegmentIndex == 1){
        
        _flag = 1;
        
        //套餐
        NSLog(@"=====%ld",(long)sgc.selectedSegmentIndex);
        
        [_findSelfTableView removeFromSuperview];//移除自选
        
        //套餐tableView
        _findTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49-64) style:UITableViewStylePlain];
        _findTableView.backgroundColor = grayBG;
        _findTableView.delegate = self;
        _findTableView.dataSource = self;
        [self.view addSubview:_findTableView];//添加套餐
        [_findTableView registerNib:[UINib nibWithNibName:@"HCYXCell" bundle:nil] forCellReuseIdentifier:@"secondcell"];
        [self.view bringSubviewToFront:carView];
        
        [self getDataWithCtl:@"productGroupList" withTableView:_findTableView];//套餐数据
    }
}

#pragma mark--创建tableView
- (void)createFindCarTableView{
    _modelArr = [NSMutableArray array];
    if (_flag == 0) {
        //自选tableView
        _findSelfTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49-64) style:UITableViewStylePlain];
        _findSelfTableView.backgroundColor = grayBG;
        _findSelfTableView.delegate = self;
        _findSelfTableView.dataSource = self;
        _findSelfTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_findSelfTableView];
        
        [_findSelfTableView registerNib:[UINib nibWithNibName:@"HCYXSelfCell" bundle:nil] forCellReuseIdentifier:@"firstcell"];
        
        [self getDataWithCtl:@"productList" withTableView:_findSelfTableView];//自选数据
        
    }else if (_flag == 1){
        
        //套餐tableView
        _findTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49-64) style:UITableViewStylePlain];
        _findTableView.backgroundColor = grayBG;
        _findTableView.delegate = self;
        _findTableView.dataSource = self;
        _findTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_findTableView];
        
        [_findTableView registerNib:[UINib nibWithNibName:@"HCYXCell" bundle:nil] forCellReuseIdentifier:@"secondcell"];
        
        [self getDataWithCtl:@"productGroupList" withTableView:_findTableView];//套餐数据
    }
    
}
#pragma mark--tableView代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (_flag == 0) {
        HCYXSelfCell *cellZiXuan = [tableView dequeueReusableCellWithIdentifier:@"firstcell" forIndexPath:indexPath];
        //重新给Cell赋值
        [cellZiXuan setupValueWithModel:_modelArr[indexPath.row]];
        
        cell = cellZiXuan;
    }else if (_flag == 1){
        HCYXCell *cellTaoCan = [tableView dequeueReusableCellWithIdentifier:@"secondcell" forIndexPath:indexPath];
        //重新给Cell赋值
        [cellTaoCan setupValueWithModel:_modelArr[indexPath.row]];
        cell = cellTaoCan;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger rowHeight;
    
    if (_flag == 0) {
        rowHeight = 64+220*kScaleWidth;
    }else if(_flag == 1){
        rowHeight = 92+220*kScaleWidth;
    }
    
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_flag == 0) {
#pragma mark--进入自选详情页
        
        ProductModel *model = [[ProductModel alloc]init];
        model = _modelArr[indexPath.row];
        ZiXuanDetailViewController *vc = [[ZiXuanDetailViewController alloc]init];
        vc.productModel = model;
        vc.view.backgroundColor = grayBG;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (_flag == 1){
#pragma mark--进入套餐详情页
        
        ProductGroupModel *model = [[ProductGroupModel alloc]init];
        model = _modelArr[indexPath.row];
        TaoCanDetailViewController *vc = [[TaoCanDetailViewController alloc]init];
        vc.productGroupModel = model;
        vc.view.backgroundColor = grayBG;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
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
