//
//  HomeDetailViewController.m
//  HCJD-User
//
//  Created by jiang on 16/12/30.
//  Copyright © 2016年 JinNing. All rights reserved.
//

#import "TaoCanDetailViewController.h"
#import "SDCycleScrollView.h"
#import "KeFuVC.h"
#import "CarCollectionView.h"
#import "MyTeamViewController.h"
#import "DetailGroupModel.h"
@interface TaoCanDetailViewController ()<UIWebViewDelegate>
{
    UIScrollView *_scrollView;
    UIWebView *_webView;
    //总高度
    float _allHeight;
    //上部高度
    float _topHeight;
    //详情高度
    float _detailHeight;
    
    //收藏按钮
    UIImageView *_collectionImageView;
    //订单数量
    UILabel *_numberLabel;
    NSInteger _number;
    
    
    //头部视图
    UIView *_topview;
    //详情视图
    UIView *_detailView;
    //尾部视图
    UIView *_bottomView;
    
    MNDownLoad *_downLoad;
    
    DetailGroupModel *_detailGroupModel;
    
    SDCycleScrollView *_cycleScrollView;//轮播图
    
    //是否收藏
    BOOL _collection;
    
    //车队数量
    CarCollectionView *_carView;
    
    //车队数量
    NSInteger cart_num;
    
}
@end

@implementation TaoCanDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"套餐详情";
    
    _downLoad = [MNDownLoad shareManager];
    
    _detailGroupModel = [[DetailGroupModel alloc]init];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-124)];
    _scrollView.backgroundColor = grayBG;
    [self.view addSubview:_scrollView];
    
    //头部视图
    [self topImageView];
    
    //加载webView
    [self loadWebView];
    
    //底部视图
    [self bottomView];
    
    
    [self getDataSource];
}
#pragma mark - 数据源
- (void)getDataSource{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.productGroupModel._id forKey:@"_id"];
    [_downLoad POST:@"productGroupDetail" param:param success:^(NSDictionary *dic) {
        
        NSDictionary *returnDic = dic[@"return"];
        
        [_detailGroupModel setupValueWith:returnDic];
        
        if ([_detailGroupModel.is_collect integerValue] == 1) {
            
            _collection = YES;
            
            _collectionImageView.image = [UIImage imageNamed:@"iconRed"];
        }else{
            
            _collection = NO;
            
            _collectionImageView.image = [UIImage imageNamed:@"iconGray"];
        }
    } failure:^(NSError *error) {
        
    } withSuperView:self];
}


#pragma mark - 头部视图
- (void)topImageView{
    //初始化头部视图
    _topview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/3*2)];
    _topHeight = kScreenWidth/3*2;
    _topview.backgroundColor = [UIColor cyanColor];
    [_scrollView addSubview:_topview];
    
    
    //初始化顶部轮播视图
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, _topHeight) delegate:nil placeholderImage:[UIImage imageNamed:@"image"]];
    _cycleScrollView.placeholderImage = [UIImage imageNamed:@"bg"];
    _cycleScrollView.imageURLStringsGroup = _productGroupModel.image_listUrl;
    [_topview addSubview:_cycleScrollView];
    
    
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
}
//添加或取消收藏
- (void)collectSwitch{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_productGroupModel._id forKey:@"product_id"];
    [param setObject:@"group" forKey:@"type"];
    [_downLoad POST:@"collectSwitch" param:param success:^(NSDictionary *dic) {
        
<<<<<<< HEAD
//        NSLog(@"%@",dic);
=======
        NSString *type = [NSString stringWithFormat:@"%@",dic[@"return"][@"type"]];
        if ([type isEqualToString:@"add"]) {
            //收藏
            _collectionImageView.image = [UIImage imageNamed:@"iconRed"];
        }else if ([type isEqualToString:@"cancel"]){
            //取消收藏
            _collectionImageView.image = [UIImage imageNamed:@"iconGray"];
        }
        
        if (self.changeFavoriteBlock) {
            self.changeFavoriteBlock();
        }
>>>>>>> 0fda384059193aa1e59d2a4cb7b34788af50ae85
        
    } failure:^(NSError *error) {
        
    } withSuperView:self];
}

