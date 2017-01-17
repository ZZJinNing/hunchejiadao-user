//
//  HomeVC.m
//  HCJD-User
//
//  Created by ZhangZi Long on 16/12/27.
//  Copyright © 2016年 JinNing. All rights reserved.
//

#import "HomeVC.h"
#import "ZiXuanDetailViewController.h"
#import "TaoCanDetailViewController.h"
#import "CarCollectionView.h"
#import "MyTeamViewController.h"
#import "CityViewController.h"
#import "ProductModel.h"
#import "ProductGroupModel.h"
#import "homeTableViewCell.h"
#import "homeTaoCanTableViewCell.h"


typedef NS_ENUM(NSInteger,Refresh_Status) {
    Refresh_normal = 0,//不刷新状态
    Refresh_Head,//下拉刷新
    Refresh_Foot //上拉加载
};

@interface HomeVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    
    NSMutableArray *_dataSource;
    
    //==========第一个头视图的View==================
    UIView *_fristHeaderView;
    //城市选择
    UILabel *_mapLabel;
    //城市
    NSString *_cityName;
    //背景图
    NSString *_bgImageStr;
    //行程
    NSString *_liChengStr;
    
    //==========第二个头视图的View=================
    UIView *_secondHeaderView;
    
    //自选产品model数据
    NSMutableArray *_productArr;
    
    //套餐产品model数据
    NSMutableArray *_groupArr;
    
    //车队数量
    NSInteger cart_num;
    
    //车队数量视图
    CarCollectionView *_carView;
    
    Refresh_Status _refreshStatus;//刷新状态
    
}
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _productArr = [NSMutableArray array];
    _groupArr = [NSMutableArray array];
    _dataSource = [[NSMutableArray alloc]init];
    
    //创建tableView
    [self createTableView];
    
    //收藏车的数量
    [self carCollection];
    
    //获取数据
    [self getDataSource];
    
    //请求获取车队数量
    [self getCartNum];
    
    //刷新功能
    [self addMJRefresh];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
    _tableView.mj_header = header;
}
- (void)headRefresh{
    
    //修改刷新状态
    _refreshStatus = Refresh_Head;
    //进入刷新状态
    [_tableView.mj_header beginRefreshing];
    //获取第一页的数据
    [self getDataSource];//套餐数据
}


#pragma mark--请求获取车队数量
- (void)getCartNum{
    //获取用户的账号密码
    NSString *phoneStr = [[NSUserDefaults standardUserDefaults]objectForKey:HCJDPhone];
    NSString *password = [[NSUserDefaults standardUserDefaults]objectForKey:HCJDPassword];
    //判断获取到的账号密码是否存在
    if ([phoneStr isEqualToString:@""]&&[password isEqualToString:@""]) {
        cart_num = 0;
        _carView.numberLable.text = [NSString stringWithFormat:@"%ld",(long)cart_num];
        //保存cart_num
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)cart_num] forKey:HCJDCart_num];
    }else{
        [[MNDownLoad shareManager] POSTWithoutGitHUD:@"cartNum" param:nil success:^(NSDictionary *dic) {
            
            NSInteger status = [dic[@"status"] integerValue];
            if (status == 1) {
                cart_num = [dic[@"return"][@"cart_num"] integerValue];
                _carView.numberLable.text = [NSString stringWithFormat:@"%ld",(long)cart_num];
                //保存cart_num
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)cart_num] forKey:HCJDCart_num];
            }
        } failure:^(NSError *error) {
            
        } withSuperView:self];
    }
    
}

