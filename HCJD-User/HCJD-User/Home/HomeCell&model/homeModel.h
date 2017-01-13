//
//  homeModel.h
//  HCJD-User
//
//  Created by jiang on 16/12/29.
//  Copyright © 2016年 JinNing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface homeModel : NSObject

//车的图片
@property (nonatomic,copy)NSString *imageCar;

//车的类型
@property (nonatomic,copy)NSString *carType;

//定金
@property (nonatomic,copy)NSString *money;


//ID
@property (nonatomic,copy)NSString *carID;

@end
