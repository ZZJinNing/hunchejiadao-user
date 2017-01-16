//
//  HomeDetailViewController.m
//  HCJD-User
//
//  Created by jiang on 16/12/30.
//  Copyright © 2016年 JinNing. All rights reserved.
//

#import "ZiXuanDetailViewController.h"
#import "KeFuVC.h"
#import "CarCollectionView.h"
#import "MyTeamViewController.h"
#import "DetailModel.h"

#import "SDCycleScrollView.h"

@interface ZiXuanDetailViewController ()<UIWebViewDelegate>
{
    UIScrollView *_scrollView;
    
    UIWebView *_webView;
    
    //总高度
    float _allHeight;
    
    //上部高度
    float _topHeight;
    
    //收藏按钮
    UIImageView *_collectionImageView;
    
    //订单数量
    UILabel *_numberLabel;
    
    //加减之后的数量
    NSInteger _number;
    
    MNDownLoad *_downLoad;
    
    DetailModel *_detailModel;
    
    //轮播图
    SDCycleScrollView *_cycleScrollView;
    
    //是否收藏
    BOOL collection;
    
    //底部View的定金
    UILabel *_dingJinLabel;
    
    //底部View的总价
    UILabel *_allLabel;
    
    //车队数量
    CarCollectionView *_carView;
    
    //车队数量
    NSInteger cart_num;
}
@end

@implementation ZiXuanDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"自选详情";
    _downLoad = [MNDownLoad shareManager];
    
    _detailModel = [[DetailModel alloc]init];
    
    collection = NO;
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-124)];
    _scrollView.backgroundColor = grayBG;
    [self.view addSubview:_scrollView];
    
    //头部视图
    [self topView];
    //加载webView
    [self loadWebView];
    //尾部视图
    [self belowView];
    
    [self getDataSource];
    
}

#pragma mark - 数据源
- (void)getDataSource{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.productModel._id forKey:@"_id"];
    [_downLoad POST:@"productDetail" param:param success:^(NSDictionary *dic) {
//        NSLog(@"%@",dic);
        NSDictionary *returnDic = dic[@"return"];
        
        [_detailModel setupValueWith:returnDic];
        
        if ([_detailModel.is_collect integerValue] == 1) {
            _collectionImageView.image = [UIImage imageNamed:@"iconRed"];
        }else{
            _collectionImageView.image = [UIImage imageNamed:@"iconGray"];
        }
        
    } failure:^(NSError *error) {
        
    } withSuperView:self];
}

#pragma mark - 头部视图
- (void)topView{
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/3*2)];
    _topHeight = kScreenWidth/3*2;
    whiteView.backgroundColor = grayBG;
    [_scrollView addSubview:whiteView];
    
    [self topImageViewWithView:whiteView];
}

