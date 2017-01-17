//
//  MyTeamViewController.m
//  HCJD-User
//
//  Created by jiang on 17/1/3.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import "MyTeamViewController.h"
#import "MyTeamTableViewCell.h"
#import "MyTeamModel.h"
#import "settlementMoneyViewController.h"
<<<<<<< HEAD
#import "EmptyView.h"
=======

>>>>>>> 0fda384059193aa1e59d2a4cb7b34788af50ae85
@interface MyTeamViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    
    NSMutableArray *_dataSource;
    EmptyView *_MyEmptyView;//数据源为空的时候显示
    //选中数组
    NSMutableArray *_selectedArray;
    //总价格
    float _totalPrice;
    //总定金
    float _dingjinPrice;
    //是否全选
    BOOL _selectAll;
    //cell上面的按钮是否被选中
    BOOL _selectCellButton;
    //总价格Label；
    UILabel *_AllPriceLabel;
    //定金label
    UILabel *_dingjinLabel;
    //全选按钮
    UIButton *_selectedButton;
    
} 
@end

@implementation MyTeamViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的车队";
    self.view.backgroundColor = grayBG;
    _dataSource = [[NSMutableArray alloc]init];
    _selectedArray = [NSMutableArray new];
    _totalPrice = 0.00;
    _dingjinPrice = 0.00;
    _selectAll = NO;
    _selectCellButton = NO;
<<<<<<< HEAD
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getNotification) name:@"MN_getDataSource" object:nil];
=======
>>>>>>> 0fda384059193aa1e59d2a4cb7b34788af50ae85
    
    [self createTableView];
    
    [self getDataSource];
    //去结算界面
    [self settlementView];
    
    
}

- (void)getNotification{

    
    [_dataSource removeAllObjects];
    [_selectedArray removeAllObjects];
    [_tableView reloadData];
    _dingjinPrice = 0.00;
    _totalPrice = 0.00;
    _selectAll = NO;
    _selectCellButton = NO;
    _dingjinLabel.text = @"定金:0.00元";
    _AllPriceLabel.text = @"总价格:0.00元";
    
    [self getDataSource];
    
}

<<<<<<< HEAD
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:@"MN_getDataSource"];
}


=======
>>>>>>> 0fda384059193aa1e59d2a4cb7b34788af50ae85
#pragma mark - 创建tableView
- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-124)];
    _tableView.backgroundColor = grayBG;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 120;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [_tableView registerClass:[MyTeamTableViewCell class] forCellReuseIdentifier:@"teamCell"];
    [self.view addSubview:_tableView];
}

#pragma mark - 数据源
- (void)getDataSource{
    [_MyEmptyView removeFromSuperview];
    [[MNDownLoad shareManager]POSTWithoutGitHUD:@"cartList" param:nil success:^(NSDictionary *dic) {

        NSString *info = dic[@"info"];
        NSString *status = [NSString stringWithFormat:@"%@",dic[@"status"]];
        if ([status integerValue] == 1) {
            NSArray *returnArray = dic[@"return"];
            for (NSDictionary *returnDic in returnArray) {
                MyTeamModel *model = [[MyTeamModel alloc]init];
                [model parsingModelWithDictionary:returnDic];
                [_dataSource addObject:model];
            }
        }else{
            
            _MyEmptyView = [[EmptyView alloc]initWithFrame:CGRectMake(0, 150, kScreenWidth, 200)];
            [self.view addSubview:_MyEmptyView];
            [MBProgressHUD showSuccess:info toView:self.view];
        }
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    } withSuperView:self];

}

#pragma mark - tableView代理事件
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"teamCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MyTeamModel *model = _dataSource[indexPath.row];
    [cell reloadDataWith:model WithSuperController:self];
    
    
    if (_selectAll) {
        cell.selectedButton.selected = YES;
    }else{
        cell.selectedButton.selected = NO;
    }
    __block MyTeamTableViewCell *weakCell = cell;
    //=====选中按钮事件=====
    cell.cartBlock = ^ (BOOL isSelect){
        if (isSelect) {
            [_selectedArray addObject:model];
            model.isSelect = isSelect;
            [_dataSource replaceObjectAtIndex:indexPath.row withObject:model];
           
        }else{
            model.isSelect = isSelect;
            [_dataSource replaceObjectAtIndex:indexPath.row withObject:model];
            //不是选中
            [_selectedArray removeObject:model];
        }
        
        if (_selectedArray.count == _dataSource.count) {
            _selectedButton.selected = YES;
        }else{
            _selectedButton.selected = NO;
        }
        
        [self CalculateTheTotalPrice];
    };
    
    //========点击删除按钮==========
    cell.delegeBlock = ^{
        [_dataSource removeAllObjects];
        [_selectedArray removeAllObjects];
        [_tableView reloadData];
        _dingjinPrice = 0.00;
        _totalPrice = 0.00;
        _selectAll = NO;
        _selectCellButton = NO;
        _dingjinLabel.text = @"定金:0.00元";
        _AllPriceLabel.text = @"总价格:0.00元";
        
        [self getDataSource];
    };
    