#pragma mark - 收藏车View
- (void)carCollection{
    _carView = [[CarCollectionView alloc]initWithFrame:CGRectMake(kScreenWidth-80, kScreenHeight-150, 60, 60) withNumber:0];
    _carView.layer.cornerRadius = 30;
    _carView.layer.masksToBounds = YES;
    [self.view addSubview:_carView];
    
    //添加点击事件
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handle)];
    [_carView addGestureRecognizer:tgr];
}
#pragma mark--点击收藏
- (void)handle{
    MyTeamViewController *vc = [[MyTeamViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 创建tableView
- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kRGB(245, 245, 245);
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [_tableView registerNib:[UINib nibWithNibName:@"homeTableViewCell" bundle:nil] forCellReuseIdentifier:@"homeCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"homeTaoCanTableViewCell" bundle:nil] forCellReuseIdentifier:@"homeTaocanCell"];
    
    [self.view addSubview:_tableView];
 
}

#pragma mark - 数据源
- (void)getDataSource{
    
    [[MNDownLoad shareManager] POST:@"indexData" param:nil success:^(NSDictionary *dic) {
        
        if (_refreshStatus == Refresh_Head) {
            [_tableView.mj_header endRefreshing];
            //清理数据源
            [_dataSource removeAllObjects];
        }
        _refreshStatus = Refresh_normal;
        
        //背景图url
        _bgImageStr = [NSString stringWithFormat:@"%@",dic[@"return"][@"ad_info"][@"image"]];
        //总的行程
        _liChengStr = [NSString stringWithFormat:@"%@",dic[@"return"][@"mile_total"]];
        //当前城市名
        _cityName = [NSString stringWithFormat:@"%@",dic[@"return"][@"city_name"]];
        
        //得到自选产品数据和套餐产品数据
        NSArray *product_list = dic[@"return"][@"product_list"];
        NSArray *group_list = dic[@"return"][@"group_list"];
        
        if (kArrayIsEmpty(product_list)&&kArrayIsEmpty(group_list)) {
            _productArr = @[].mutableCopy;
            _groupArr = @[].mutableCopy;
            [_dataSource addObject:_productArr];
            [_dataSource addObject:_groupArr];
            
            [_tableView reloadData];
            return ;
        }
        
        //给数据源数组添加model
        if (!kArrayIsEmpty(product_list)) {
            for (NSDictionary *productDic in product_list) {
                ProductModel *model = [[ProductModel alloc]init];
                [model setupValueWith:productDic];
                [_productArr addObject:model];
            }
        }else{
            _productArr = @[].mutableCopy;
        }
        if (!kArrayIsEmpty(group_list)) {
            for (NSDictionary *groupDic in group_list) {
                ProductGroupModel *model = [[ProductGroupModel alloc]init];
                [model setupValueWith:groupDic];
                [_groupArr addObject:model];
            }
        }else{
            _groupArr = @[].mutableCopy;
        }
        
        //将数据源数组添加到_dataSource,用来确认区数
        [_dataSource addObject:_productArr];
        [_dataSource addObject:_groupArr];
        
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    } withSuperView:self];
    
}

#pragma mark - TableView代理方法
//返回指定的组数,如果是多组，必须实现这个方法，返回指定组数，如果是一组，这个方法可以不实现，默认是一组
//返回两个区（产品区和套餐区）
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}
//返回指定组的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *array = _dataSource[section];
    
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        //自选
        homeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeCell" forIndexPath:indexPath];
        
        ProductModel *productmodel = _productArr[indexPath.row];
        
        [cell setupValueWithModel:productmodel];
        
        return cell;
        
    }else if(indexPath.section == 1){
        //套餐
        homeTaoCanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeTaocanCell" forIndexPath:indexPath];
        
        ProductGroupModel *groupmodel = _groupArr[indexPath.row];
        
        [cell setupValueWithModel:groupmodel];
        
        return cell;
    }else{
        return nil;
    }
}

