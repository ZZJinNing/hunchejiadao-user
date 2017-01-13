//
//  HomeDetailViewController.m
//  HCJD-User
//
//  Created by jiang on 16/12/30.
//  Copyright © 2016年 JinNing. All rights reserved.
//

#import "HomeDetailViewController.h"
#import "CarCollectionView.h"
#import "MyTeamViewController.h"


@interface HomeDetailViewController ()<UIWebViewDelegate>
{
    UIScrollView *_scrollView;
    UIWebView *_webView;
    //总高度
    float _allHeight;
    //上部高度
    float _topHeight;
    
    //标记点赞收藏的标志
    NSString *_shoucang;
    //收藏按钮
    UIImageView *_collectionImageView;
    //订单
    UILabel *_numberLabel;
    //订单数量
    NSInteger _number;
}
@end

@implementation HomeDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"套餐详情";
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-124)];
    _scrollView.backgroundColor = grayBG;
    [self.view addSubview:_scrollView];
   
    
    //头部视图
    [self topView];
    //加载webView
    [self loadWebView];
    //尾部视图
    [self belowView];
    
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
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/3*2)];
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"a"];
    [view addSubview:imageView];
    
    
    //============客服================
    UIView *keFuView = [[UIView alloc]init];
    keFuView.backgroundColor = kRGBA(138, 110, 109,0.5);
    keFuView.layer.masksToBounds = YES;
    keFuView.layer.cornerRadius = 22;
    [imageView addSubview:keFuView];
    keFuView.sd_layout
    .rightSpaceToView(imageView,10)
    .topSpaceToView(imageView,10)
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
    [imageView addSubview:collectionView];
    collectionView.sd_layout
    .rightSpaceToView(keFuView,15)
    .topSpaceToView(imageView,10)
    .widthIs(44)
    .heightIs(44);

    //给点赞收藏添加点击事件
    UITapGestureRecognizer * collectiontgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandlecollection)];
    _shoucang = @"cancel";
    [collectionView addGestureRecognizer:collectiontgr];
    
    _collectionImageView = [[UIImageView alloc]init];
    _collectionImageView.image = [UIImage imageNamed:@"icon_home_zixc"];
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

//==========客服按钮==============
- (void)tapHandlekeFu{
    
}
//==========点赞按钮===============
- (void)tapHandlecollection{
    if ([_shoucang isEqualToString:@"cancel"]) {
        _shoucang = @"collection";
        _collectionImageView.image = [UIImage imageNamed:@"iconRed"];
    }else if ([_shoucang isEqualToString:@"collection"]){
        _collectionImageView.image = [UIImage imageNamed:@"icon_home_zixc"];
        _shoucang = @"cancel";
    }
    
    
}
//================介绍详情===============
- (void)createDetailView:(UIView*)view{
    NSArray *array = @[@"奥迪A6L白色",@"优惠价:¥400",@"市场价:¥800"];
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
    depositLabel.text = @"定金:¥400";
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

//=============加=================
- (void)addButton{
    _number++;
    _numberLabel.text = [NSString stringWithFormat:@"%ld",_number];
}
- (void)jianButton{
    _number--;
    if (_number <= 0) {
        return;
    }
    _numberLabel.text = [NSString stringWithFormat:@"%ld",_number];
}

#pragma mark - 加载webView
- (void)loadWebView{
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, _topHeight + 5, kScreenWidth, kScreenHeight)];
    NSMutableString *URL = [NSMutableString stringWithFormat:@"%@",@"https://www.baidu.com"];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    _webView.delegate = self;
    [_scrollView addSubview: _webView];
    [_webView loadRequest:request];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _webView.frame = CGRectMake(0, _topHeight + 10, kScreenWidth, _webView.scrollView.contentSize.height);
    float h = _webView.scrollView.contentSize.height;
    _allHeight = h + _topHeight + 10;
    _scrollView.contentSize = CGSizeMake(kScreenWidth, _allHeight);
}



#pragma mark - 最下边的view
- (void)belowView{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 124, kScreenWidth, 60)];
    bgView.backgroundColor = grayBG;
    [self.view addSubview:bgView];
    
    
    
    CarCollectionView *carView = [[CarCollectionView alloc]initWithFrame:CGRectMake(0, 0, 80, 60) withNumber:1];
    [bgView addSubview:carView];
    //添加点击事件
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handle)];
    [carView addGestureRecognizer:tgr];
 
   
    //===========加入车队按钮==================
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(bgView.bounds.size.width - 100, 0, 100, 60);
    [button setTitle:@"加入车队" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(joinTheTeam) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = kRGBA(249, 30, 51, 1);
    [bgView addSubview:button];
    
    
    //============定金  总价======================
    UILabel *dingJinLabel = [[UILabel alloc]init];
    dingJinLabel.font = [UIFont systemFontOfSize:15];
    dingJinLabel.textAlignment = NSTextAlignmentRight;
    dingJinLabel.textColor = wordColorDark;
    [bgView addSubview:dingJinLabel];
    dingJinLabel.sd_layout
    .rightSpaceToView(button,10)
    .topSpaceToView(bgView,5)
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
    [bgView addSubview:allLabel];
    allLabel.sd_layout
    .rightSpaceToView(button,10)
    .topSpaceToView(dingJinLabel,-5)
    .widthIs(200)
    .heightIs(30);
    
    
    
}
//=====加入车队按钮==============================
- (void)joinTheTeam{
    
    
}
//==========点击车的按钮================
- (void)handle{
    MyTeamViewController *vc = [[MyTeamViewController alloc]init];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
   
}

@end


































