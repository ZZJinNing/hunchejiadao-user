//
//  CustomView.h
//  HCJD-User
//
//  Created by ZhangZi Long on 17/1/9.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomView : UIView
@property (nonatomic,retain)UITextField *customTF;

- (void)setupPlaceholderWith:(NSString *)placeholder withLeftImage:(NSString *)leftImageName;

@end
