//
//  ProductGroupModel.m
//  HCJD-User
//
//  Created by ZhangZi Long on 17/1/11.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import "ProductGroupModel.h"

@implementation ProductGroupModel

- (void)setupValueWith:(NSDictionary *)productDic{
    self._id = productDic[@"_id"];
    self.image = productDic[@"image"];
    self.image_listUrl = productDic[@"image_list"];
    self.name = productDic[@"name"];
    self.price_front = productDic[@"price_front"];
    self.price_total = productDic[@"price_total"];
    self.price_market = productDic[@"price_market"];
    self.follow_name = productDic[@"follow_car"][@"name"];
    self.f_product_num = productDic[@"follow_car"][@"product_num"];
    self.f_base_hour = productDic[@"follow_car"][@"base_hour"];
    self.f_base_mileage = productDic[@"follow_car"][@"base_mileage"];
}

@end
