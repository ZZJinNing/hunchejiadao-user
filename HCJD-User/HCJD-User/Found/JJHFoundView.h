//
//  JJHFoundView.h
//  marriedCarComeIng
//
//  Created by jiang on 17/1/11.
//  Copyright © 2017年 com.meiniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJHFoundModel.h"

@interface JJHFoundView : UIView

- (instancetype)initWithFrame:(CGRect)frame WithModel:(JJHFoundModel*)model;
//布局界面
- (void)setUPUI;
////消息label
@property (nonatomic,strong)UILabel *messageLabel;

@end
