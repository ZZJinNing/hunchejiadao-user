//
//  homeTableViewCell.m
//  HCJD-User
//
//  Created by jiang on 16/12/29.
//  Copyright © 2016年 JinNing. All rights reserved.
//

#import "homeTableViewCell.h"

@implementation homeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}
- (void)setupValueWithModel:(ProductModel *)model{
    //ID
    self.ID = model._id;
    //定金
    self.moneyLabel.text = [NSString stringWithFormat:@"定金:%@",model.price_front];
    //车名
    self.carTypeLabel.text = [NSString stringWithFormat:@"%@",model.name];
    //图片
    [self.carImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@""]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