//动态指定某一个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return kScreenWidth + 60;
    }else{
        return kScreenWidth + 100;
    }
}
#pragma mark - cell选中事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //自选产品详情
        ProductModel * productmodel = _productArr[indexPath.row];
        ZiXuanDetailViewController *vc = [[ZiXuanDetailViewController alloc]init];
        vc.productModel = productmodel;
        vc.view.backgroundColor = grayBG;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //套餐产品详情
        ProductGroupModel * groupmodel = _groupArr[indexPath.row];
        TaoCanDetailViewController *vc = [[TaoCanDetailViewController alloc]init];
        vc.productGroupModel = groupmodel;
        vc.view.backgroundColor = grayBG;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - tableView区头高度设定
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return kScreenWidth/3*2+(kScreenWidth - 60)/6.2+30+50;
    }else{
        return 20;
    }
}
#pragma mark - 区头和区尾
//设置视图后标题无效
//【注】头部视图和尾部视图创建可以没有frame，但是需要统一指定高度，或者动态的指定高度，没有高度不显示。
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        _fristHeaderView = [[UIView alloc]init];
        _fristHeaderView.backgroundColor = grayBG;
        [self topView:_fristHeaderView];
        return _fristHeaderView;
    }else{
        _secondHeaderView = [[UIView alloc] init];
        [self taoCanTuiJian:_secondHeaderView];
        return _secondHeaderView;
    }
}

