//
//  homeTableViewCell.h
//  HCJD-User
//
//  Created by jiang on 16/12/29.
//  Copyright © 2016年 JinNing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

@interface homeTableViewCell : UITableViewCell
//ID
@property (nonatomic,retain) NSString *ID;

//汽车照片
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;

//汽车类型
@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;

//定金
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;


- (void)setupValueWithModel:(ProductModel *)model;


@end
