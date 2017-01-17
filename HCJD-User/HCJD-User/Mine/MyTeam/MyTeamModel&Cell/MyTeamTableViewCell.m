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
    
    NSString *_MySelected;
}
@end

@implementation MyTeamTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = grayBG;
        [self layoutUI];
    }
    return self;
}
#pragma mark--布局界面
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
    _headerImageView.image = [UIImage imageNamed:@"image"];
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
    _carTypeLabel.text = @"奥迪A6L白色";
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
    _moneyLabel.text = @"定金:¥ 400";
    [view addSubview:_moneyLabel];
    _moneyLabel.sd_layout
    .leftSpaceToView(_headerImageView,8)
    .topSpaceToView(_carTypeLabel,10)
    .rightSpaceToView(view,95)
    .heightIs(20);
    
    //➖
    UIButton *cutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cutButton.backgroundColor = kRGBA(180, 180, 180, 0.2);
    [cutButton setImage:[UIImage imageNamed:@"cutnor"] forState:UIControlStateNormal];
    [cutButton setImage:[UIImage imageNamed:@"cutred"] forState:UIControlStateHighlighted];
    [cutButton addTarget:self action:@selector(cutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cutButton];
    cutButton.sd_layout
    .leftSpaceToView(_headerImageView,8)
    .topSpaceToView(_moneyLabel,10)
    .widthIs(30)
    .heightIs(30);
    
    //数量label
    _numberLabel = [[UILabel alloc]init];
    _numberLabel.textColor = [UIColor lightGrayColor];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.text = [NSString stringWithFormat:@"%d",1];
    [view addSubview:_numberLabel];
    _numberLabel.sd_layout
    .leftSpaceToView(cutButton,5)
    .centerYEqualToView(cutButton)
    .widthIs(20)
    .heightIs(20);
    
    //➕
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"addnor"] forState:UIControlStateNormal];
    addBtn.backgroundColor = kRGBA(180, 180, 180, 0.2);
    [addBtn setImage:[UIImage imageNamed:@"addred"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addBtn];
    addBtn.sd_layout
    .leftSpaceToView(_numberLabel,5)
    .topSpaceToView(_moneyLabel,10)
    .widthIs(30)
    .heightIs(30);
    
    //是否选作头车
    _carImageView = [[UIImageView alloc]init];
    _carImageView.image = [UIImage imageNamed:@"icon_bg_nor"];
    [view addSubview:_carImageView];
    _carImageView.sd_layout
    .rightSpaceToView(view,10)
    .topSpaceToView(view,10)
    .widthIs(80)
    .heightIs(25);
    
    UIButton *headerCarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _MySelected = @"normal";
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

#pragma mark--选中按钮事件
- (void)selectBTN:(UIButton*)button{
    button.selected = !button.selected;
    if (self.cartBlock) {
        self.cartBlock(button.selected);
    }
}
#pragma mark--点击减号按钮事件
- (void)cutBtnClick{
    if (self.cutBlock) {
        self.cutBlock();
    }
}
#pragma mark--点击加好按钮事件
- (void)addBtnClick{
    if (self.addBlock) {
        self.addBlock();
    }
}

#pragma mark--是否用作头车
- (void)headerCarSelected{
    if ([_MySelected isEqualToString:@"normal"]) {
        _MySelected = @"select";
               
    }else if ([_MySelected isEqualToString:@"select"]){
        _MySelected = @"normal";
        
    }
    
    if (self.selectHeaderCarBlock) {
        self.selectHeaderCarBlock(_MySelected);
    }

}
#pragma mark--删除按钮
- (void)MYDeleteButton{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"您确定要删除数据吗" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
    }]];
    
    [self.superController presentViewController:alert animated:YES completion:nil];

}


#pragma mark - 数据
- (void)reloadDataWith:(MyTeamModel *)model{
    self.selectedButton.selected = model.isSelect;
    if ([model.hesderCarSelect isEqualToString:@"normal"]) {
        _carImageView.image = [UIImage imageNamed:@"icon_bg_nor"];
    }else if ([model.hesderCarSelect isEqualToString:@"select"]){
        _carImageView.image = [UIImage imageNamed:@"icon_bg_red"];
    }
  
}




@end

























