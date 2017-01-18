//
//  JJHFoundView.m
//  marriedCarComeIng
//
//  Created by jiang on 17/1/11.
//  Copyright © 2017年 com.meiniu. All rights reserved.
//

#import "JJHFoundView.h"

@interface JJHFoundView()
//小标背景颜色
@property (nonatomic)UIColor *BgColor;
//小标文字颜色
@property (nonatomic)UIColor *cornerColor;
//小标标题
@property (nonatomic,copy)NSString *cornerTitle;

//图标
@property (nonatomic,copy)NSString *iconStr;
//标题
@property (nonatomic,copy)NSString *title;
//是否显示小标
@property (nonatomic,copy)NSString *is_corner;


@end

@implementation JJHFoundView

- (instancetype)initWithFrame:(CGRect)frame WithModel:(JJHFoundModel*)model
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [grayBG CGColor];
         
        [self dealDataSourceWithModel:model];
    }
    return self;
}


//处理数据
- (void)dealDataSourceWithModel:(JJHFoundModel*)model{
    //图标
    _iconStr = model.iconStr;
    //标题
    _title = model.title;
    //小标标题
    _cornerTitle = model.cornerTitle;
    //小标背景色
    NSArray *colorBGArray = [model.BgColor componentsSeparatedByString:@","];
    _BgColor = kRGB([colorBGArray[0] floatValue], [colorBGArray[1] floatValue], [colorBGArray[2] floatValue]);
    //小标文字颜色
    NSArray *colorArray = [model.cornerColor componentsSeparatedByString:@","];
    _cornerColor = kRGB([colorArray[0] floatValue], [colorArray[1] floatValue], [colorArray[2] floatValue]);
    
    //是否显示小标
    _is_corner = model.is_corner;
    
}



//布局界面
- (void)setUPUI{
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_iconStr] placeholderImage:[UIImage imageNamed:@"placeHold"]];
    [self addSubview:imageView];
    [self addSubview:imageView];
    imageView.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self,25)
    .widthIs(50)
    .heightIs(50);
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 25;
    
    //消息label
    float width =  [self getWidthWithTitle:_cornerTitle font:[UIFont systemFontOfSize:12]];
    _messageLabel = [[UILabel alloc]init];
    [self addSubview:_messageLabel];
    _messageLabel.sd_layout
    .topSpaceToView(self,20)
    .leftSpaceToView(imageView,-20)
    .widthIs(width+10)
    .heightIs(20);
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.textColor = _cornerColor;
    _messageLabel.backgroundColor = _BgColor;
    _messageLabel.text = _cornerTitle;
    _messageLabel.layer.cornerRadius = 10;
    _messageLabel.layer.masksToBounds = YES;
    _messageLabel.font = [UIFont systemFontOfSize:12];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [self addSubview:titleLabel];
    titleLabel.sd_layout
    .topSpaceToView(imageView,10)
    .leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .heightIs(20);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = _title;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.font = [UIFont systemFontOfSize:15];
   
    
    if (![_is_corner isEqualToString:@"1"]) {
        [_messageLabel removeFromSuperview];
    }
    
    
    
}

- (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}

@end

























