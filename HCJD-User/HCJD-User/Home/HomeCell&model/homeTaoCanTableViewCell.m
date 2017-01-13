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
    
    //设置头车和跟车的边界线
    self.headerLabel.layer.borderWidth = 1.0;
    self.headerLabel.layer.borderColor = [kRGB(252, 92, 92) CGColor];
    self.headerLabel.layer.masksToBounds = YES;
    self.headerLabel.layer.cornerRadius = 2;
    
    
    self.genLabel.layer.borderWidth = 1.0;
    self.genLabel.layer.borderColor = [kRGB(252, 92, 92) CGColor];
    self.genLabel.layer.masksToBounds = YES;
    self.genLabel.layer.cornerRadius = 2;
    
    self.genCarLabel.adjustsFontSizeToFitWidth = YES;
    self.headerCarLAbel.adjustsFontSizeToFitWidth = YES;
    self.moneyLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
