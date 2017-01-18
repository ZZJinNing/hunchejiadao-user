//
//  JJHFoundModel.h
//  marriedCarComeIng
//
//  Created by jiang on 17/1/12.
//  Copyright © 2017年 com.meiniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJHFoundModel : NSObject

//图标
@property (nonatomic,copy)NSString *iconStr;

//标题
@property (nonatomic,copy)NSString *title;

//url
@property (nonatomic,copy)NSString *url;


//小标背景颜色
@property (nonatomic,copy)NSString *BgColor;
//小标文字颜色
@property (nonatomic,copy)NSString *cornerColor;
//小标标题
@property (nonatomic,copy)NSString *cornerTitle;
//是否显示小标
@property (nonatomic,copy)NSString *is_corner;


@end
