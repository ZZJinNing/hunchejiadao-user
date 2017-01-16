//
//  MNDownLoad.m
//  HCJD-User
//
//  Created by jiang on 17/1/7.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import "MNDownLoad.h"
#import "AESEncryption.h"
#import "JJHPOPAlertView.h"
#import "MBProgressHUD+Add.h"
#import "AppDelegate.h"

#import "GiFHUD.h"

@interface MNDownLoad (){
    NSDictionary *userDic;
}

@property(nonatomic,strong)AFHTTPSessionManager * manager;

@end

@implementation MNDownLoad

//单例
+(instancetype)shareManager{
    static MNDownLoad * dle = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        dle = [[MNDownLoad alloc] init];
        
    });
    return dle;
}


- (instancetype)init{
    
    self = [super init];
    
    
    if (self) {
        
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
        
    }
    return self;
}


/**
 *  数据请求，页面附带动态图效果
 */

- (void)POST:(NSString*)url param:(NSDictionary*)para success:(Success)success failure:(Failure)failure withSuperView:(UIViewController *)superController{
    
    [GiFHUD setGifWithImageName:@"monkey.gif"];//加载动态图
    
    [GiFHUD showWithOverlay];//添加蒙板
    
    
    NSString *urlPath = [[NSBundle mainBundle] pathForResource:@"user" ofType:@"plist"];
    userDic = [NSDictionary dictionaryWithContentsOfFile:urlPath];
    NSString *Myurl = userDic[@"baseURL"];
    NSString *baseURL = [NSString stringWithFormat:@"%@%@",Myurl,url];
    
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIWindow *MNWindow = appdelegate.window;
    
    
    NSMutableDictionary *Myparam = [[NSMutableDictionary alloc]initWithDictionary:para];
    NSString *account = [[NSUserDefaults standardUserDefaults]objectForKey:HCJDPhone];
    NSString *password = [[NSUserDefaults standardUserDefaults]objectForKey:HCJDPassword];
    [Myparam setObject:@"true" forKey:@"ajax"];
    [Myparam setObject:@"iOS" forKey:@"_device"];
    
    if (password && account) {
        [Myparam setObject:password forKey:@"_password"];
        [Myparam setObject:account forKey:@"_account"];
    }
    
    [_manager POST:baseURL parameters:Myparam progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [GiFHUD dismiss];
        if (success) {
            
            NSDictionary *dic = [self decrypeJsonWithData:responseObject];
            
            NSString *code = dic[@"code"];
            if ([code isEqualToString:@"login"]) {
                JJHPOPAlertView *allert = [[JJHPOPAlertView alloc]initWithSuperView:superController withCode:code];
                [allert popView];
            }else{
                success(dic);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [GiFHUD dismiss];
        [MBProgressHUD showSuccess:@"网络加载失败" toView:MNWindow];
        if (failure) {
            failure(error);
        }
    }];
}


/**
 *  数据请求，页面没有动态图效果
 */
- (void)POSTWithoutGitHUD:(NSString*)url param:(NSDictionary*)para success:(Success)success failure:(Failure)failure withSuperView:(UIViewController *)superController{
    
    NSString *urlPath = [[NSBundle mainBundle] pathForResource:@"user" ofType:@"plist"];
    userDic = [NSDictionary dictionaryWithContentsOfFile:urlPath];
    NSString *Myurl = userDic[@"baseURL"];
    NSString *baseURL = [NSString stringWithFormat:@"%@%@",Myurl,url];
    
    //在刚刚进来时就显示菊花转
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIWindow *MNWindow = appdelegate.window;
    
    //    [MBProgressHUD showMessag:@"正在加载中" toView:MNWindow];
    NSMutableDictionary *Myparam = [[NSMutableDictionary alloc]initWithDictionary:para];
    NSString *account = [[NSUserDefaults standardUserDefaults]objectForKey:HCJDPhone];
    NSString *password = [[NSUserDefaults standardUserDefaults]objectForKey:HCJDPassword];
    [Myparam setObject:@"true" forKey:@"ajax"];
    [Myparam setObject:@"iOS" forKey:@"_device"];
    
    if (password && account) {
        [Myparam setObject:password forKey:@"_password"];
        [Myparam setObject:account forKey:@"_account"];
    }
    
    [_manager POST:baseURL parameters:Myparam progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            
            //            [MBProgressHUD hideAllHUDsForView:MNWindow animated:YES];
            
            NSDictionary *dic = [self decrypeJsonWithData:responseObject];
            
            NSString *code = dic[@"code"];
            if ([code isEqualToString:@"login"]) {
                JJHPOPAlertView *allert = [[JJHPOPAlertView alloc]initWithSuperView:superController withCode:code];
                [allert popView];
            }else{
                success(dic);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //        [MBProgressHUD hideAllHUDsForView:MNWindow animated:YES];
        [MBProgressHUD showSuccess:@"网络加载失败" toView:MNWindow];
        if (failure) {
            failure(error);
        }
        
    }];
    
}



/**
 *  NSData转JSON对象
 */
- (id)decrypeJsonWithData:(NSData *)data
{
    // 1. 转成字符串
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    // 2. 解密
    
    BOOL test = [userDic[@"test"] boolValue];
    NSString *str;
    if (test == 1) {
        //正式版秘钥
        str = [AESEncryption decryptUseAES:jsonStr key:@"Krs*xcK!mnUeDqDw" iv:@"#@ZIEJg!ykGx3tWm"];
    }else{
        //测试版秘钥
        str = [AESEncryption decryptUseAES:jsonStr key:@"9ozLook&KIFzNVI6" iv:@"5St&cDfZEXW2Gzjb"];
    }
    
    NSString * str2 = [str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    str2 = [str2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str2 = [str2 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str2 = [str2 stringByReplacingOccurrencesOfString:@"\0" withString:@""];
    str2 = [str2 stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    NSDictionary *dic = [self dictionaryWithJsonString:str2];
    // 3. 转成json对象
    return dic;
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                               options:NSJSONReadingMutableLeaves
                                                                 error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    
    return dic;
    
}



@end

