- (void)topImageViewWithView:(UIView*)view{
    
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/3*2) delegate:nil placeholderImage:[UIImage imageNamed:@"image"]];
    _cycleScrollView.imageURLStringsGroup = _productModel.image_listUrl;
    [view addSubview:_cycleScrollView];
    
    //============客服================
    UIView *keFuView = [[UIView alloc]init];
    keFuView.backgroundColor = kRGBA(138, 110, 109,0.5);
    keFuView.layer.masksToBounds = YES;
    keFuView.layer.cornerRadius = 22;
    [_cycleScrollView addSubview:keFuView];
    keFuView.sd_layout
    .rightSpaceToView(_cycleScrollView,10)
    .topSpaceToView(_cycleScrollView,10)
    .widthIs(44)
    .heightIs(44);
    
    //给客服添加点击事件
    UITapGestureRecognizer * keFutgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandlekeFu)];
    [keFuView addGestureRecognizer:keFutgr];
    
    UIImageView *keFuImageView = [[UIImageView alloc]init];
    keFuImageView.image = [UIImage imageNamed:@"icon_kf"];
    [keFuView addSubview:keFuImageView];
    keFuImageView.sd_layout
    .centerXEqualToView(keFuView)
    .centerYEqualToView(keFuView)
    .widthIs(35)
    .heightIs(28);
    
    
    //================点赞收藏图片===================
    UIView *collectionView = [[UIView alloc]init];
    collectionView.backgroundColor = kRGBA(138, 110, 109,0.5);
    collectionView.layer.masksToBounds = YES;
    collectionView.layer.cornerRadius = 22;
    [_cycleScrollView addSubview:collectionView];
    collectionView.sd_layout
    .rightSpaceToView(keFuView,15)
    .topSpaceToView(_cycleScrollView,10)
    .widthIs(44)
    .heightIs(44);

    //给点赞收藏添加点击事件
    UITapGestureRecognizer * collectiontgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandlecollection)];
    
    [collectionView addGestureRecognizer:collectiontgr];
    
    _collectionImageView = [[UIImageView alloc]init];
    _collectionImageView.image = [UIImage imageNamed:@"iconGray"];
    [collectionView addSubview:_collectionImageView];
    _collectionImageView.sd_layout
    .centerXEqualToView(collectionView)
    .centerYEqualToView(collectionView)
    .widthIs(30)
    .heightIs(30);
    
    //================介绍详情===============
    UIView *detailView = [[UIView alloc]init];
    detailView.backgroundColor = kRGBA(150, 150, 150,0.5);
    [view addSubview:detailView];
    detailView.sd_layout
    .leftSpaceToView(view,0)
    .rightSpaceToView(view,0)
    .bottomSpaceToView(view,0)
    .heightIs(90);
    [self createDetailView:detailView];
    
}

#pragma mark--客服按钮
- (void)tapHandlekeFu{
    
    KeFuVC *vc = [[KeFuVC alloc]init];
    vc.view.backgroundColor = grayBG;
    [self.navigationController  pushViewController:vc animated:YES];
    
}
#pragma mark--收藏按钮
- (void)tapHandlecollection{
    
    [self collectSwitch];
    
    if (collection == YES) {
        //取消收藏
        _collectionImageView.image = [UIImage imageNamed:@"iconGray"];
        
        collection = NO;
    }else if (collection == NO){
        //收藏
        _collectionImageView.image = [UIImage imageNamed:@"iconRed"];
        
        collection = YES;
    }
}
//添加或取消收藏
- (void)collectSwitch{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_productModel._id forKey:@"product_id"];
    [param setObject:@"product" forKey:@"type"];
    [_downLoad POST:@"collectSwitch" param:param success:^(NSDictionary *dic) {
        
        NSLog(@"%@",dic);
        
    } failure:^(NSError *error) {
        
    } withSuperView:self];
}
#pragma mark--介绍详情视图
- (void)createDetailView:(UIView*)view{
    
    NSString *carStr = [NSString stringWithFormat:@"%@",_productModel.name];
    NSString *frontStr = [NSString stringWithFormat:@"优惠价:¥%@",_productModel.price_total];
    NSString *marketStr = [NSString stringWithFormat:@"市场价:¥%@",_productModel.price_market];
    
    NSArray *array = @[carStr,frontStr,marketStr];
    for (int i = 0; i < array.count; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 30*i, kScreenWidth/2, 30)];
        label.text = array[i];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:15];
        [view addSubview:label];
        
        if (i == 2) {
            UILabel*lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 75, 100, 1)];
            lineLabel.backgroundColor = [UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:1];
            [view addSubview:lineLabel];
        }
    }
    
    
    //=============定金========================
    UILabel *depositLabel = [[UILabel alloc]init];
    depositLabel.textColor = [UIColor whiteColor];
    depositLabel.text = [NSString stringWithFormat:@"定金:￥%@",_productModel.price_front];
    depositLabel.font = [UIFont systemFontOfSize:15];
    depositLabel.textAlignment = NSTextAlignmentCenter;
    //设置边框宽度和颜色
    depositLabel.layer.borderWidth = 1;
    depositLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    [view addSubview:depositLabel];
    depositLabel.sd_layout
    .rightSpaceToView(view,15)
    .topSpaceToView(view,8)
    .widthIs(100)
    .heightIs(30);
    
    //=========订单数量===========
    UIButton *addBtn = [[UIButton alloc]init];
    [addBtn setTitle:@"+" forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addButton) forControlEvents:UIControlEventTouchUpInside];
    addBtn.backgroundColor = kRGBA(100, 100, 100,0.3);
    [view addSubview:addBtn];
    addBtn.sd_layout
    .rightSpaceToView(view,15)
    .topSpaceToView(depositLabel,10)
    .widthIs(30)
    .heightIs(30);
    
    _numberLabel = [[UILabel alloc]init];
    _number = 1;
    _numberLabel.text = [NSString stringWithFormat:@"%ld",_number];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.textColor = [UIColor redColor];
    [view addSubview:_numberLabel];
    _numberLabel.sd_layout
    .rightSpaceToView(addBtn,5)
    .topSpaceToView(depositLabel,10)
    .widthIs(30)
    .heightIs(30);
    
    
    UIButton *jianButton = [[UIButton alloc]init];
    [jianButton setTitle:@"-" forState:UIControlStateNormal];
    [jianButton addTarget:self action:@selector(jianButton) forControlEvents:UIControlEventTouchUpInside];
    jianButton.backgroundColor = kRGBA(100, 100, 100,0.3);
    [view addSubview:jianButton];
    jianButton.sd_layout
    .rightSpaceToView(_numberLabel,0)
    .topSpaceToView(depositLabel,10)
    .widthIs(30)
    .heightIs(30);
    
}

