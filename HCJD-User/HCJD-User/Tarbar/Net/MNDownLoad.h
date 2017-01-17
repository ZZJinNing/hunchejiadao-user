//
//  MNDownLoad.h
//  HCJD-User
//
//  Created by jiang on 17/1/7.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Success)(NSDictionary * dic);
typedef void (^Failure)(NSError * error);

@interface MNDownLoad : NSObject


+(instancetype)shareManager;

- (void)POST:(NSString*)url param:(NSDictionary*)para success:(Success)success failure:(Failure)failure withSuperView:(UIViewController *)superController;

- (void)POSTWithoutGitHUD:(NSString*)url param:(NSDictionary*)para success:(Success)success failure:(Failure)failure withSuperView:(UIViewController *)superController;
/**
 *  数据请求，页面没有加载框
 */
- (void)POSTWithOutHUD:(NSString*)url param:(NSDictionary*)para success:(Success)success failure:(Failure)failure withSuperView:(UIViewController *)superController;



@end
