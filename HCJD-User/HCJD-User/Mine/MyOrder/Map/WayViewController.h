//
//  WayViewController.h
//  HCJD-User
//
//  Created by ZhangZi Long on 17/1/17.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WayViewController : UIViewController
//起始点经纬度
@property (nonatomic,copy)NSString *begin_lat;
@property (nonatomic,copy)NSString * begin_lng;

//途经点
@property (nonatomic,copy)NSString * way_lat;
@property (nonatomic,copy)NSString * way_lng;


//结束点
@property (nonatomic,copy)NSString * end_lat;
@property (nonatomic,copy)NSString * end_lng;
@end
