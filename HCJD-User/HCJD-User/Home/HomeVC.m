//
//  HomeVC.m
//  HCJD-User
//
//  Created by ZhangZi Long on 16/12/27.
//  Copyright © 2016年 JinNing. All rights reserved.
//

#import "HomeVC.h"
#import "homeModel.h"
#import "homeModelGroup.h"
#import "homeTableViewCell.h"
#import "HomeDetailViewController.h"
#import "CarCollectionView.h"
#import "MyTeamViewController.h"
#import "CityViewController.h"
@interface HomeVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataSource;
    //第一个头视图的View
    UIView *_fristHeaderView;
    //第二个透视图的View
    UIView *_secondHeaderView;
  
    //城市选择
    UILabel *_mapLabel;
    
    
    
}
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [[NSMutableArray alloc]init];
    
    
    //创建tableView
    [self createTableView];
    [self getDataSource];
    
    //收藏车的数量
    [self carCollection];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - 收藏车的数量
- (void)carCollection{
    CarCollectionView *carView = [[CarCollectionView alloc]initWithFrame:CGRectMake(kScreenWidth-80, kScreenHeight-150, 60, 60) withNumber:1];
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


#pragma mark - 创建tableView
- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kRGB(245, 245, 245);
    _tableView.rowHeight = kScreenWidth/3*2;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"homeTableViewCell" bundle:nil] forCellReuseIdentifier:@"homeCell"];
    [self.view addSubview:_tableView];
 
}

#pragma mark - 数据源
- (void)getDataSource{
    for (int i = 0; i < 2; i++) {
        homeModelGroup *group = [[homeModelGroup alloc]init];
        for (int j = 0; j < 5; j++) {
            homeModel *model = [[homeModel alloc]init];
            model.money = [NSString stringWithFormat:@"定金:¥2%d%d",j,j];
            [group.carModelGroup addObject:model];
        }
       
        [_dataSource addObject:group];
    }
   
    [_tableView reloadData];
}




#pragma mark - 数据源方法
//返回指定的组数,如果是多组，必须实现这个方法，返回指定组数，如果是一组，这个方法可以不实现，默认是一组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _dataSource.count;
}
//返回指定组的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //首先根据组号取出组模型
    homeModelGroup * carGroup = _dataSource[section];
    //根据组模型中的数组的个数返回行数
    return carGroup.carModelGroup.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   homeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //首先根据组号拿出组模型
    homeModelGroup * carGroup = _dataSource[indexPath.section];
    //再根据行号拿出汽车对象
    homeModel * car = carGroup.carModelGroup[indexPath.row];
    if (indexPath.section == 0) {
        cell.carImageView.image = [UIImage imageNamed:@"a"];
    }else{
        cell.carImageView.image = [UIImage imageNamed:@"b"];
    }
   
    
    cell.moneyLabel.text = car.money;
    
    
    return cell;
}


#pragma mark - 选中事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeDetailViewController *vc = [[HomeDetailViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
   
}



#pragma mark - 通过协议方法动态指定组头部高度
//动态指定组头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return kScreenWidth/3*2+(kScreenWidth - 60)/6.2+30+50;
    }
    return 100;
}
#pragma mark - 组头视图和尾视图
//设置视图后标题无效
//【注】头部视图和尾部视图创建可以没有frame，但是需要统一指定高度，或者动态的指定高度，没有高度不显示。
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
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

#pragma mark - 布局上部头部视图
- (void)topView:(UIView*)view{
    
    //背景视图
    UIImageView *topImageView = [[UIImageView alloc]init];
    topImageView.image = [UIImage imageNamed:@"backg"];
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
    _mapLabel.text = @"郑州";
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
    .rightSpaceToView(topImageView,10)
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
    label2.text = @"1000km";
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

//========单点城市定位选则================
- (void)tapHandleDingWei{
    CityViewController *vc = [[CityViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
    [vc chuanZhi:^(NSString *str) {
        _mapLabel.text = str;
    }];
    
}
//======单点客服========================
- (void)tapHandleKeFu{
    
}
//===========自选车=====================
- (void)tapHandleselectCar{
    [[NSUserDefaults standardUserDefaults]setObject:@"carOne" forKey:@"car"];
    self.tabBarController.selectedIndex = 1;
}
//==========婚车套餐====================
- (void)tapHandtaocan{
    [[NSUserDefaults standardUserDefaults]setObject:@"carTwo" forKey:@"car"];
    self.tabBarController.selectedIndex = 1;
}
//==========查看更多====================
- (void)tapHandmore{
   [[NSUserDefaults standardUserDefaults]setObject:@"carOne" forKey:@"car"];
    self.tabBarController.selectedIndex = 1;

}

#pragma mark - 婚车套餐推荐
- (void)taoCanTuiJian:(UIView*)view{
    UIImageView *topImageView = [[UIImageView alloc]init];
    topImageView.image = [UIImage imageNamed:@"backg"];
    [view addSubview:topImageView];
    topImageView.sd_layout
    .topSpaceToView(view,-20)
    .leftSpaceToView(view,0)
    .rightSpaceToView(view,0)
    .heightIs(80);
    
    
    //============婚车推荐  查看更多按钮==================
    UIView *moreView = [[UIView alloc]init];
    moreView.backgroundColor = [UIColor whiteColor];
    [view addSubview:moreView];
    moreView.sd_layout
    .bottomSpaceToView(view,0)
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

//=======婚车套餐查看更多==========
- (void)tapHandtaocanmore{
    [[NSUserDefaults standardUserDefaults]setObject:@"carTwo" forKey:@"car"];
    self.tabBarController.selectedIndex = 1;
}




@end






































