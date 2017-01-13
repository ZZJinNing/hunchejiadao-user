//
//  HCYXSelfCell.m
//  HCJD-User
//
//  Created by ZhangZi Long on 16/12/30.
//  Copyright © 2016年 JinNing. All rights reserved.
//


//***************************婚车预选自选车Cell***************************


#import "HCYXSelfCell.h"
#import "UIImageView+WebCache.h"

@implementation HCYXSelfCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setupValueWithModel:(ProductModel *)model{
    //ID
    self.ID = model._id;
    //定金
    self.advanceMoneyLabel.text = [NSString stringWithFormat:@"定金:%@",model.price_front];
    //车名
    self.carNameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    //优惠价
    self.youhuiLabel.text = [NSString stringWithFormat:@"%@",model.price_total];
    //市场价
    self.shichangLabel.text = [NSString stringWithFormat:@"%@",model.price_market];
    //图片
    [self.imageCar sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@""]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
