//
//  HCYXSelfCell.h
//  HCJD-User
//
//  Created by ZhangZi Long on 16/12/30.
//  Copyright © 2016年 JinNing. All rights reserved.
//

//***************************婚车预选自选车Cell***************************


#import <UIKit/UIKit.h>
#import "ProductModel.h"

@interface HCYXSelfCell : UITableViewCell
//ID
@property (nonatomic,retain) NSString *ID;
//汽车图片Image
@property (weak, nonatomic) IBOutlet UIImageView *imageCar;
//定金Label
@property (weak, nonatomic) IBOutlet UILabel *advanceMoneyLabel;
//车名Label
@property (weak, nonatomic) IBOutlet UILabel *carNameLabel;
//优惠价Label
@property (weak, nonatomic) IBOutlet UILabel *youhuiLabel;
//市场价Label
@property (weak, nonatomic) IBOutlet UILabel *shichangLabel;


- (void)setupValueWithModel:(ProductModel *)model;

@end
