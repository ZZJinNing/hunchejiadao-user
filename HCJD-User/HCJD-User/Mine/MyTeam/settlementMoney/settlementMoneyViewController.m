//
//  settlementMoneyViewController.m
//  HCJD-User
//
//  Created by jiang on 17/1/4.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import "settlementMoneyViewController.h"
#import "settlementModel.h"
#import "settlementTableViewCell.h"
#import "mapViewController.h"
@interface settlementMoneyViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UIScrollView *_scrollView;
    //婚礼时间
    UITextField *_weddingTimeTF;
    //集合时间
    UITextField *_jiheTimeTF;
    //紧急联系人
    UITextField *_EmergencyPhoneTF;
    //联系人电话
    UITextField *_phoneTF;
}
@end

@implementation settlementMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的婚车";
   
    
    [self createScrollView];
    
    //底部视图
    [self bottomView];
    
}

#pragma mark - 滚动视图
- (void)createScrollView{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-124)];
    _scrollView.backgroundColor = grayBG;
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(kScreenWidth, 110*(_dataSource.count)+400+kScreenWidth);
    
    //=====创建tableView
    [self createTableView];
    //=======创建详情view
    [self detailView];
}




#pragma mark - 上边的tableView
- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _scrollView.bounds.size.width, 110*(_dataSource.count))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.rowHeight = 110;
    [_tableView registerNib:[UINib nibWithNibName:@"settlementTableViewCell" bundle:nil] forCellReuseIdentifier:@"settlementCell"];
    [_scrollView addSubview:_tableView];
    
    [_tableView reloadData];
}
#pragma mark - tableView代理事件
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    settlementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settlementCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MyTeamModel *model = _dataSource[indexPath.row];
    
    cell.numberLabel.text = [NSString stringWithFormat:@"数量：%@",model.numberStr];
    
    return cell;
}


#pragma mark - 详情界面
- (void)detailView{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 110*(_dataSource.count)+10, kScreenWidth, 400+kScreenWidth)];
    bgView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:bgView];
    
    
    [self setUpUIWithView:bgView];
    
}

- (void)setUpUIWithView:(UIView*)view{
    NSArray *leftArray = @[@"定金",@"总金额",@"婚礼时间",@"集合时间",@"紧急联系人",@"联系电话"];
    NSString *dingjin = [NSString stringWithFormat:@"%@元",self.dingjinStr];
    NSString *allMoney = [NSString stringWithFormat:@"%@元",_allMoneyStr];
    
    for (int i = 0; i < leftArray.count; i++) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 50*i, 100, 50)];
        leftLabel.text = leftArray[i];
        leftLabel.font = [UIFont systemFontOfSize:18];
        leftLabel.textColor = wordColorDark;
        [view addSubview:leftLabel];
        
        
        //下划线
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50+50*i, kScreenWidth, 1)];
        lineLabel.backgroundColor = LineColor;
        [view addSubview:lineLabel];
        
        
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(120, 50*i, kScreenWidth - 130, 50)];
        textField.textColor = wordColorDark;
        textField.textAlignment = NSTextAlignmentRight;
        textField.font = [UIFont systemFontOfSize:18];
        if (i == 0) {
            textField.text = dingjin;
            textField.userInteractionEnabled = NO;
        }else if (i == 1){
            textField.text = allMoney;
            textField.userInteractionEnabled = NO;
        }else if (i == 2){
            _weddingTimeTF = textField;
            textField.placeholder = @"xx年xx月xx日xx时";
        }else if (i == 3){
            _jiheTimeTF = textField;
            textField.placeholder = @"xx年xx月xx日xx时";
        }else if (i == 4){
            _EmergencyPhoneTF = textField;
            textField.placeholder = @"请输入紧急联系人电话";
        }else if (i == 5){
            _phoneTF = textField;
            textField.placeholder = @"请输入联系人电话";
        }
       
        [view addSubview:textField];
    }
    
    //======路线============
    UIView *routeView = [[UIView alloc]initWithFrame:CGRectMake(0, 301, kScreenWidth, 50)];
    routeView.userInteractionEnabled = YES;
    [view addSubview:routeView];
    UILabel *routeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 50)];
    routeLabel.text = @"路线";
    routeLabel.font = [UIFont systemFontOfSize:18];
    routeLabel.textColor = wordColorDark;
    [routeView addSubview:routeLabel];
    //箭头
    UIImageView *jiantouImage = [[UIImageView alloc]init];
    jiantouImage.image = [UIImage imageNamed:@"icon_jt"];
    [routeView addSubview:jiantouImage];
    jiantouImage.sd_layout
    .rightSpaceToView(routeView,13)
    .centerYEqualToView(routeView)
    .widthIs(13)
    .heightIs(25);
    
    //线
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, kScreenWidth, 1)];
    lineLabel.backgroundColor = LineColor;
    [routeView addSubview:lineLabel];
    
   //添加点击事件
    UITapGestureRecognizer * tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(routeTapHandle)];
    [routeView addGestureRecognizer:tgr];

}
- (void)routeTapHandle{
    mapViewController *vc = [[mapViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
  

#pragma mark - 底部视图
- (void)bottomView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-124, kScreenWidth, 60+kScreenWidth)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    
    //宽
    float w = view.bounds.size.width/2;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, w, 60)];
    label.adjustsFontSizeToFitWidth = YES;
    label.text = [NSString stringWithFormat:@"定金：¥%@",_dingjinStr];
    label.backgroundColor = kRGB(253, 118, 130);
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(w, 0, w, 60);
    [button setTitle:@"提交订单" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(SubmitOrder) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    button.backgroundColor = [UIColor redColor];
    [view addSubview:button];
}

- (void)SubmitOrder{
   
    
    
}


@end
























