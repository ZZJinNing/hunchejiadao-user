//
//  GestureView.h
//  HCJD-User
//
//  Created by ZhangZi Long on 17/1/12.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GestureView : UIView
@property (nonatomic,retain) UILabel *rightLabel;

- (void)createViewWithLeftTitle:(NSString *)lefttitle withRightTitle:(NSString *)righttitle withImageName:(NSString *)imageName;
@end
