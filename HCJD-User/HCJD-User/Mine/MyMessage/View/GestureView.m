//
//  GestureView.m
//  HCJD-User
//
//  Created by ZhangZi Long on 17/1/12.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import "GestureView.h"

@implementation GestureView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)createViewWithLeftTitle:(NSString *)lefttitle withRightTitle:(NSString *)righttitle withImageName:(NSString *)imageName{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    [self addSubview:view];
    //左侧title
    UILabel *leftLabel = [[UILabel alloc]init];
    leftLabel.text = lefttitle;
    leftLabel.textColor = kRGB(102, 102, 102);
    leftLabel.font = [UIFont systemFontOfSize:18];
    [view addSubview:leftLabel];
    leftLabel.sd_layout
    .leftSpaceToView(view,10)
    .heightIs(30)
    .centerYEqualToView(view)
    .widthIs(kScreenWidth/3);
    
    //右侧箭头
    UIImageView *rightImage = [[UIImageView alloc]init];
    rightImage.image = [UIImage imageNamed:imageName];
    [view addSubview:rightImage];
    rightImage.sd_layout
    .widthIs(8)
    .heightIs(15)
    .centerYEqualToView(view)
    .rightSpaceToView(view,10);
    
    //右侧title
    _rightLabel = [[UILabel alloc]init];
    _rightLabel.textAlignment = NSTextAlignmentRight;
    _rightLabel.font = [UIFont systemFontOfSize:18];
    _rightLabel.textColor = kRGB(102, 102, 102);
    _rightLabel.text = righttitle;
    [view addSubview:_rightLabel];
    _rightLabel.sd_layout
    .rightSpaceToView(rightImage,5)
    .heightIs(30)
    .centerYEqualToView(view)
    .widthIs(kScreenWidth/3);
    
    //底部灰线
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = kRGB(153, 153, 153);
    [view addSubview:lineLabel];
    lineLabel.sd_layout
    .leftSpaceToView(view,0)
    .bottomSpaceToView(view,0)
    .heightIs(1)
    .widthIs(kScreenWidth);
    
    
}



@end
