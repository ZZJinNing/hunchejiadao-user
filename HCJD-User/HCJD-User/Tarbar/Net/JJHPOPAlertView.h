//
//  JJHPOPAlertView.h
//  marriedCarComeIng
//
//  Created by jiang on 16/12/7.
//  Copyright © 2016年 com.meiniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JJHPOPAlertView : NSObject

- (id)initWithSuperView:(UIViewController*)superController withCode:(NSString *)code;

- (void)popView;


@property (nonatomic,weak)UIViewController *superController;
@property (nonatomic,copy)NSString *code;
 

@end
