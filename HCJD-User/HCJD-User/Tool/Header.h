//
//  Header.h
//  常用宏定义
//
//  Created by ZhangZi Long on 16/12/8.
//  Copyright © 2016年 JinNing. All rights reserved.
//

#ifndef Header_h
#define Header_h


#endif /* Header_h */



//开发的时候打印，但是发布的时候不打印的NSLog
#ifdef DEBUG
#define NSLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define NSLog(...)
#endif



//屏幕宽高
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kScreenSize \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale) : [UIScreen mainScreen].bounds.size)

//屏幕变化比例
#define kScaleWidth    kScreenWidth/320
#define kScaleHeight   kScreenHeight/568


// 获得RGB颜色
#define kRGBA(r, g, b, a)   [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define kRGB(r, g, b)        kRGBA(r, g, b, 1.0f)


//判断字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )


//判断数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)



//判断字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allK



//判断是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))



//获取APP版本号
#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShor"


//获取系统版本号

#define kSystemVersion [[UIDevice currentDevice] systemVersion]



//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//真机
#endif
#if TARGET_IPHONE_SIMULATOR
//模拟器
#endif



//判断设备的操做系统是不是ios7
#define IOS7 (［[UIDevice currentDevice].systemVersion doubleValue] >= 7.0]



//浅灰色字体
#define wordColor          [UIColor colorWithRed:110/255.0f green:110/255.0f blue:110/255.0f alpha:1]
//深灰色字体
#define wordColorDark      [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1]

//红色按钮背景色
#define btnColor           [UIColor colorWithRed:207/255.0f green:28/255.0f blue:44/255.0f alpha:1]
//线
#define LineColor [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:0.5]

//背景灰
#define grayBG [UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1]



//=================账号密码==================
//密码
#define HCJDPassword @"HCJDPassword"
//账号
#define HCJDPhone @"HCJDPhone"

//名字
#define HCJDName @"HCJDName"
//头像图片url
#define HCJDPhoto @"HCJDPhoto"














































