//
//  CarCollectionView.m
//  HCJD-User
//
//  Created by jiang on 17/1/3.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import "CarCollectionView.h"

@implementation CarCollectionView

- (instancetype)initWithFrame:(CGRect)frame withNumber:(NSInteger)number{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kRGBA(120, 120, 120, 0.5);
        [self setUpUI:number];
    }
    return self;
}


//布局UI
- (void)setUpUI:(NSInteger)number{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake((self.bounds.size.width/2-15), (self.bounds.size.height/2-11.5), 30, 23);
    imageView.image = [UIImage imageNamed:@"car"];
    [self addSubview:imageView];
    
    
    //数量
    _numberLable = [[UILabel alloc]init];
    _numberLable.frame = CGRectMake((imageView.bounds.size.width-7), 5, 17, -10);
    _numberLable.textAlignment = NSTextAlignmentCenter;
    _numberLable.font = [UIFont systemFontOfSize:12];
    _numberLable.adjustsFontSizeToFitWidth = YES;
    _numberLable.backgroundColor = kRGB(252, 44, 44);
    _numberLable.textColor = [UIColor whiteColor];
    _numberLable.layer.cornerRadius = 5;
    _numberLable.layer.masksToBounds = YES;
    _numberLable.text = [NSString stringWithFormat:@"%ld",number];
    [imageView addSubview:_numberLable];
    
}
//获取车队数量
- (void)getAllCarNumber{
    
    [[MNDownLoad shareManager]POSTWithOutHUD:@"cartNum" param:nil success:^(NSDictionary *dic) {
        NSString *number = [NSString stringWithFormat:@"%@",dic[@"return"][@"cart_num"]];
        _numberLable.text = number;
    } failure:^(NSError *error) {
        
    } withSuperView:nil];
}







@end