<<<<<<< HEAD
    if ([model.headerCarSelect isEqualToString:@"normal"]) {
=======
    //========加号按钮事件=========
    cell.addBlock = ^{
        NSInteger count = [weakCell.numberLabel.text integerValue];
        count++;
        weakCell.numberLabel.text = [NSString stringWithFormat:@"%ld",count];
        model.numberStr =  [NSString stringWithFormat:@"%ld",count];
        [_dataSource replaceObjectAtIndex:indexPath.row withObject:model];
        if ([_selectedArray containsObject:model]) {
            [_selectedArray removeObject:model];
            [_selectedArray addObject:model];
            [self CalculateTheTotalPrice];
        }
>>>>>>> 0fda384059193aa1e59d2a4cb7b34788af50ae85
        
        NSString *product_id = model.product_id;
        
        //========加号按钮事件=========
        cell.addBlock = ^{
            NSInteger count = [weakCell.numberLabel.text integerValue];
            count++;
            NSString *productNum = [NSString stringWithFormat:@"%ld",count];
            NSDictionary *param = @{@"product_id":product_id,@"product_num":productNum};
            [[MNDownLoad shareManager]POSTWithOutHUD:@"cartProductNum" param:param success:^(NSDictionary *dic) {
                NSString *status = [NSString stringWithFormat:@"%@",dic[@"status"]];
                NSString *info = dic[@"info"];
                if ([status integerValue] == 1) {
                    weakCell.numberLabel.text = [NSString stringWithFormat:@"%ld",count];
                    model.numberStr =  [NSString stringWithFormat:@"%ld",count];
                    [_dataSource replaceObjectAtIndex:indexPath.row withObject:model];
                    if ([_selectedArray containsObject:model]) {
                        [_selectedArray removeObject:model];
                        [_selectedArray addObject:model];
                        [self CalculateTheTotalPrice];
                    }
                }else{
                    [MBProgressHUD showSuccess:info toView:self.view];
                }
            } failure:^(NSError *error) {
                
            } withSuperView:self];
            
           
            
        };
        //=======点击减号=============
        cell.cutBlock = ^ {
            NSInteger count = [weakCell.numberLabel.text integerValue];
            count--;
            if (count <= 0) {
                return ;
            }
            
            NSString *productNum = [NSString stringWithFormat:@"%ld",count];
            NSDictionary *param = @{@"product_id":product_id,@"product_num":productNum};
            [[MNDownLoad shareManager]POSTWithOutHUD:@"cartProductNum" param:param success:^(NSDictionary *dic) {
                NSString *status = [NSString stringWithFormat:@"%@",dic[@"status"]];
                NSString *info = dic[@"info"];
                if ([status integerValue] == 1) {
                    weakCell.numberLabel.text = [NSString stringWithFormat:@"%ld",count];
                    model.numberStr =  [NSString stringWithFormat:@"%ld",count];
                    [_dataSource replaceObjectAtIndex:indexPath.row withObject:model];
                    if ([_selectedArray containsObject:model]) {
                        [_selectedArray removeObject:model];
                        [_selectedArray addObject:model];
                        [self CalculateTheTotalPrice];
                    }
                }else{
                    [MBProgressHUD showSuccess:info toView:self.view];
                }
            } failure:^(NSError *error) {
                
            } withSuperView:self];
            
            
        };

    }
    
   
    return cell;
}



