//
//  SearchMapViewController.m
//  HCJD-User
//
//  Created by jiang on 17/1/5.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import "SearchMapViewController.h"
#import "ErrorInfoUtility.h"
#import "AMapTipAnnotation.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MapKit/MapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

#define TipPlaceHolder @"名称"
#define BusLinePaddingEdge 20

@interface SearchMapViewController ()<MAMapViewDelegate, AMapSearchDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) UITextField *textField;

//数据源
@property (nonatomic, strong) NSMutableArray *tips;

@end

@implementation SearchMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    //自定制的导航栏
    [self navigationBarView];
    [self initTableView];

}

//导航栏
- (void)navigationBarView{
    UIView *View = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    View.backgroundColor = kRGBA(249, 30, 51, 1);
    [self.view addSubview:View];
    
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(50, 25, kScreenWidth - 100, 40)];
    _textField.placeholder = @"请输入搜索内容";
    _textField.textColor = [UIColor whiteColor];
    [_textField setValue:kRGB(240, 240, 240) forKeyPath:@"_placeholderLabel.textColor"];
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    [_textField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [View addSubview:_textField];
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(BackButton) forControlEvents:UIControlEventTouchUpInside];
    [View addSubview:backBtn];
    backBtn.sd_layout
    .centerYEqualToView(_textField)
    .leftSpaceToView(View,5)
    .rightSpaceToView(_textField,5)
    .heightIs(30);
    
    //右侧搜索
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"icon_search"];
    [View addSubview:imageView];
    imageView.sd_layout
    .leftSpaceToView(_textField,5)
    .centerYEqualToView(_textField)
    .widthIs(25)
    .heightIs(28);
    
}

#pragma mark - 返回按钮
- (void)BackButton{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)textFieldChange:(UITextField*)textField{
   
    [self searchTipsWithKey:textField.text];
    if (textField.text.length <= 0) {
        [_tips removeAllObjects];
        [_tableView reloadData];
    }
}

- (id)init
{
    if (self = [super init])
    {
        self.tips = [NSMutableArray array];
        
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - Utility

/* 输入提示 搜索.*/
- (void)searchTipsWithKey:(NSString *)key
{
    if (key.length == 0)
    {
        return;
    }
    
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = key;
    tips.city     = @"郑州";
    [self.search AMapInputTipsSearch:tips];
}

/* 清除annotations & overlays */
- (void)clear
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
}

- (void)clearAndShowAnnotationWithTip:(AMapTip *)tip
{
    /* 清除annotations & overlays */
    [self clear];
    
    if (tip.uid != nil && tip.location != nil) /* 可以直接在地图打点  */
    {
        AMapTipAnnotation *annotation = [[AMapTipAnnotation alloc] initWithMapTip:tip];
        [self.mapView addAnnotation:annotation];
        [self.mapView setCenterCoordinate:annotation.coordinate];
        [self.mapView selectAnnotation:annotation animated:YES];
    }
    
    else if(tip.uid == nil && tip.location == nil)/* 品牌名，进行POI关键字搜索 */
    {
        AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
        
        request.keywords         = tip.name;
        request.city             = @"郑州";
        request.requireExtension = YES;
        [self.search AMapPOIKeywordsSearch:request];
    }
}


#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[AMapTipAnnotation class]])
    {
        static NSString *tipIdentifier = @"tipIdentifier";
        
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:tipIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:tipIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return poiAnnotationView;
    }
    
    
    return nil;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth   = 4.f;
        polylineRenderer.strokeColor = [UIColor magentaColor];
        
        return polylineRenderer;
    }
    
    return nil;
}

#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@ - %@", error, [ErrorInfoUtility errorDescriptionWithCode:error.code]);
}

/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    if (response.count == 0)
    {
        return;
    }
    
    [self.tips setArray:response.tips];
    [self.tableView reloadData];
    
}



/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    if (response.pois.count == 0)
    {
        return;
    }
    
    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
    
    /* 将结果以annotation的形式加载到地图上. */
    [self.mapView addAnnotations:poiAnnotations];
    
    /* 如果只有一个结果，设置其为中心点. */
    if (poiAnnotations.count == 1)
    {
        [self.mapView setCenterCoordinate:[poiAnnotations[0] coordinate]];
    }
    /* 如果有多个结果, 设置地图使所有的annotation都可见. */
    else
    {
        [self.mapView showAnnotations:poiAnnotations animated:NO];
    }
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tips.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tipCellIdentifier = @"tipCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tipCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:tipCellIdentifier];
        cell.imageView.image = [UIImage imageNamed:@"locate"];
    }
    
    AMapTip *tip = self.tips[indexPath.row];
    
    if (tip.location == nil)
    {
        cell.imageView.image = [UIImage imageNamed:@"search"];
    }
    
    cell.textLabel.text = tip.name;
    cell.detailTextLabel.text = tip.address;
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMapTip *mapTip = self.tips[indexPath.row];
    [self clearAndShowAnnotationWithTip:mapTip];
    
    NSString *latitude = [NSString stringWithFormat:@"%f",mapTip.location.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",mapTip.location.longitude];
    NSString *addressName = mapTip.name;
    
    NSDictionary *dic = @{@"latitude":latitude,@"longitude":longitude,@"addressName":addressName};

   
    if (self.MyBlock != nil) {
         self.MyBlock(dic);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)chuanZhi:(NewBlock)block{
    self.MyBlock = block;
}

#pragma mark - Initialization

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 74, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}





@end
