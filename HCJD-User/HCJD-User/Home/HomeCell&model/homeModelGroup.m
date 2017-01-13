//
//  homeModelGroup.m
//  HCJD-User
//
//  Created by jiang on 16/12/29.
//  Copyright © 2016年 JinNing. All rights reserved.
//

#import "homeModelGroup.h"

@implementation homeModelGroup

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.carModelGroup = [[NSMutableArray alloc]init];
    }
    return self;
}

@end
