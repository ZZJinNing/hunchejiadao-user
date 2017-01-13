//
//  settlementModel.h
//  HCJD-User
//
//  Created by jiang on 17/1/4.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface settlementModel : NSObject

//头像
@property (nonatomic,strong)NSString *headerImageStr;

//汽车类型
@property (nonatomic,strong)NSString *catTypeStr;

//定金
@property (nonatomic,strong)NSString *moneyStr;

//数量
@property (nonatomic,strong)NSString *numberStr;

//是否是头车
@property (nonatomic,strong)NSString *isHeaderStr;



@end
