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
    // Initialization code
    self.leftLabel.layer.cornerRadius = 3;
    self.leftLabel.layer.borderColor = [[UIColor redColor] CGColor];
    self.leftLabel.layer.borderWidth = 1;
    self.leftLabel.layer.masksToBounds = YES;
    self.leftLabel.textAlignment = NSTextAlignmentCenter;
    
    self.noFavoriteBtn.layer.cornerRadius = 3;
    self.noFavoriteBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.noFavoriteBtn.layer.borderWidth = 1;
    
    self.leftImageView.layer.cornerRadius = 3;
    self.leftImageView.layer.masksToBounds = YES;
    
    self.taocan = NO;
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
