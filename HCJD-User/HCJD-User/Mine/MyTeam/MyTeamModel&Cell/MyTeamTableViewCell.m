//
//  MyTeamTableViewCell.m
//  HCJD-User
//
//  Created by jiang on 17/1/3.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import "MyTeamTableViewCell.h"

@interface MyTeamTableViewCell()
{
    MyTeamModel *_model;
    UIViewController *_superController;
}
@end

@implementation MyTeamTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = grayBG;
    }
    return self;
}

//================布局界面==============
- (void)layoutUI{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    view.sd_layout
    .topSpaceToView(self,10)
    .leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .bottomSpaceToView(self,0);
    
    //===========选中按钮==================
    _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectedButton setImage:[UIImage imageNamed:@"icon_de_nor"] forState:UIControlStateNormal];
    [_selectedButton setImage:[UIImage imageNamed:@"icon_dh_red"] forState:UIControlStateSelected];
    self.selectedButton.selected = self.isSelected;
    [_selectedButton addTarget:self action:@selector(selectBTN:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_selectedButton];
    _selectedButton.sd_layout
    .centerYEqualToView(view)
    .leftSpaceToView(view,10)
    .widthIs(20)
    .heightIs(20);

    //==============头像=================
    _headerImageView = [[UIImageView alloc]init];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_model.headerImageStr] placeholderImage:[UIImage imageNamed:@"placeHold"]];
    _headerImageView.layer.cornerRadius = 5;
    _headerImageView.layer.masksToBounds = YES;
    [view addSubview:_headerImageView];
    _headerImageView.sd_layout
    .leftSpaceToView(view,35)
    .topSpaceToView(view,10)
    .heightIs(90)
    .widthIs(90);

    //=============车的类型================
    _carTypeLabel = [[UILabel alloc]init];
    _carTypeLabel.text = _model.carTypeStr;
    _carTypeLabel.adjustsFontSizeToFitWidth = YES;
    _carTypeLabel.textColor = wordColorDark;
    _carTypeLabel.font = [UIFont systemFontOfSize:15];
    [view addSubview:_carTypeLabel];
    _carTypeLabel.sd_layout
    .leftSpaceToView(_headerImageView,8)
    .topSpaceToView(view,10)
    .rightSpaceToView(view,95)
    .heightIs(20);
    
    //=========定金============
    _moneyLabel = [[UILabel alloc]init];
    _moneyLabel.textColor = kRGBA(249, 30, 51, 1);
    _moneyLabel.adjustsFontSizeToFitWidth = YES;
    _moneyLabel.text = [NSString stringWithFormat:@"定金:%@元",_model.moneyStr];
    [view addSubview:_moneyLabel];
    _moneyLabel.sd_layout
    .leftSpaceToView(_headerImageView,8)
    .topSpaceToView(_carTypeLabel,10)
    .rightSpaceToView(view,95)
    .heightIs(20);
    
    //➖
    _cutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cutButton.backgroundColor = kRGBA(180, 180, 180, 0.2);
    [_cutButton setImage:[UIImage imageNamed:@"cutnor"] forState:UIControlStateNormal];
    [_cutButton setImage:[UIImage imageNamed:@"cutred"] forState:UIControlStateHighlighted];
    [_cutButton addTarget:self action:@selector(cutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_cutButton];
    _cutButton.sd_layout
    .leftSpaceToView(_headerImageView,8)
    .topSpaceToView(_moneyLabel,10)
    .widthIs(30)
    .heightIs(30);
    
    //数量label
    _numberLabel = [[UILabel alloc]init];
    _numberLabel.text = _model.numberStr;
    _numberLabel.textColor = [UIColor lightGrayColor];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.adjustsFontSizeToFitWidth = YES;
    [view addSubview:_numberLabel];
    _numberLabel.sd_layout
    .leftSpaceToView(_cutButton,5)
    .centerYEqualToView(_cutButton)
    .widthIs(20)
    .heightIs(20);
    
    //➕
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addBtn setImage:[UIImage imageNamed:@"addnor"] forState:UIControlStateNormal];
    _addBtn.backgroundColor = kRGBA(180, 180, 180, 0.2);
    [_addBtn setImage:[UIImage imageNamed:@"addred"] forState:UIControlStateHighlighted];
    [_addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_addBtn];
    _addBtn.sd_layout
    .leftSpaceToView(_numberLabel,5)
    .topSpaceToView(_moneyLabel,10)
    .widthIs(30)
    .heightIs(30);
    
    
    
    
    //是否选作头车
    _carImageView = [[UIImageView alloc]init];
    [view addSubview:_carImageView];
    _carImageView.sd_layout
    .rightSpaceToView(view,10)
    .topSpaceToView(view,10)
    .widthIs(80)
    .heightIs(25);
    if ([_model.headerCarSelect isEqualToString:@"normal"]) {
        _carImageView.image = [UIImage imageNamed:@"icon_bg_nor"];
    }else if ([_model.headerCarSelect isEqualToString:@"select"]){
        _carImageView.image = [UIImage imageNamed:@"icon_bg_red"];
    }
    
    UIButton *headerCarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerCarButton setTitle:@"用作头车" forState:UIControlStateNormal];
    [headerCarButton setTitleColor:wordColorDark forState:UIControlStateNormal];
    headerCarButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [headerCarButton addTarget:self action:@selector(headerCarSelected) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:headerCarButton];
    headerCarButton.sd_layout
    .rightSpaceToView(view,10)
    .topSpaceToView(view,10)
    .widthIs(80)
    .heightIs(25);
    
    //删除按钮
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteButton setBackgroundImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(MYDeleteButton) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_deleteButton];
    _deleteButton.sd_layout
    .rightSpaceToView(view,15)
    .bottomSpaceToView(view,10)
    .widthIs(30)
    .heightIs(28);

}


