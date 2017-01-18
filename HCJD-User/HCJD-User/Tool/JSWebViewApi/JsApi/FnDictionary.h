//
//  FnDictionary.h
//  webViewApi
//
//  Created by jiang on 16/12/5.
//  Copyright © 2016年 com.meiniucn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FnDictionary : NSObject


//添加对应模块的对应方法
- (NSString *)add:(NSString*)Key value:(NSString*)fn;

//获取所有模块
- (NSDictionary *)getModel:(NSString*)key;

//获取单个模块
- (NSString *)getFn:(NSString*)key andindex:(NSString*)index;

//删除对应坐标的回调方法
- (void)removeFn:(NSString*)key andIndex:(NSString*)index;

//删除对应模块
- (void)removeModel:(NSString*)key;


@end