#pragma mark--===加===
- (void)addButton{
    _number++;
    _numberLabel.text = [NSString stringWithFormat:@"%ld",_number];
    
    [self changeMoney];
}
#pragma mark--===减===
- (void)jianButton{
    _number--;
    if (_number <= 0) {
        _number = 1;
        return;
    }
    _numberLabel.text = [NSString stringWithFormat:@"%ld",_number];
    
    [self changeMoney];
}
#pragma mark--修改Money
- (void)changeMoney{
    //修改定金
    NSString *str = [NSString stringWithFormat:@"定金:￥%ld",[_productModel.price_front integerValue]*_number];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, str.length - 4)];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(4, str.length - 4)];
    _dingJinLabel.attributedText = string;
    
    //修改总价
    _allLabel.text = [NSString stringWithFormat:@"总价:￥%ld",[_productModel.price_total integerValue]*_number];
}


#pragma mark - 加载webView
- (void)loadWebView{
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, _topHeight + 5, kScreenWidth, kScreenHeight)];
    
    NSString *urlPath = [[NSBundle mainBundle] pathForResource:@"user" ofType:@"plist"];
    
    NSDictionary *plistDic = [NSDictionary dictionaryWithContentsOfFile:urlPath];
    
    NSString *Myurl = [NSString stringWithFormat:@"%@productDetail",plistDic[@"webURL"]];
    
    NSString *param = [NSString stringWithFormat:@"_id=%@",_productModel._id];
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:Myurl]];
    
    _webView.delegate = self;
    
    [_scrollView addSubview: _webView];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[param dataUsingEncoding: NSUTF8StringEncoding]];
    [_webView loadRequest:request];
}
#pragma mark--webView代理
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _webView.frame = CGRectMake(0, _topHeight + 10, kScreenWidth, _webView.scrollView.contentSize.height);
    float h = _webView.scrollView.contentSize.height;
    _allHeight = h + _topHeight + 10;
    _scrollView.contentSize = CGSizeMake(kScreenWidth, _allHeight);
}


