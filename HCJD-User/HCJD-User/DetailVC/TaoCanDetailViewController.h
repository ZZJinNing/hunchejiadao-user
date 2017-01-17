//
//  HomeDetailViewController.h
//  HCJD-User
//
//  Created by jiang on 16/12/30.
//  Copyright © 2016年 JinNing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductGroupModel.h"

typedef void(^TanCanBlock)();//回调，刷新我的收藏界面的数据

@interface TaoCanDetailViewController : UIViewController

@property(nonatomic)TanCanBlock changeFavoriteBlock;

@property(nonatomic,retain)ProductGroupModel *productGroupModel;

@end
