//
//  MyTeamModel.h
//  HCJD-User
//
//  Created by jiang on 17/1/3.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTeamModel : NSObject

//头像
@property (nonatomic,strong)NSString *headerImageStr;
//汽车类型
@property (nonatomic,strong)NSString *carTypeStr;
//定金
@property (nonatomic,strong)NSString *moneyStr;
//总价
@property (nonatomic,strong)NSString *allMoneyStr;
//数量
@property (nonatomic,strong)NSString *numberStr;

//是否选作按钮
@property (nonatomic)BOOL isSelect;
//是否选中为头车
@property (nonatomic,strong)NSString *hesderCarSelect;



@end
