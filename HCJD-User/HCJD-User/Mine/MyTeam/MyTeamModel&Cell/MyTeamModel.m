//
//  MyTeamModel.m
//  HCJD-User
//
//  Created by jiang on 17/1/3.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import "MyTeamModel.h"

@implementation MyTeamModel

- (void)parsingModelWithDictionary:(NSDictionary*)dictionary{
    
    self.carID = [NSString stringWithFormat:@"%@",dictionary[@"_id"]];
    self.product_id = [NSString stringWithFormat:@"%@",dictionary[@"product_id"]];
    //======汽车type=========
    NSString *car_brand_name = dictionary[@"product_info"][@"car_brand_name"];
    NSString *car_series_name = dictionary[@"product_info"][@"car_series_name"];
    NSString *car_color_name = dictionary[@"product_info"][@"car_color_name"];
    self.carTypeStr = [NSString stringWithFormat:@"%@%@%@",car_brand_name,car_series_name,car_color_name];
    //判断是否用作头车
    NSString *is_header = [NSString stringWithFormat:@"%@",dictionary[@"is_header"]];
    if ([is_header isEqualToString:@"1"]) {
        //用作头车
        self.headerCarSelect = @"select";
        //定金
        self.moneyStr = [NSString stringWithFormat:@"%@",dictionary[@"product_info"][@"price_header_front"]];
        //总价
        self.allMoneyStr = [NSString stringWithFormat:@"%@",dictionary[@"product_info"][@"price_header"]];
        
        
    }else{
        self.headerCarSelect = @"normal";
        //定金
        self.moneyStr = [NSString stringWithFormat:@"%@",dictionary[@"product_info"][@"price_follow_front"]];
        //总价
        self.allMoneyStr = [NSString stringWithFormat:@"%@",dictionary[@"product_info"][@"price_follow"]];
    }
    
    self.numberStr = [NSString stringWithFormat:@"%@",dictionary[@"product_num"]];
    self.headerImageStr = [NSString stringWithFormat:@"%@",dictionary[@"product_info"][@"image"]];
                           
    
    
}

@end
