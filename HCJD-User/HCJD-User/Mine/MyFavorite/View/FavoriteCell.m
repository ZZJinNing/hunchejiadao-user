//
//  FavoriteCell.m
//  HCJD-User
//
//  Created by ZhangZi Long on 17/1/4.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import "FavoriteCell.h"

@implementation FavoriteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //左侧头车和跟车两个固定Label
    self.leftLabel.layer.cornerRadius = 3;
    self.leftLabel.layer.borderColor = [[UIColor redColor] CGColor];
    self.leftLabel.layer.borderWidth = 1;
    self.leftLabel.layer.masksToBounds = YES;
    self.leftLabel.textAlignment = NSTextAlignmentCenter;
    
    //取消收藏
    self.noFavoriteBtn.layer.cornerRadius = 3;
    self.noFavoriteBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.noFavoriteBtn.layer.borderWidth = 1;
    [self.noFavoriteBtn addTarget:self action:@selector(noFavoriteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //左侧图片
    self.leftImageView.layer.cornerRadius = 3;
    self.leftImageView.layer.masksToBounds = YES;
    
    //Cell选中状态
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setupProductValueWith:(ProductModel *)productModel{
    //ID
    self.ID = productModel._id;
    //定金
    self.advanceLabel.text = [NSString stringWithFormat:@"￥%@",productModel.price_front];
    //车名
    self.nameLabel.text = [NSString stringWithFormat:@"%@",productModel.name];
    //总价
    self.totalLabel.text = [NSString stringWithFormat:@"￥%@",productModel.price_total];
    //图片
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:productModel.image] placeholderImage:[UIImage imageNamed:@"image"]];
    
    self.leftLabel.hidden = YES;
    self.taocanImageView.hidden = YES;
    self.headCarLabel.hidden = YES;
}

- (void)setupGroupValueWith:(ProductGroupModel *)groupModel{
    //ID
    self.ID = groupModel._id;
    //定金
    self.advanceLabel.text = [NSString stringWithFormat:@"￥%@",groupModel.price_front];
    //车名
    self.nameLabel.text = [NSString stringWithFormat:@"%@",groupModel.name];
    //总价
    self.totalLabel.text = [NSString stringWithFormat:@"￥%@",groupModel.price_total];
    //图片
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:groupModel.image] placeholderImage:[UIImage imageNamed:@"image"]];
    //头车
    self.headCarLabel.text = [NSString stringWithFormat:@"%@",groupModel.header_car];
}

//取消收藏
- (void)noFavoriteBtnClick{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

//判断是否是套餐，是否隐藏头车和套餐标签
- (void)weatherHidden{
    self.leftLabel.hidden = NO;
    self.taocanImageView.hidden = NO;
    self.headCarLabel.hidden = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
