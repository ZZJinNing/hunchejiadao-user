//
//  settlementTableViewCell.h
//  HCJD-User
//
//  Created by jiang on 17/1/4.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface settlementTableViewCell : UITableViewCell

//头像
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

//汽车的类型
@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;
//定金
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

//汽车数量
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

//是否是头车
@property (weak, nonatomic) IBOutlet UILabel *isHeaderCarLabel;






@end
