//
//  ChangeNickNameVC.h
//  HCJD-User
//
//  Created by ZhangZi Long on 17/1/4.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangeNickNameDelegate <NSObject>

- (void)newNickName:(NSString *)newName;

@end

@interface ChangeNickNameVC : UIViewController

@property (nonatomic,assign) id<ChangeNickNameDelegate> delegate;

@end
