//
//  CarCollectionView.h
//  HCJD-User
//
//  Created by jiang on 17/1/3.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarCollectionView : UIView

- (instancetype)initWithFrame:(CGRect)frame withNumber:(NSInteger)number;

/**
 获取车的数量
 */
- (void)getAllCarNumber;

@property (nonatomic,retain)UILabel *numberLable;

@end













