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
@interface MyTeamViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataSource;
   
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
    self.view.backgroundColor = [UIColor whiteColor];
    _dataSource = [[NSMutableArray alloc]init];
    _selectedArray = [NSMutableArray new];
    _totalPrice = 0.00;
    _dingjinPrice = 0.00;
    _selectAll = NO;
    _selectCellButton = NO;
    
    
    [self createTableView];
    [self getDataSource];
    //去结算界面
    [self settlementView];
    
}
  
#pragma mark - 创建tableView
- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-124)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 120;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [_tableView registerClass:[MyTeamTableViewCell class] forCellReuseIdentifier:@"teamCell"];
    [self.view addSubview:_tableView];
}

#pragma mark - 数据源
- (void)getDataSource{
    for (int i = 0; i < 20; i++) {
        MyTeamModel *model = [[MyTeamModel alloc]init];
        model.moneyStr = [NSString stringWithFormat:@"10%d",i];
        model.numberStr = @"1";
        model.hesderCarSelect = @"normal";
        [_dataSource addObject:model];
    }
    [_tableView reloadData];
}

#pragma mark - tableView代理事件
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"teamCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.superController = self;
    
    MyTeamModel *model = _dataSource[indexPath.row];
    cell.moneyLabel.text = [NSString stringWithFormat:@"%@",model.moneyStr];
    cell.numberLabel.text = model.numberStr;
    
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
   
    
    //======点击用作车头按钮事件=============
    cell.selectHeaderCarBlock = ^(NSString *select){
        if ([select isEqualToString:@"select"]) {
             weakCell.carImageView.image = [UIImage imageNamed:@"icon_bg_red"];
            //选作车头
            model.hesderCarSelect = @"select";
            [_dataSource replaceObjectAtIndex:indexPath.row withObject:model];
        }else if ([select isEqualToString:@"normal"]){
            //不选作车头
            weakCell.carImageView.image = [UIImage imageNamed:@"icon_bg_nor"];
            model.hesderCarSelect = @"normal";
            [_dataSource replaceObjectAtIndex:indexPath.row withObject:model];
        }
    };
    
    //========加好按钮事件=========
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
        
    };

    //=======点击减号=============
    cell.cutBlock = ^ {
        NSInteger count = [weakCell.numberLabel.text integerValue];
        count--;
        if (count <= 0) {
            return ;
        }
        weakCell.numberLabel.text = [NSString stringWithFormat:@"%ld",count];
        model.numberStr =  [NSString stringWithFormat:@"%ld",count];
        [_dataSource replaceObjectAtIndex:indexPath.row withObject:model];
        if ([_selectedArray containsObject:model]) {
            [_selectedArray removeObject:model];
            [_selectedArray addObject:model];
            [self CalculateTheTotalPrice];
        }
        
    };
    
    [cell reloadDataWith:model];
    
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
    _dingjinLabel.text = [NSString stringWithFormat:@"定金:%.2f",_dingjinPrice];
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
    _AllPriceLabel.text = [NSString stringWithFormat:@"总价格:%.2f",_totalPrice];
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
    float totalMoney ;
    for (MyTeamModel *model in _selectedArray) {
        float price = [model.moneyStr floatValue];
        NSInteger count = [model.numberStr integerValue];
        totalMoney += price * count;
    }
    _totalPrice = totalMoney;
    _AllPriceLabel.text = [NSString stringWithFormat:@"总价格:%.2f",_totalPrice];
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































