//
//  ProductGroupModel.h
//  HCJD-User
//
//  Created by ZhangZi Long on 17/1/11.
//  Copyright © 2017年 JinNing. All rights reserved.
//


//==========================套餐model


#import <Foundation/Foundation.h>

@interface ProductGroupModel : NSObject

@property(nonatomic,retain)NSString *_id;//产品ID
@property(nonatomic,retain)NSString *image;//产品图片
@property(nonatomic,retain)NSMutableArray *image_listUrl;//产品图片集合
@property(nonatomic,retain)NSString *name;//产品名称
@property(nonatomic,retain)NSString *price_front;//定金
@property(nonatomic,retain)NSString *price_total;//优惠价
@property(nonatomic,retain)NSString *price_market;//市场价
@property(nonatomic,retain)NSString *header_car;//头车名称
@property(nonatomic,retain)NSString *follow_name;//跟车名称
@property(nonatomic,retain)NSString *f_product_num;//跟车数量
@property(nonatomic,retain)NSString *f_base_hour;//基础时长
@property(nonatomic,retain)NSString *f_base_mileage;//基础里程

- (void)setupValueWith:(NSDictionary *)productDic;

@end
