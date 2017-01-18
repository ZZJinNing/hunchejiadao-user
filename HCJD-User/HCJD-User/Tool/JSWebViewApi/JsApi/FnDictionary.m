//
//  FnDictionary.m
//  webViewApi
//
//  Created by jiang on 16/12/5.
//  Copyright © 2016年 com.meiniucn. All rights reserved.
//

#import "FnDictionary.h"

@interface FnDictionary ()
{
    NSString *_index;
    NSMutableDictionary *_baseDic;

}
@end

@implementation FnDictionary

- (instancetype)init
{
    self = [super init];
    if (self) {
        _index = @"0";
        _baseDic = [[NSMutableDictionary alloc]init];
        
    }
    return self;
}

- (NSString*)getIndex{
    NSInteger INDEX = [_index integerValue];
    INDEX++;
    _index = [NSString stringWithFormat:@"%ld", (long)INDEX];
    return _index;
}

//添加对应模块的对应方法
- (NSString*)add:(NSString *)Key value:(NSString *)fn{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSString *indexStr = [NSString stringWithFormat:@"%@",[self getIndex]];
    [dic setValue:fn forKey:indexStr];
    
    [_baseDic setValue:dic forKey:Key];
    
    return indexStr;
}

//获取所有模块
- (NSMutableDictionary*)getModel:(NSString *)key{
    return _baseDic[key];
}

//获取单个模块
- (NSString*)getFn:(NSString *)key andindex:(NSString*)index{
    NSMutableDictionary *dic = _baseDic[key];
    NSString *indexStr = [NSString stringWithFormat:@"%@",index];
    NSString *fn = dic[indexStr];
    return fn;
}

//删除对应坐标的回调方法
- (void)removeFn:(NSString *)key andIndex:(NSString*)index{
    NSMutableDictionary *dic = _baseDic[key];
    NSString *indexStr = [NSString stringWithFormat:@"%@",index];
    [dic removeObjectForKey:indexStr];
    
}
//删除对应模块
- (void)removeModel:(NSString *)key{
    [_baseDic removeObjectForKey:key];
}

@end