#pragma mark - 最底部[去结算]界面
- (void)settlementView{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-124, kScreenWidth, 60)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    //全选按钮
    _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectedButton setImage:[UIImage imageNamed:@"icon_de_nor"] forState:UIControlStateNormal];
    [_selectedButton setImage:[UIImage imageNamed:@"icon_dh_red"] forState:UIControlStateSelected];
    [_selectedButton addTarget:self action:@selector(selectBTN:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_selectedButton];
    _selectedButton.sd_layout
    .leftSpaceToView(bgView,10)
    .centerYEqualToView(bgView)
    .widthIs(20)
    .heightIs(20);
    
    UILabel *selectLabel = [[UILabel alloc]init];
    selectLabel.text = @"全选";
    selectLabel.textColor = wordColorDark;
    [bgView addSubview:selectLabel];
    selectLabel.sd_layout
    .leftSpaceToView(_selectedButton,5)
    .centerYEqualToView(bgView)
    .widthIs(50)
    .heightIs(20);
    
    //============去结算=================
    UIButton *jiesuanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [jiesuanBtn setTitle:@"去结算" forState:UIControlStateNormal];
    jiesuanBtn.backgroundColor = kRGBA(249, 30, 51, 1);
    [jiesuanBtn addTarget:self action:@selector(jieSuan) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:jiesuanBtn];
    jiesuanBtn.sd_layout
    .rightSpaceToView(bgView,0)
    .topSpaceToView(bgView,0)
    .bottomSpaceToView(bgView,0)
    .widthIs(130);
    
    //=========定金============
    _dingjinLabel = [[UILabel alloc]init];
    _dingjinLabel.textColor = kRGBA(249, 30, 51, 1);
    _dingjinLabel.textAlignment = NSTextAlignmentRight;
    _dingjinLabel.adjustsFontSizeToFitWidth = YES;
    _dingjinLabel.text = @"定金:0.00元";
    [bgView addSubview:_dingjinLabel];
    _dingjinLabel.sd_layout
    .topSpaceToView(bgView,5)
    .rightSpaceToView(jiesuanBtn,10)
    .leftSpaceToView(selectLabel,0)
    .heightIs(30);
    //=============总价===============
    _AllPriceLabel = [[UILabel alloc]init];
    _AllPriceLabel.textAlignment = NSTextAlignmentRight;
    _AllPriceLabel.textColor = wordColorDark;
    _AllPriceLabel.adjustsFontSizeToFitWidth = YES;
    _AllPriceLabel.text = @"总价格:0.00元";
    [bgView addSubview:_AllPriceLabel];
    _AllPriceLabel.sd_layout
    .topSpaceToView(_dingjinLabel,-5)
    .leftSpaceToView(selectLabel,0)
    .rightSpaceToView(jiesuanBtn,10)
    .heightIs(30);
    
    
}


//=======全选按钮事件====
- (void)selectBTN:(UIButton*)button{
    button.selected = !button.selected;
    _selectAll = button.selected;
    if (_selectAll == 1) {
        for (int i = 0; i < _dataSource.count; i++) {
            MyTeamModel *model = _dataSource[i];
            model.isSelect = YES;
            [_dataSource replaceObjectAtIndex:i withObject:model];
        }
        [_selectedArray removeAllObjects];
        [_selectedArray addObjectsFromArray:_dataSource];
        [self CalculateTheTotalPrice];
    }else{
        for (int i = 0; i < _dataSource.count; i++) {
            MyTeamModel *model = _dataSource[i];
            model.isSelect = NO;
            [_dataSource replaceObjectAtIndex:i withObject:model];
        }
        [_selectedArray removeAllObjects];
        [self CalculateTheTotalPrice];
    }
    
    //如果点击全选按钮，就把cell上面的所有按钮都选中
    [_tableView reloadData];
    
}

//====计算价格===
- (void)CalculateTheTotalPrice{
    float dingjinTotalMoney = 0 ;//定金
    float allTotalMoney = 0;//总价
    for (MyTeamModel *model in _selectedArray) {
        float DingjinPrice = [model.moneyStr floatValue];
        float allMoney = [model.allMoneyStr floatValue];
        NSInteger count = [model.numberStr integerValue];
        dingjinTotalMoney += DingjinPrice * count;
        allTotalMoney += allMoney * count;
     
    }
    _dingjinPrice = dingjinTotalMoney;
    _dingjinLabel.text = [NSString stringWithFormat:@"定金:%.2f元",_dingjinPrice];
    _totalPrice = allTotalMoney;
    _AllPriceLabel.text = [NSString stringWithFormat:@"总价格:%.2f元",_totalPrice];
}

#pragma mark - 结算按钮事件
//========结算按钮事件=========
- (void)jieSuan{
    if (_selectedArray.count <= 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"至少选定一辆婚车才能结算哦" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        settlementMoneyViewController *vc = [[settlementMoneyViewController alloc]init];
        vc.dataSource = [NSArray arrayWithArray:_selectedArray];
        vc.dingjinStr = [NSString stringWithFormat:@"%.2f",_dingjinPrice];
        vc.allMoneyStr = [NSString stringWithFormat:@"%.2f",_totalPrice];;
        [self.navigationController pushViewController:vc animated:YES];
    }
   
}


@end