//选中按钮事件
- (void)selectBTN:(UIButton*)button{
    button.selected = !button.selected;
    if (self.cartBlock) {
        self.cartBlock(button.selected);
    }
}
//点击减号按钮事件
- (void)cutBtnClick{
    if (self.cutBlock) {
    
        self.cutBlock();
    }
}
//点击加好按钮事件
- (void)addBtnClick{
    if (self.addBlock) {
        self.addBlock();
    }
}

//是否用作头车
- (void)headerCarSelected{
    //操作类型（add 设置头车、cancel 取消头车
    NSString *type;
    if ([_model.headerCarSelect isEqualToString:@"normal"]) {
        type = @"add";
    }else if ([_model.headerCarSelect isEqualToString:@"select"]){
        type = @"cancel";
    }
    
    
    NSString *carID = _model.carID;

    [self getHeaderCarWithID:carID WithType:type];
}

//删除按钮
- (void)MYDeleteButton{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"您确定要删除数据吗" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self delegeOrder];
    }]];
    
    [_superController presentViewController:alert animated:YES completion:nil];

}


#pragma mark - 数据
-(void)reloadDataWith:(MyTeamModel*)model WithSuperController:(UIViewController*)superController{
    self.selectedButton.selected = model.isSelect;
    
    if ([model.headerCarSelect isEqualToString:@"normal"]) {
        _addBtn.userInteractionEnabled = YES;
        _cutButton.userInteractionEnabled = YES;
    }else if ([model.headerCarSelect isEqualToString:@"select"]){
        _addBtn.userInteractionEnabled = NO;
        _cutButton.userInteractionEnabled = NO;
    }
    _model = model;
    _superController = superController;
    [self layoutUI];
}

#pragma mark - 用着头车的数据
- (void)getHeaderCarWithID:(NSString*)carID WithType:(NSString*)type{
    NSDictionary *param = @{@"_id":carID,@"_type":type,@"is_sure":@"0"};
    [[MNDownLoad shareManager]POSTWithoutGitHUD:@"cartHeader" param:param success:^(NSDictionary *dic) {
        NSString *status = [NSString stringWithFormat:@"%@",dic[@"status"]];
        if ([status isEqualToString:@"-2"]) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:dic[@"info"] preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSDictionary *para = @{@"_id":carID,@"_type":type,@"is_sure":@"1"};
                [[MNDownLoad shareManager]POSTWithoutGitHUD:@"cartHeader" param:para success:^(NSDictionary *dic) {
                    NSString *info = dic[@"info"];
                    NSString *status = [NSString stringWithFormat:@"%@",dic[@"status"]];
                    if ([status isEqualToString:@"1"]) {
                       [MBProgressHUD showSuccess:@"操作成功" toView:_superController.view];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"MN_getDataSource" object:self];
                    }else{
                        [MBProgressHUD showSuccess:info toView:self];
                    }
                    
                   
                } failure:^(NSError *error) {
                  
                } withSuperView:nil];
            }]];
            
            [_superController presentViewController:alert animated:YES completion:nil];
            
            
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:dic[@"info"] preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [_superController presentViewController:alert animated:YES completion:nil];
        }
        
    } failure:^(NSError *error) {
        
    } withSuperView:nil];
    
}


#pragma mark - 删除数据
- (void)delegeOrder{
    NSString *orderID = _model.carID;
    NSDictionary *param = @{@"_id":orderID};
    [[MNDownLoad shareManager]POSTWithoutGitHUD:@"cartDelete" param:param success:^(NSDictionary *dic) {

        NSString *info = dic[@"info"];
        NSString *status = [NSString stringWithFormat:@"%@",dic[@"status"]];
        if ([status integerValue] == 1) {
            if (_delegeBlock) {
                self.delegeBlock();
            }
        }else{
            [MBProgressHUD showSuccess:info toView:self];
        }
     
    } failure:^(NSError *error) {
        
    } withSuperView:_superController];
    
    
    
}







@end

























