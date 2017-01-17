//
//  EmptyView.m
//  marriedCarComeIng
//
//  Created by jiang on 17/1/12.
//  Copyright © 2017年 com.meiniu. All rights reserved.
//

#import "EmptyView.h"

@implementation EmptyView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = grayBG;
        [self setUPUI];
    }
    return self;
}
 

//布局UI
- (void)setUPUI{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-logo"]];
    [self addSubview:imageView];
    imageView.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self,10)
    .widthIs(134)
    .heightIs(80);
    
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"亲，暂时没有数据哦";
    titleLabel.textColor = wordColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    titleLabel.sd_layout
    .topSpaceToView(imageView,20)
    .leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .heightIs(20);

}







@end



















