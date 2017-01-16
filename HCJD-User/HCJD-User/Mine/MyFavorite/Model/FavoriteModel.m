//
//  FavoriteModel.m
//  HCJD-User
//
//  Created by ZhangZi Long on 17/1/14.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import "FavoriteModel.h"

@implementation FavoriteModel
- (void)setupValueWith:(NSDictionary *)returnDic{
    //收藏产品ID
    self.product_id = [NSString stringWithFormat:@"%@",returnDic[@"product_id"]];
    
    
    //判断model的类型=====type为YES时是产品类型，type为NO时是套餐类型
    NSString *typeStr = [NSString stringWithFormat:@"%@",returnDic[@"type"]];
    if ([typeStr isEqualToString:@"group"]) {
        self.type = NO;
    }else if ([typeStr isEqualToString:@"product"]){
        self.type = YES;
    }
    
    //产品信息
    NSDictionary *product_infoDic = returnDic[@"product_info"];
    if (!kDictIsEmpty(product_infoDic)) {
        self.product_info = product_infoDic;
    }
    
    
    //套餐信息
    NSDictionary *group_infoDic = returnDic[@"group_info"];
    if (!kDictIsEmpty(group_infoDic)) {
        self.group_info = group_infoDic;
    }
    
}
@end
