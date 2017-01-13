//
//  HCYXCell.m
//  HCJD-User
//
//  Created by ZhangZi Long on 16/12/27.
//  Copyright © 2016年 JinNing. All rights reserved.
//



//***************************婚车预选套餐Cell***************************




#import "HCYXCell.h"



@implementation HCYXCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.toucheL.layer.cornerRadius = 3;
    self.toucheL.layer.masksToBounds = YES;
    self.toucheL.layer.borderColor = [[UIColor redColor] CGColor];
    self.toucheL.layer.borderWidth = 1;
    
    
    self.gencheL.layer.cornerRadius = 3;
    self.gencheL.layer.masksToBounds = YES;
    self.gencheL.layer.borderColor = [[UIColor redColor] CGColor];
    self.gencheL.layer.borderWidth = 1;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setupValueWithModel:(ProductGroupModel *)groupModel{
    //ID
    self.ID = groupModel._id;
    //定金
    self.advanceMoneyLabel.text = [NSString stringWithFormat:@"定金:￥%@",groupModel.price_front];
    //车名
    self.headCarLabel.text = [NSString stringWithFormat:@"%@X1/辆",groupModel.name];
    //优惠价
    self.youhuiLabel.text = [NSString stringWithFormat:@"￥%@",groupModel.price_total];
    //市场价
    self.shichangLabel.text = [NSString stringWithFormat:@"￥%@",groupModel.price_market];
    //图片
    [self.imageCar sd_setImageWithURL:[NSURL URLWithString:groupModel.image] placeholderImage:[UIImage imageNamed:@""]];
    //跟车(跟车名和数量)
    self.followCarLabel.text = [NSString stringWithFormat:@"%@X%@辆",groupModel.follow_name,groupModel.f_product_num];
    //时长和里程
    self.distanceLabel.text = [NSString stringWithFormat:@"%@小时%@公里",groupModel.f_base_hour,groupModel.f_base_mileage];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
