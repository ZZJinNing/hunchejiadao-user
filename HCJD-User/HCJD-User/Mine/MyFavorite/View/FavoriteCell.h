//
//  FavoriteCell.h
//  HCJD-User
//
//  Created by ZhangZi Long on 17/1/4.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
#import "ProductGroupModel.h"

typedef void(^cancelFavoriteBlock)();

@interface FavoriteCell : UITableViewCell

/*
 *取消收藏
 */
@property (nonatomic)cancelFavoriteBlock cancelBlock;

/*
 *ID
 */
@property (nonatomic,retain)NSString *ID;

/*
 *左侧图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
/*
 *套餐或者车名
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/*
 *定金
 */
@property (weak, nonatomic) IBOutlet UILabel *advanceLabel;
/*
 *总价格
 */
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
/*
 *套餐标签图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *taocanImageView;
/*
 *左侧头车
 */
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
/*
 *头车名字
 */
@property (weak, nonatomic) IBOutlet UILabel *headCarLabel;
/*
 *取消收藏按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *noFavoriteBtn;
/*
 *底部灰条
 */
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;



- (void)setupProductValueWith:(ProductModel *)productModel;

- (void)setupGroupValueWith:(ProductGroupModel *)groupModel;

- (void)weatherHidden;
@end
