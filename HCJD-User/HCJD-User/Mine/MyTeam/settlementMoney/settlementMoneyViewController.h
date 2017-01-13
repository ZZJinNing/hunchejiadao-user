//
//  settlementMoneyViewController.h
//  HCJD-User
//
//  Created by jiang on 17/1/4.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTeamModel.h"
@interface settlementMoneyViewController : UIViewController

@property (nonatomic)NSArray<MyTeamModel*>* dataSource;

//定金
@property (nonatomic,copy)NSString *dingjinStr;
//总金额
@property (nonatomic,copy)NSString *allMoneyStr;



@end