#pragma mark - 顶部视图
- (void)topView:(UIView*)view{
    //背景视图
    UIImageView *topImageView = [[UIImageView alloc]init];
    [topImageView sd_setImageWithURL:[NSURL URLWithString:_bgImageStr] placeholderImage:[UIImage imageNamed:@"placeHold"]];
    topImageView.userInteractionEnabled = YES;
    [view addSubview:topImageView];
    topImageView.sd_layout
    .topSpaceToView(view,0)
    .leftSpaceToView(view,0)
    .rightSpaceToView(view,0)
    .heightIs(kScreenWidth/3*2);
    
    //============定位标志=======================
    UIView *dingweiView = [[UIView alloc]init];
    dingweiView.backgroundColor = kRGBA(138, 110, 109,0.5);
    dingweiView.layer.masksToBounds = YES;
    dingweiView.layer.cornerRadius = 20;
    [topImageView addSubview:dingweiView];
    dingweiView.sd_layout
    .topSpaceToView(topImageView,30)
    .leftSpaceToView(topImageView,15)
    .widthIs(110)
    .heightIs(40);
    
    //给dingweiView添加点击事件
    UITapGestureRecognizer * tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandleDingWei)];
    [dingweiView addGestureRecognizer:tgr];
    
    
    //地图图标
    UIImageView *mapImageView = [[UIImageView alloc]init];
    mapImageView.image = [UIImage imageNamed:@"ditu"];
    [dingweiView addSubview:mapImageView];
    mapImageView.sd_layout
    .leftSpaceToView(dingweiView,15)
    .centerYEqualToView(dingweiView)
    .widthIs(25)
    .heightIs(25);
    //定位label
    _mapLabel = [[UILabel alloc]init];
    _mapLabel.textAlignment = NSTextAlignmentRight;
    _mapLabel.textColor = [UIColor whiteColor];
    _mapLabel.font = [UIFont systemFontOfSize:19];
    _mapLabel.text = _cityName;
    _mapLabel.adjustsFontSizeToFitWidth = YES;
    [dingweiView addSubview:_mapLabel];
    _mapLabel.sd_layout
    .rightSpaceToView(dingweiView,10)
    .centerYEqualToView(dingweiView)
    .widthIs(50)
    .heightIs(30);
    
    
    //=======客服===============
    UIImageView *kefuImageView = [[UIImageView alloc]init];
    kefuImageView.userInteractionEnabled = YES;
    kefuImageView.image = [UIImage imageNamed:@"icon_kf"];
    [topImageView addSubview:kefuImageView];
    kefuImageView.sd_layout
    .rightSpaceToView(topImageView,20)
    .topSpaceToView(topImageView,30)
    .widthIs(30)
    .heightIs(24);
    //给dingweiView添加点击事件
    UITapGestureRecognizer * kefutgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandleKeFu)];
    [kefuImageView addGestureRecognizer:kefutgr];
    
    
    //===========累计服务里程==================
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"平台累计服务里程";
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:18];
    [topImageView addSubview:label1];
    label1.sd_layout
    .bottomSpaceToView(topImageView,0)
    .leftSpaceToView(topImageView,10)
    .widthIs(kScreenWidth/2)
    .heightIs(50);
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.textColor = [UIColor whiteColor];
    label2.text = [NSString stringWithFormat:@"%@KM",_liChengStr];
    label2.font = [UIFont systemFontOfSize:18];
    label2.textAlignment = NSTextAlignmentRight;
    [topImageView addSubview:label2];
    label2.sd_layout
    .bottomSpaceToView(topImageView,0)
    .rightSpaceToView(topImageView,10)
    .widthIs(kScreenWidth/2)
    .heightIs(50);
    
    //===========自选车  婚车套餐=====================
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    [view addSubview:bgView];
    bgView.sd_layout
    .topSpaceToView(topImageView,0)
    .leftSpaceToView(view,0)
    .rightSpaceToView(view,0)
    .heightIs((kScreenWidth - 60)/6.2+30);
    
    UIImageView *selectCarImage = [[UIImageView alloc]init];
    selectCarImage.userInteractionEnabled = YES;
    selectCarImage.image = [UIImage imageNamed:@"zixuanche"];
    [bgView addSubview:selectCarImage];
    selectCarImage.sd_layout
    .leftSpaceToView(bgView,20)
    .centerYEqualToView(bgView)
    .widthIs((kScreenWidth - 60)/2)
    .heightIs((kScreenWidth - 60)/6.2);
    //给自选车添加点击事件
    UITapGestureRecognizer * selectCartgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandleselectCar)];
    [selectCarImage addGestureRecognizer:selectCartgr];
    
    
    UIImageView *taocanImageView = [[UIImageView alloc]init];
    taocanImageView.image = [UIImage imageNamed:@"taocan"];
    taocanImageView.userInteractionEnabled = YES;
    [bgView addSubview:taocanImageView];
    taocanImageView.sd_layout
    .rightSpaceToView(bgView,20)
    .leftSpaceToView(selectCarImage,20)
    .centerYEqualToView(bgView)
    .heightIs((kScreenWidth - 60)/6.2);
    //给婚车套餐添加点击事件
    UITapGestureRecognizer * taocanCartgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandtaocan)];
    [taocanImageView addGestureRecognizer:taocanCartgr];
    
    //============婚车推荐  查看更多按钮==================
    UIView *moreView = [[UIView alloc]init];
    moreView.backgroundColor = [UIColor whiteColor];
    [view addSubview:moreView];
    moreView.sd_layout
    .bottomSpaceToView(view,0)
    .leftSpaceToView(view,0)
    .rightSpaceToView(view,0)
    .heightIs(40);
    UITapGestureRecognizer * moretgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandmore)];
    [moreView addGestureRecognizer:moretgr];
    
    //点赞图片
    UIImageView *dianzanImageView = [[UIImageView alloc]init];
    dianzanImageView.image = [UIImage imageNamed:@"icon_recommend"];
    [moreView addSubview:dianzanImageView];
    dianzanImageView.sd_layout
    .leftSpaceToView(moreView,10)
    .topSpaceToView(moreView,6)
    .bottomSpaceToView(moreView,6)
    .widthIs(28);
    
    UILabel *tuijianLabel = [[UILabel alloc]init];
    tuijianLabel.text = @"婚车推荐";
    tuijianLabel.textColor = kRGB(240, 50, 50);
    [moreView addSubview:tuijianLabel];
    tuijianLabel.sd_layout
    .leftSpaceToView(dianzanImageView,8)
    .centerYEqualToView(moreView)
    .widthIs(150)
    .heightIs(20);
    
    UILabel *moreLabel = [[UILabel alloc]init];
    moreLabel.textColor = wordColorDark;
    moreLabel.text = @"查看更多";
    moreLabel.textAlignment = NSTextAlignmentRight;
    moreLabel.font = [UIFont systemFontOfSize:15];
    [moreView addSubview:moreLabel];
    moreLabel.sd_layout
    .rightSpaceToView(moreView,15)
    .centerYEqualToView(moreView)
    .heightIs(20)
    .widthIs(150);
 
}

