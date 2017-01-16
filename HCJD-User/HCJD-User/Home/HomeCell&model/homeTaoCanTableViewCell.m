//
//  homeTaoCanTableViewCell.m
//  HCJD-User
//
//  Created by jiang on 17/1/10.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import "homeTaoCanTableViewCell.h"

@implementation homeTaoCanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //设置头车和跟车的边界线
    self.headerLabel.layer.borderWidth = 1.0;
    self.headerLabel.layer.borderColor = [kRGB(249, 30, 51) CGColor];
    self.headerLabel.layer.masksToBounds = YES;
    self.headerLabel.layer.cornerRadius = 1;
    
    
    self.genLabel.layer.borderWidth = 1.0;
    self.genLabel.layer.borderColor = [kRGB(249, 30, 51) CGColor];
    self.genLabel.layer.masksToBounds = YES;
    self.genLabel.layer.cornerRadius = 1;
    
    self.genCarLabel.adjustsFontSizeToFitWidth = YES;
    self.headerCarLAbel.adjustsFontSizeToFitWidth = YES;
    self.moneyLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setupValueWithModel:(ProductGroupModel *)groupModel{
    //ID
    self.ID = groupModel._id;
    //定金
    self.moneyLabel.text = [NSString stringWithFormat:@"定金:￥%@",groupModel.price_front];
    //头车
    self.headerCarLAbel.text = [NSString stringWithFormat:@"%@X1/辆",groupModel.name];
    //图片
    [self.carImageView sd_setImageWithURL:[NSURL URLWithString:groupModel.image] placeholderImage:[UIImage imageNamed:@""]];
    //跟车(跟车名和数量)
    self.genCarLabel.text = [NSString stringWithFormat:@"%@X%@辆",groupModel.follow_name,groupModel.f_product_num];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