#pragma mark - 底部的view
- (void)belowView{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 124, kScreenWidth, 60)];
    bgView.backgroundColor = grayBG;
    [self.view addSubview:bgView];
    
    NSString *cartNum = [[NSUserDefaults standardUserDefaults]objectForKey:HCJDCart_num];
    
    cart_num = [cartNum integerValue];
    
    _carView = [[CarCollectionView alloc]initWithFrame:CGRectMake(0, 0, 80, 60) withNumber:cart_num];
    [bgView addSubview:_carView];
    //添加点击事件
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handle)];
    [_carView addGestureRecognizer:tgr];
 
   
    //===========加入车队按钮==================
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(bgView.bounds.size.width - 100, 0, 100, 60);
    [button setTitle:@"加入车队" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(joinTheTeam) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = kRGBA(249, 30, 51, 1);
    [bgView addSubview:button];
    
    
    //============定金  总价======================
    _dingJinLabel = [[UILabel alloc]init];
    _dingJinLabel.font = [UIFont systemFontOfSize:15];
    _dingJinLabel.textAlignment = NSTextAlignmentRight;
    _dingJinLabel.textColor = wordColorDark;
    [bgView addSubview:_dingJinLabel];
    _dingJinLabel.sd_layout
    .rightSpaceToView(button,10)
    .topSpaceToView(bgView,5)
    .widthIs(200)
    .heightIs(30);
    
    NSString *str = [NSString stringWithFormat:@"定金:¥%@",_productModel.price_front];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, str.length - 4)];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(4, str.length - 4)];
    _dingJinLabel.attributedText = string;
    
    
    _allLabel = [[UILabel alloc]init];
    _allLabel.font = [UIFont systemFontOfSize:15];
    _allLabel.textColor = wordColorDark;
    _allLabel.text = [NSString stringWithFormat:@"总价:¥%@",_productModel.price_total];
    _allLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:_allLabel];
    _allLabel.sd_layout
    .rightSpaceToView(button,10)
    .topSpaceToView(_dingJinLabel,-5)
    .widthIs(200)
    .heightIs(30);
    
}
#pragma mark - 加入车队
- (void)joinTheTeam{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_productModel._id forKey:@"product_id"];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)_number] forKey:@"product_num"];
    [param setObject:@"0" forKey:@"is_sure"];
    
    [_downLoad POST:@"cartAddProduct" param:param success:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        
        NSInteger status = [dic[@"status"] integerValue];
        if (status == -2) {
            [param setObject:@"1" forKey:@"is_sure"];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否覆盖头车" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"       取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [_downLoad POST:@"cartAddProduct" param:param success:^(NSDictionary *dic) {
                    
                    //修改车队数量
                    NSString *cart_numStr = [NSString stringWithFormat:@"%@",dic[@"return"][@"cart_num"]];
                    NSInteger cartTotal = [cart_numStr integerValue];
                    _carView.numberLable.text = [NSString stringWithFormat:@"%ld",(long)cartTotal];
                    //保存车队数量
                    [[NSUserDefaults standardUserDefaults]setObject:cart_numStr forKey:HCJDCart_num];
                    
                    //修改成功提示
                    UIAlertView *OKAlert = [[UIAlertView alloc]initWithTitle:@"修改成功" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [OKAlert show];
                    
                } failure:^(NSError *error) {
                    
                } withSuperView:self];
            }];
            [alert addAction:cancel];
            [alert addAction:sure];
            
            [self presentViewController:alert animated:YES completion:nil];
        }else if (status == 1){
            //修改车队数量
            NSString *cart_numStr = [NSString stringWithFormat:@"%@",dic[@"return"][@"cart_num"]];
            NSInteger cartTotal = [cart_numStr integerValue];
            _carView.numberLable.text = [NSString stringWithFormat:@"%ld",(long)cartTotal];
            //保存车队数量
            [[NSUserDefaults standardUserDefaults]setObject:cart_numStr forKey:HCJDCart_num];
            
        }else if (status == 0){
            NSString *info = [NSString stringWithFormat:@"%@",dic[@"info"]];
            //加入失败
            UIAlertView *infoAlert = [[UIAlertView alloc]initWithTitle:nil message:info delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [infoAlert show];
        }
        
        
    } failure:^(NSError *error) {
        
    } withSuperView:self];
}
#pragma mark - 我的车队
- (void)handle{
    MyTeamViewController *vc = [[MyTeamViewController alloc]init];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
   
}

@end


































