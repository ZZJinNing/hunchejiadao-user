//
//  DetailGroupModel.m
//  HCJD-User
//
//  Created by ZhangZi Long on 17/1/12.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import "DetailGroupModel.h"

@implementation DetailGroupModel

- (void)setupValueWith:(NSDictionary *)returnDic{
    self._id = returnDic[@"_id"];
    self.imageUrl = returnDic[@"image"];
    self.image_listUrl = returnDic[@"image_list"];
    self.name = returnDic[@"name"];
    self.price_front = returnDic[@"price_front"];
    self.price_total = returnDic[@"price_total"];
    self.price_market = returnDic[@"price_market"];
    self.is_collect = returnDic[@"is_collect"];;
}

@end
