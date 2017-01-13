//
//  ProductModel.m
//  HCJD-User
//
//  Created by ZhangZi Long on 17/1/11.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import "ProductModel.h"

@implementation ProductModel

- (void)setupValueWith:(NSDictionary *)productDic{
    self._id = productDic[@"_id"];
    self.image = productDic[@"image"];
    self.image_listUrl = productDic[@"image_list"];
    self.name = productDic[@"name"];
    self.price_front = productDic[@"price_front"];
    self.price_total = productDic[@"price_total"];
    self.price_market = productDic[@"price_market"];
}
@end
