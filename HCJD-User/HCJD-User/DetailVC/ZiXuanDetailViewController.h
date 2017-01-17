//
//  HomeDetailViewController.h
//  HCJD-User
//
//  Created by jiang on 16/12/30.
//  Copyright © 2016年 JinNing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

typedef void(^ZiXuanBlock)();

@interface ZiXuanDetailViewController : UIViewController

@property(nonatomic)ZiXuanBlock changeFavoriteBlock;

@property(nonatomic,retain)ProductModel *productModel;

@end
