//
//  MyFavoriteVC.m
//  HCJD-User
//
//  Created by ZhangZi Long on 17/1/4.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import "MyFavoriteVC.h"
#import "FavoriteCell.h"
#import "ZiXuanDetailViewController.h"
#import "TaoCanDetailViewController.h"

#import "ProductModel.h"
#import "ProductGroupModel.h"
#import "FavoriteModel.h"

typedef NS_ENUM(NSInteger,Refresh_Status) {
    Refresh_normal = 0,//不刷新状态
    Refresh_Head,//下拉刷新
    Refresh_Foot //上拉加载
};

@interface MyFavoriteVC ()<UITableViewDelegate,UITableViewDataSource>{
    MNDownLoad *_downLoad;
    
    NSMutableArray *_favoriteArr;
    
    NSInteger currentPage;//当前页
    
    NSInteger maxPages;//总页数
    
    Refresh_Status _refreshStatus;//刷新状态
    
}

@end

@implementation MyFavoriteVC

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的收藏";
    
    _favoriteArr = [NSMutableArray array];
    
    currentPage = 0;
    
    _downLoad = [MNDownLoad shareManager];
    
    [self createTableView];
    
    [self getDataSource];
    
    [self addMJRefresh];
    
}

#pragma mark--设置刷新
- (void)addMJRefresh{
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
    _favTableView.mj_header = header;
    
    
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
    _favTableView.mj_footer = footer;
}
- (void)headRefresh{
    //当前页从零开始
    currentPage = 0;
    //修改刷新状态
    _refreshStatus = Refresh_Head;
    //进入刷新状态
    [_favTableView.mj_header beginRefreshing];
    //获取第一页的数据
    [self getDataSource];//自选数据
}
- (void)footRefresh{
    //如果当前页大于最大页数，停止加载
    if (currentPage > maxPages-1) {
        [_favTableView.mj_footer endRefreshing];
    }else{//如果当前页小于最大页数，继续加载
        //修改刷新状态
        _refreshStatus = Refresh_Foot;
        //进入加载状态
        [_favTableView.mj_footer beginRefreshing];
        //获取下一页数据自选数据
        [self getDataSource];
        
    }
}

#pragma mark--创建tableView
- (void)createTableView{
    _favTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _favTableView.delegate = self;
    _favTableView.dataSource = self;
    _favTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_favTableView];
    
    [_favTableView registerNib:[UINib nibWithNibName:@"FavoriteCell" bundle:nil] forCellReuseIdentifier:@"FavoriteCell"];
}
#pragma mark--数据源(附带加载动画)
- (void)getDataSource{
    
    currentPage++;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)currentPage] forKey:@"page"];
    [_downLoad POST:@"collectList" param:param success:^(NSDictionary *dic) {
        
        //最大页数
        maxPages = [dic[@"page_pages"] integerValue];
        
        NSArray *returnArr = dic[@"return"];
        if (!kArrayIsEmpty(returnArr)) {
            
            if (_refreshStatus == Refresh_Head) {
                [_favTableView.mj_header endRefreshing];
                //清理数据源
                [_favoriteArr removeAllObjects];
            }else if (_refreshStatus == Refresh_Foot){
                [_favTableView.mj_footer endRefreshing];
            }
            
            _refreshStatus = Refresh_normal;
            
            for (NSDictionary *favDic in dic[@"return"]) {
                FavoriteModel *favModel = [[FavoriteModel alloc]init];
                [favModel setupValueWith:favDic];
                [_favoriteArr addObject:favModel];
            }
            [_favTableView reloadData];
        }else{
            [_favTableView.mj_header endRefreshing];
            [_favTableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSError *error) {
        
    } withSuperView:self];
}

#pragma mark--数据源
- (void)getDataSourceWithoutGif{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"1" forKey:@"page"];
    [_downLoad POSTWithoutGitHUD:@"collectList" param:param success:^(NSDictionary *dic) {
        
        NSArray *returnArr = dic[@"return"];
        if (!kArrayIsEmpty(returnArr)) {
            for (NSDictionary *favDic in dic[@"return"]) {
                FavoriteModel *favModel = [[FavoriteModel alloc]init];
                [favModel setupValueWith:favDic];
                [_favoriteArr addObject:favModel];
            }
        }
        
        [_favTableView reloadData];
        
    } failure:^(NSError *error) {
        
    } withSuperView:self];
}


#pragma mark--tableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _favoriteArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavoriteCell" forIndexPath:indexPath];
    
    FavoriteModel *model = _favoriteArr[indexPath.row];
    if (model.type == YES) {
        ProductModel *product = [[ProductModel alloc]init];
        [product setupValueWith:model.product_info];
        [cell setupProductValueWith:product];
    }else{
        ProductGroupModel *group = [[ProductGroupModel alloc]init];
        [group setupValueWith:model.group_info];
        [cell setupGroupValueWith:group];
        [cell weatherHidden];
    }
    cell.cancelBlock = ^{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        NSString *favType;
        if (model.type == YES) {
            favType = @"product";
        }else{
            favType = @"group";
        }
        [param setObject:favType forKey:@"type"];
        [param setObject:model.product_id forKey:@"product_id"];
        [_downLoad POST:@"collectCancel" param:param success:^(NSDictionary *dic) {
            
            [_favoriteArr removeObject:model];
            [tableView reloadData];
        } failure:^(NSError *error) {
            
        } withSuperView:self];
    };
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 155;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FavoriteModel *model = _favoriteArr[indexPath.row];
    if (model.type == NO) {
        ProductGroupModel *group = [[ProductGroupModel alloc]init];
        [group setupValueWith:model.group_info];
        
        TaoCanDetailViewController *vc = [[TaoCanDetailViewController alloc]init];
        vc.productGroupModel = group;
        vc.changeFavoriteBlock = ^{
            [_favoriteArr removeAllObjects];
            [self getDataSourceWithoutGif];
        };
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ProductModel *product = [[ProductModel alloc]init];
        [product setupValueWith:model.product_info];
        ZiXuanDetailViewController *vc = [[ZiXuanDetailViewController alloc]init];
        vc.productModel = product;
        vc.changeFavoriteBlock = ^{
            [_favoriteArr removeAllObjects];
            [self getDataSourceWithoutGif];
        };
        vc.view.backgroundColor = [UIColor whiteColor];
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
