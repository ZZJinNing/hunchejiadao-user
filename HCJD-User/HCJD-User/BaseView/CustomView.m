//
//  CustomView.m
//  HCJD-User
//
//  Created by ZhangZi Long on 17/1/9.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView

- (void)setupPlaceholderWith:(NSString *)placeholder withLeftImage:(NSString *)leftImageName{
    self.bounds = CGRectMake(0, 0, 0, 0);
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView *leftImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:leftImageName]];
    [self addSubview:leftImage];
    leftImage.sd_layout
    .leftSpaceToView(self,10)
    .centerYEqualToView(self)
    .heightIs(30)
    .widthIs(25);
    
    self.customTF = [[UITextField alloc]init];
    self.customTF.placeholder = placeholder;
    [self addSubview:self.customTF];
    self.customTF.sd_layout
    .leftSpaceToView(leftImage,15)
    .centerYEqualToView(self)
    .heightIs(30)
    .rightSpaceToView(self,10);
    
    
}



@end
