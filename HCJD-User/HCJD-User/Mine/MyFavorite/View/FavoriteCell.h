//
//  FavoriteCell.h
//  HCJD-User
//
//  Created by ZhangZi Long on 17/1/4.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteCell : UITableViewCell

/*
 *是否是套餐
 */
@property (assign,nonatomic) BOOL taocan;

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

@end
