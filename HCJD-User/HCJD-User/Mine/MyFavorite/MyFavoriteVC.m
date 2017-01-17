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

@interface MyFavoriteVC ()<UITableViewDelegate,UITableViewDataSource>{
    MNDownLoad *_downLoad;
    
    NSInteger page;//当前页
    NSInteger pages;//总页数
    
    NSMutableArray *favoriteArr;
    
    UITableView *favTableView;
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
    
    favoriteArr = [NSMutableArray array];
    
    page = 0;
    
    _downLoad = [MNDownLoad shareManager];
    
    [self createTableView];
    
    [self getDataSource];
    
}
#pragma mark--创建tableView
- (void)createTableView{
    favTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    favTableView.delegate = self;
    favTableView.dataSource = self;
    [self.view addSubview:favTableView];
    
    [favTableView registerNib:[UINib nibWithNibName:@"FavoriteCell" bundle:nil] forCellReuseIdentifier:@"FavoriteCell"];
}
#pragma mark--数据源
- (void)getDataSource{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"1" forKey:@"page"];
    [_downLoad POST:@"collectList" param:param success:^(NSDictionary *dic) {
        
//        NSLog(@"%@",dic);
        
        NSArray *returnArr = dic[@"return"];
        if (!kArrayIsEmpty(returnArr)) {
            for (NSDictionary *favDic in dic[@"return"]) {
                FavoriteModel *favModel = [[FavoriteModel alloc]init];
                [favModel setupValueWith:favDic];
                [favoriteArr addObject:favModel];
            }
        }
        
        [favTableView reloadData];
        
    } failure:^(NSError *error) {
        
    } withSuperView:self];
}

#pragma mark--tableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return favoriteArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavoriteCell" forIndexPath:indexPath];
    
    FavoriteModel *model = favoriteArr[indexPath.row];
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
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 155;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FavoriteModel *model = favoriteArr[indexPath.row];
    if (model.type == NO) {
        ProductGroupModel *group = [[ProductGroupModel alloc]init];
        [group setupValueWith:model.group_info];
        
        TaoCanDetailViewController *vc = [[TaoCanDetailViewController alloc]init];
        vc.productGroupModel = group;
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ProductModel *product = [[ProductModel alloc]init];
        [product setupValueWith:model.product_info];
        ZiXuanDetailViewController *vc = [[ZiXuanDetailViewController alloc]init];
        vc.productModel = product;
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
