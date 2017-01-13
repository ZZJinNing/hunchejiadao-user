//
//  SearchMapViewController.h
//  HCJD-User
//
//  Created by jiang on 17/1/5.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NewBlock) (NSDictionary *);

@interface SearchMapViewController : UIViewController

//声明block的属性
@property (nonatomic) NewBlock MyBlock;

//声明block方法
- (void)chuanZhi:(NewBlock)block;

@end
