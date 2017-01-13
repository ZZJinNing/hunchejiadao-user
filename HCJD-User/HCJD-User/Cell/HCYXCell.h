//
//  HCYXCell.h
//  HCJD-User
//
//  Created by ZhangZi Long on 16/12/27.
//  Copyright © 2016年 JinNing. All rights reserved.
//


//***************************婚车预选套餐Cell***************************


#import <UIKit/UIKit.h>
#import "ProductGroupModel.h"

@interface HCYXCell : UITableViewCell
//左侧红色头车和跟车（固定Label）
@property (weak, nonatomic) IBOutlet UILabel *toucheL;
@property (weak, nonatomic) IBOutlet UILabel *gencheL;

//ID
@property (nonatomic,retain) NSString *ID;
//汽车图片Image
@property (weak, nonatomic) IBOutlet UIImageView *imageCar;
//定金Label
@property (weak, nonatomic) IBOutlet UILabel *advanceMoneyLabel;
//头车Label
@property (weak, nonatomic) IBOutlet UILabel *headCarLabel;
//跟车Label
@property (weak, nonatomic) IBOutlet UILabel *followCarLabel;
//优惠价Label
@property (weak, nonatomic) IBOutlet UILabel *youhuiLabel;
//市场价Label
@property (weak, nonatomic) IBOutlet UILabel *shichangLabel;
//行驶时长和里程Label
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

- (void)setupValueWithModel:(ProductGroupModel *)groupModel;


@end
