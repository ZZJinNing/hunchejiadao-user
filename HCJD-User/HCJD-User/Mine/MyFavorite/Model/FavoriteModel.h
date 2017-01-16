//
//  FavoriteModel.h
//  HCJD-User
//
//  Created by ZhangZi Long on 17/1/14.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoriteModel : NSObject

@property(nonatomic,assign)BOOL type;//产品类型
@property(nonatomic,retain)NSString *product_id;//产品或套餐ID
@property(nonatomic,retain)NSDictionary *product_info;//产品信息
@property(nonatomic,retain)NSDictionary *group_info;//套餐信息

- (void)setupValueWith:(NSDictionary *)returnDic;

@end
