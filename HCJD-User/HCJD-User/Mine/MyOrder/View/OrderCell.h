//
//  OrderCell.h
//  HCJD-User
//
//  Created by ZhangZi Long on 17/1/5.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCell : UITableViewCell
/*
 *汽车图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *carImage;
/*
 *名字
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/*
 *婚礼日期
 */
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
/*
 *定金
 */
@property (weak, nonatomic) IBOutlet UILabel *advanceLabel;
/*
 *总金额
 */
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
/*
 *订单状态
 */
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end
