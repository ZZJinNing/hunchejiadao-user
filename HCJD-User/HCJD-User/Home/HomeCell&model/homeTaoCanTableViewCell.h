//
//  homeTaoCanTableViewCell.h
//  HCJD-User
//
//  Created by jiang on 17/1/10.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductGroupModel.h"

@interface homeTaoCanTableViewCell : UITableViewCell

//ID
@property (nonatomic,retain) NSString *ID;

//图片

@property (weak, nonatomic) IBOutlet UIImageView *carImageView;

//头车
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@property (weak, nonatomic) IBOutlet UILabel *headerCarLAbel;

//跟车
@property (weak, nonatomic) IBOutlet UILabel *genLabel;

@property (weak, nonatomic) IBOutlet UILabel *genCarLabel;

//定金
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

- (void)setupValueWithModel:(ProductGroupModel *)groupModel;


@end
