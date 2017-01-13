//
//  homeTableViewCell.h
//  HCJD-User
//
//  Created by jiang on 16/12/29.
//  Copyright © 2016年 JinNing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface homeTableViewCell : UITableViewCell

//汽车照片
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;

//汽车类型
@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;

//定金
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;





@end
