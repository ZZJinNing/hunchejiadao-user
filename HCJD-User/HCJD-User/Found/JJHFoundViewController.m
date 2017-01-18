//
//  JJHFoundViewController.m
//  marriedCarComeIng
//
//  Created by jiang on 17/1/11.
//  Copyright © 2017年 com.meiniu. All rights reserved.
//

#import "JJHFoundViewController.h"
#import "JJHFoundView.h"
#import "JJHFoundGroupModel.h"
#import "JJHFoundModel.h"
#import "webViewController.h"
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface JJHFoundViewController ()
{
    //滚动视图
    UIScrollView *_scrollView;
    //数据源
    NSMutableArray *_dataSource;
    //高度
    float _height;
  
}
@end

@implementation JJHFoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发现";
    
    self.view.backgroundColor = grayBG;
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT)];
    _scrollView.backgroundColor = grayBG;
    [self.view addSubview:_scrollView];
    _dataSource = [[NSMutableArray alloc]init];
    _height = 10;
    
    [self getFoundDataSource];
    
}
#pragma mark - 数据源
- (void)getFoundDataSource{
    [[MNDownLoad shareManager]POSTWithoutGitHUD:@"menuFind" param:nil success:^(NSDictionary *dic) {
        
//        NSLog(@"%@",dic);
        
        NSArray *returnArray = dic[@"return"];
        for (NSDictionary *returnDic in returnArray) {
            JJHFoundGroupModel *groupModel = [[JJHFoundGroupModel alloc]init];
            groupModel.title = returnDic[@"title"];
            NSArray *findList = returnDic[@"find_list"];
            for (NSDictionary *findDic in findList) {
                JJHFoundModel *model = [[JJHFoundModel alloc]init];
                model.BgColor = [NSString stringWithFormat:@"%@",findDic[@"corner_bgcolor_rgb"]];
                model.cornerColor = [NSString stringWithFormat:@"%@",findDic[@"corner_color_rgb"]];
                model.cornerTitle = findDic[@"corner_title"];
                model.title = findDic[@"title"];
                model.iconStr = findDic[@"icon"];
                model.url = findDic[@"href"];
                model.is_corner = [NSString stringWithFormat:@"%@",findDic[@"is_corner"]];
                [groupModel.groupArray addObject:model];
            }
            
            [_dataSource addObject:groupModel];
        }
        
        //布局UI
        [self setUPUI];
        
    } failure:^(NSError *error) {
        
    } withSuperView:self];
}

//布局UI
- (void)setUPUI{
    
    
    for (int i = 0; i < _dataSource.count; i++) {
        JJHFoundGroupModel *groupModel = _dataSource[i];
       
        NSInteger allNum;
        NSInteger num1 = groupModel.groupArray.count/4;
        NSInteger num2 = groupModel.groupArray.count%4;
        if (num2 == 0) {
            allNum = num1;
        }else{
            allNum = num1 + 1;
        }
        
        //计算baseView的高度
        float H = 120 * allNum + 50;
      
        UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(0,_height, SCREEN_WIDTH, H)];
        baseView.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:baseView];
        
        _height += H+10;
        
        //标题
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 25)];
        titleLabel.text = groupModel.title;
        titleLabel.textColor = wordColorDark;
        titleLabel.font = [UIFont systemFontOfSize:18];
        [baseView addSubview:titleLabel];
    
        [self getBaseView:baseView WithModel:groupModel];
    }
 
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _height+64);
    
}


- (void)getBaseView:(UIView*)baseView WithModel:(JJHFoundGroupModel*)groupModel{
  
    NSInteger allNum;
    NSInteger num1 = groupModel.groupArray.count/4;
    NSInteger num2 = groupModel.groupArray.count%4;
    if (num2 == 0) {
        allNum = num1;
    }else{
        allNum = num1 + 1;
    }
    NSInteger flag = 0;
    float width = SCREEN_WIDTH/4;
    float height = 120;
    
    //======在没有内容时画框===============
    NSInteger myNumber = 0;
    if (num2 == 0) {
        for (int i = 0; i < num1; i++) {
            for (int j = 0; j < 4; j++) {
                myNumber ++;
                if (myNumber >= groupModel.groupArray.count) {
                    UIView *view = [[JJHFoundView alloc]initWithFrame:CGRectMake(width * j, 50+height * i, width, height)];
                    view.layer.borderWidth = 1.0;
                    view.layer.borderColor = [grayBG CGColor];
                    [baseView addSubview:view];
                }
            }
        }

    }else{
        for (int i = 0; i < num1+1; i++) {
            for (int j = 0; j < 4; j++) {
                myNumber ++;
                if (myNumber >= groupModel.groupArray.count) {
                    UIView *view = [[JJHFoundView alloc]initWithFrame:CGRectMake(width * j, 50+height * i, width, height)];
                    view.layer.borderWidth = 1.0;
                    view.layer.borderColor = [grayBG CGColor];
                    [baseView addSubview:view];
                    view.layer.borderWidth = 1.0;
                    view.layer.borderColor = [grayBG CGColor];
                    [baseView addSubview:view];
                }
            }
        }

    }
    
    
    if (num2 == 0) {
        for (int i = 0; i < num1; i++) {
            for (int j = 0; j < 4; j++) {
                JJHFoundModel *model = groupModel.groupArray[flag];
                JJHFoundView *view = [[JJHFoundView alloc]initWithFrame:CGRectMake(width * j, 50+height * i, width, height) WithModel:model];
                
                [view setUPUI];
                [baseView addSubview:view];
                flag++;
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.titleLabel.text = model.url;
                button.titleLabel.textColor = [UIColor clearColor];
                button.frame = CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.width);
                [button addTarget:self action:@selector(meNuButton:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:button];
            }
            
        }
    }else{
       
        for (int i = 0; i < num1+1; i++) {
            for (int j = 0; j < 4; j++) {
                JJHFoundModel *model = groupModel.groupArray[flag];
                JJHFoundView *view = [[JJHFoundView alloc]initWithFrame:CGRectMake(width * j, 50+height * i, width, height) WithModel:model];
                
                [view setUPUI];
                [baseView addSubview:view];
                flag++;
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.titleLabel.text = model.url;
                button.titleLabel.textColor = [UIColor clearColor];
                button.frame = CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.width);
                [button addTarget:self action:@selector(meNuButton:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:button];
                if (flag >= groupModel.groupArray.count) {
        
                    return;
                }
            }
            
        }
    
        
    }
    
}

- (void)meNuButton:(UIButton*)button{
    NSString *url = button.titleLabel.text;
    webViewController *vc = [[webViewController alloc]init];
    vc.url = url;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}




@end











