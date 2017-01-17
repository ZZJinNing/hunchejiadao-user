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


typedef NS_ENUM(NSInteger,Refresh_Status) {
    Refresh_normal = 0,//不刷新状态
    Refresh_Head,//下拉刷新
    Refresh_Foot //上拉加载
};


@interface FindCarVC ()<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *_findSelfTableView;//自选
    
    UITableView *_findTableView;//套餐
    
    NSInteger _flag;//判断分段控制器在哪一段
    
    CarCollectionView *carView;//收藏
    
    UIView *segmentView;//分段控制器
    
    MNDownLoad *_downLoad;
    
    NSMutableArray *_modelArr;
    
    NSInteger currentPage;//当前页
    NSInteger maxPages;//总页数
    Refresh_Status _refreshStatus;//刷新状态
    
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
    
//    currentPage = 0;//默认初始第一页
    
}

#pragma mark--设置刷新
- (void)addMJRefreshWithTableView:(UITableView *)tableView{
    //下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self headRefresh];
    }];
    //设置刷新提示语句
    [header setTitle:@"继续下拉可进行刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开可刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新中" forState:MJRefreshStateRefreshing];
    //设置字体和文字
    header.stateLabel.font=[UIFont systemFontOfSize:13];
    
    //设置蚊子颜色
    header.stateLabel.textColor=[UIColor redColor];
    
    //设置隐藏
    header.stateLabel.textColor=[UIColor redColor];
    
    //最后一次刷新时间是否隐藏
    header.lastUpdatedTimeLabel.hidden=YES;
    tableView.mj_header = header;
    
    
    //上拉加载
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self footRefresh];
    }];
    // 设置文字
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:13];
    // 设置颜色
    footer.stateLabel.textColor = [UIColor grayColor];
    tableView.mj_footer = footer;
}

- (void)headRefresh{
    //当前页从零开始
    currentPage = 0;
    //修改刷新状态
    _refreshStatus = Refresh_Head;
    
    if (_flag == 0) {
        //进入刷新状态
        [_findSelfTableView.mj_header beginRefreshing];
        //获取第一页的数据
        [self getDataWithCtl:@"productList" withTableView:_findSelfTableView];//自选数据
    }else{
        //进入刷新状态
        [_findTableView.mj_header beginRefreshing];
        //获取第一页的数据
        [self getDataWithCtl:@"productGroupList" withTableView:_findTableView];//套餐数据
    }
}
- (void)footRefresh{
    //如果当前页大于最大页数，停止加载
    if (currentPage > maxPages-1) {
        if (_flag == 0) {
            [_findSelfTableView.mj_footer endRefreshing];
        }else{
            [_findTableView.mj_footer endRefreshing];
        }
    }else{//如果当前页小于最大页数，继续加载
        //修改刷新状态
        _refreshStatus = Refresh_Foot;
        if (_flag == 0) {
            //进入加载状态
            [_findSelfTableView.mj_footer beginRefreshing];
            //获取下一页数据自选数据
            [self getDataWithCtl:@"productList" withTableView:_findSelfTableView];
        }else{
            //进入加载状态
            [_findTableView.mj_footer beginRefreshing];
            //获取下一页数据套餐数据
            [self getDataWithCtl:@"productGroupList" withTableView:_findSelfTableView];
        }
    }
}

#pragma mark--数据源
- (void)getDataWithCtl:(NSString *)ctl withTableView:(UITableView *)tableview{
    
    currentPage++;
    
    //数据模块
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)currentPage]  forKey:@"page"];
    
    [_downLoad POST:ctl param:param success:^(NSDictionary *dic) {
        
//        NSLog(@"%@---%@---%@",dic,dic[@"info"],param);
        
        //最大页数
        maxPages = [dic[@"page_pages"] integerValue];
        
        NSArray *returnArr = dic[@"return"];
        if (!kArrayIsEmpty(returnArr)) {
            
            if (_refreshStatus == Refresh_Head) {
                [tableview.mj_header endRefreshing];
                //清理数据源
                [_modelArr removeAllObjects];
            }else if (_refreshStatus == Refresh_Foot){
                [tableview.mj_footer endRefreshing];
            }
            
            _refreshStatus = Refresh_normal;
            
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
        }else{
            [tableview.mj_header endRefreshing];
            [tableview.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        
    } withSuperView:self];
}

#pragma mark--车队数量
- (void)carCollection{
    NSString *cart_num = [[NSUserDefaults standardUserDefaults]objectForKey:HCJDCart_num];
    carView = [[CarCollectionView alloc]initWithFrame:CGRectMake(kScreenWidth-80, kScreenHeight-150-64, 60, 60) withNumber:[cart_num integerValue]];
    carView.layer.cornerRadius = 30;
    carView.layer.masksToBounds = YES;
    [self.view addSubview:carView];
   
    
    //添加点击事件
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handle)];
    [carView addGestureRecognizer:tgr];
    
}
#pragma mark--我的收藏
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
#pragma mark--sgc点击事件
- (void)changeIndex:(UISegmentedControl *)sgc{
    
    [_modelArr removeAllObjects];//清空数据
    
    if (sgc.selectedSegmentIndex == 0) {
        
        _flag = 0;
        
        [_findTableView removeFromSuperview];//移除套餐
        //自选tableView
        [self createZiXuanTableView];
        
    }else if (sgc.selectedSegmentIndex == 1){
        
        _flag = 1;
        
        [_findSelfTableView removeFromSuperview];//移除自选
        
        [self createTanCanTableView];
    }
}
#pragma mark--创建tableView
- (void)createFindCarTableView{
    _modelArr = [NSMutableArray array];
    if (_flag == 0) {
        //自选tableView
        [self createZiXuanTableView];
        
    }else if (_flag == 1){
        
        //套餐tableView
        [self createTanCanTableView];
    }
}
//自选tableView
- (void)createZiXuanTableView{
    //当前页从零开始
    currentPage = 0;
    
    _findSelfTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49-64) style:UITableViewStylePlain];
    _findSelfTableView.backgroundColor = grayBG;
    _findSelfTableView.delegate = self;
    _findSelfTableView.dataSource = self;
    _findSelfTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_findSelfTableView];//添加自选
    [_findSelfTableView registerNib:[UINib nibWithNibName:@"HCYXSelfCell" bundle:nil] forCellReuseIdentifier:@"firstcell"];
    [self.view bringSubviewToFront:carView];
    
    [self getDataWithCtl:@"productList" withTableView:_findSelfTableView];//自选数据
    [self addMJRefreshWithTableView:_findSelfTableView];//添加刷新功能
}
//套餐tableView
- (void)createTanCanTableView{
    //当前页从零开始
    currentPage = 0;
    
    _findTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49-64) style:UITableViewStylePlain];
    _findTableView.backgroundColor = grayBG;
    _findTableView.delegate = self;
    _findTableView.dataSource = self;
    _findTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_findTableView];
    
    [_findTableView registerNib:[UINib nibWithNibName:@"HCYXCell" bundle:nil] forCellReuseIdentifier:@"secondcell"];
    
    [self getDataWithCtl:@"productGroupList" withTableView:_findTableView];//套餐数据
    [self addMJRefreshWithTableView:_findTableView];//添加刷新功能
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