#pragma mark - 城市定位选择
- (void)tapHandleDingWei{
    CityViewController *vc = [[CityViewController alloc]init];
    vc.cityTitle = _cityName;
    [vc chuanZhi:^{
        _dataSource = [[NSMutableArray alloc]init];
        [self getDataSource];
    }];
    [self.navigationController pushViewController:vc animated:YES];
  
}
#pragma mark - 点击客服
- (void)tapHandleKeFu{
    
}
#pragma mark - 自选婚车
- (void)tapHandleselectCar{
    [[NSUserDefaults standardUserDefaults]setObject:@"carOne" forKey:@"car"];
    self.tabBarController.selectedIndex = 1;
}
#pragma mark - 婚车套餐
- (void)tapHandtaocan{
    [[NSUserDefaults standardUserDefaults]setObject:@"carTwo" forKey:@"car"];
    self.tabBarController.selectedIndex = 1;
}

#pragma mark - 自选产品查看更多
- (void)tapHandmore{
   [[NSUserDefaults standardUserDefaults]setObject:@"carOne" forKey:@"car"];
    self.tabBarController.selectedIndex = 1;

}

#pragma mark - 婚车套餐推荐(区头视图)
- (void)taoCanTuiJian:(UIView*)view{
    
    //============婚车推荐  查看更多按钮==================
    UIView *moreView = [[UIView alloc]init];
    moreView.backgroundColor = [UIColor whiteColor];
    [view addSubview:moreView];
    moreView.sd_layout
    .topSpaceToView(view,-20)
    .leftSpaceToView(view,0)
    .rightSpaceToView(view,0)
    .heightIs(40);
    UITapGestureRecognizer * moretgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandtaocanmore)];
    [moreView addGestureRecognizer:moretgr];
    
    //点赞图片
    UIImageView *dianzanImageView = [[UIImageView alloc]init];
    dianzanImageView.image = [UIImage imageNamed:@"icon_recommend"];
    [moreView addSubview:dianzanImageView];
    dianzanImageView.sd_layout
    .leftSpaceToView(moreView,10)
    .topSpaceToView(moreView,6)
    .bottomSpaceToView(moreView,6)
    .widthIs(28);
    
    UILabel *tuijianLabel = [[UILabel alloc]init];
    tuijianLabel.text = @"套餐推荐";
    tuijianLabel.textColor = kRGB(240, 50, 50);
    [moreView addSubview:tuijianLabel];
    tuijianLabel.sd_layout
    .leftSpaceToView(dianzanImageView,8)
    .centerYEqualToView(moreView)
    .widthIs(150)
    .heightIs(20);
    
    UILabel *moreLabel = [[UILabel alloc]init];
    moreLabel.textColor = wordColorDark;
    moreLabel.text = @"查看更多";
    moreLabel.textAlignment = NSTextAlignmentRight;
    moreLabel.font = [UIFont systemFontOfSize:15];
    [moreView addSubview:moreLabel];
    moreLabel.sd_layout
    .rightSpaceToView(moreView,15)
    .centerYEqualToView(moreView)
    .heightIs(20)
    .widthIs(150);

}

#pragma mark - 套餐产品查看更多
- (void)tapHandtaocanmore{
    [[NSUserDefaults standardUserDefaults]setObject:@"carTwo" forKey:@"car"];
    self.tabBarController.selectedIndex = 1;
}

@end