#pragma mark - 加载webView
- (void)loadWebView{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, _topHeight+16, kScreenWidth, kScreenHeight-_topHeight-145-16)];
    NSString *urlPath = [[NSBundle mainBundle] pathForResource:@"user" ofType:@"plist"];
    
    NSDictionary *plistDic = [NSDictionary dictionaryWithContentsOfFile:urlPath];
    
    NSString *Myurl = [NSString stringWithFormat:@"%@productGroupDetail",plistDic[@"webURL"]];
    
    NSString *param = [NSString stringWithFormat:@"_id=%@",_productGroupModel._id];
    
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
    
    _webView.frame = CGRectMake(0, _topHeight + 16 +_detailHeight, kScreenWidth, _webView.scrollView.contentSize.height);
    //webView的高度h
    float h = _webView.scrollView.contentSize.height;
    //scrollView的总高度
    _allHeight = h + _topHeight + _detailHeight + 16;
    _scrollView.contentSize = CGSizeMake(kScreenWidth, _allHeight);
}

#pragma mark - 底部的view
- (void)bottomView{
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 124, kScreenWidth, 60)];
    _bottomView.backgroundColor = grayBG;
    [self.view addSubview:_bottomView];
    
    
    NSString *cart_numStr = [[NSUserDefaults standardUserDefaults]objectForKey:HCJDCart_num];
    cart_num = [cart_numStr integerValue];
    _carView = [[CarCollectionView alloc]initWithFrame:CGRectMake(0, 0, 80, 60) withNumber:cart_num];
    [_bottomView addSubview:_carView];
    //添加点击事件
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handle)];
    [_carView addGestureRecognizer:tgr];
 
   
    //===========加入车队按钮==================
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(_bottomView.bounds.size.width - 100, 0, 100, 60);
    [button setTitle:@"加入车队" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(joinTheTeam) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = kRGBA(249, 30, 51, 1);
    [_bottomView addSubview:button];
    
    
    //============定金  总价======================
    UILabel *dingJinLabel = [[UILabel alloc]init];
    dingJinLabel.font = [UIFont systemFontOfSize:15];
    dingJinLabel.textAlignment = NSTextAlignmentRight;
    dingJinLabel.textColor = wordColorDark;
    [_bottomView addSubview:dingJinLabel];
    dingJinLabel.sd_layout
    .rightSpaceToView(button,10)
    .topSpaceToView(_bottomView,5)
    .widthIs(200)
    .heightIs(30);
    
    NSString *str = @"定金:¥ 400";
     NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, str.length - 4)];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(4, str.length - 4)];
    dingJinLabel.attributedText = string;
    
    
    
    UILabel *allLabel = [[UILabel alloc]init];
    allLabel.font = [UIFont systemFontOfSize:15];
    allLabel.textColor = wordColorDark;
    allLabel.text = @"总价:¥ 2000";
    allLabel.textAlignment = NSTextAlignmentRight;
    [_bottomView addSubview:allLabel];
    allLabel.sd_layout
    .rightSpaceToView(button,10)
    .topSpaceToView(dingJinLabel,-5)
    .widthIs(200)
    .heightIs(30);
    
    
    
}
#pragma mark - 加入车队
- (void)joinTheTeam{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_productGroupModel._id forKey:@"group_id"];
    [param setObject:@"0" forKey:@"is_sure"];
    
    [_downLoad POST:@"cartAddGroup" param:param success:^(NSDictionary *dic) {
        
<<<<<<< HEAD
//        NSLog(@"%@",dic);
        
=======
>>>>>>> 0fda384059193aa1e59d2a4cb7b34788af50ae85
        NSInteger status = [dic[@"status"] integerValue];
        if (status == -2) {
            [param setObject:@"1" forKey:@"is_sure"];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否覆盖头车" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"       取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [_downLoad POST:@"cartAddGroup" param:param success:^(NSDictionary *dic) {
                    //修改车队数量
                    NSString *cart_numStr = [NSString stringWithFormat:@"%@",dic[@"return"][@"cart_num"]];
                    NSInteger cartTotal = [cart_numStr integerValue];
                    _carView.numberLable.text = [NSString stringWithFormat:@"%ld",(long)cartTotal];
                    //保存车队数量
                    [[NSUserDefaults standardUserDefaults]setObject:cart_numStr forKey:HCJDCart_num];
                    
                    //修改成功提示
                    UIAlertView *OK = [[UIAlertView alloc]initWithTitle:@"修改成功" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [OK show];
                    
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


































