//
//  DetailGroupModel.h
//  HCJD-User
//
//  Created by ZhangZi Long on 17/1/12.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailGroupModel : NSObject

@property(nonatomic,retain)NSString *_id;//产品ID
@property(nonatomic,retain)NSString *imageUrl;//产品图片
@property(nonatomic,retain)NSMutableArray *image_listUrl;//产品图片集合
@property(nonatomic,retain)NSString *name;//产品名称
@property(nonatomic,retain)NSString *price_front;//定金
@property(nonatomic,retain)NSString *price_total;//优惠价
@property(nonatomic,retain)NSString *price_market;//市场价
@property(nonatomic,retain)NSString *is_collect;//是否收藏
- (void)setupValueWith:(NSDictionary *)returnDic;
@end
