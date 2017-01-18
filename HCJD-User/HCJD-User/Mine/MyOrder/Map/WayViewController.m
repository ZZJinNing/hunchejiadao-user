//
//  WayViewController.m
//  HCJD-User
//
//  Created by ZhangZi Long on 17/1/17.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import "WayViewController.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface WayViewController ()<MAMapViewDelegate,AMapLocationManagerDelegate>
{
    NSMutableArray *_annotationsArray;
    MAPointAnnotation *_annotationQi;
    MAPointAnnotation *_annotationZ;
    MAPointAnnotation *_annotationEnd;
}


@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic)AMapLocationManager *locationManager;

@end

@implementation WayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"路线详情";
    
    _annotationsArray = [[NSMutableArray alloc]init];
    
    //初始化地图
    [self createMApView];
    
    [self initAnnotation];
    [self createCommonPolyLine];
    
}


- (void)initAnnotation{
    CLLocationCoordinate2D coordinates[3] ={
        {[_begin_lat doubleValue], [_begin_lng doubleValue]},
        {[_way_lat doubleValue], [_way_lng doubleValue]},
        {[_end_lat doubleValue], [_end_lng doubleValue]}
    };
    
    _annotationQi = [[MAPointAnnotation alloc] init];
    _annotationQi.title = @"起点";
    _annotationQi.coordinate = coordinates[0];
    [_annotationsArray addObject:_annotationQi];
    
    
    _annotationZ = [[MAPointAnnotation alloc] init];
    _annotationZ.title = @"途径";
    _annotationZ.coordinate = coordinates[1];
    [_annotationsArray addObject:_annotationZ];
    
    
    _annotationEnd = [[MAPointAnnotation alloc] init];
    _annotationEnd.title = @"结束";
    _annotationEnd.coordinate = coordinates[2];
    [_annotationsArray addObject:_annotationEnd];
    
    
    
}

//初始化大头针
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_mapView addAnnotations:_annotationsArray];
    [_mapView showAnnotations:_annotationsArray animated:YES];
}


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        if (annotation == _annotationQi) {
            annotationView.image = [UIImage imageNamed:@"image-start"];
        }else if (annotation == _annotationZ){
            annotationView.image = [UIImage imageNamed:@"image-zhong"];
        }else if (annotation == _annotationEnd){
            annotationView.image = [UIImage imageNamed:@"image-end"];
        }
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}


//初始化地图
- (void)createMApView{
    
    self.mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT)];
    //设置地图的类型
    [self.mapView setMapType:MAMapTypeStandard];
    self.mapView.delegate = self;
    //YES 为打开定位，NO为关闭定位
    _mapView.showsUserLocation = YES;
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
    [_mapView setZoomLevel:15];
    //显示实时路况
    self.mapView.showTraffic = YES;
    //缩放手势开启
    _mapView.zoomEnabled = YES;
    //滑动手势开启
    _mapView.scrollEnabled = YES;
    //地图平移时，缩放级别不变，可通过改变地图的中心点来移动地图
    //    [_mapView setCenterCoordinate:center animated:YES];
    //即便你的app退到后台，且位置不变动时，也不会被系统挂起，可持久记录位置信息
    _mapView.pausesLocationUpdatesAutomatically = NO;
//    _mapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配
    [self.view addSubview:self.mapView];
    
    
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    //   定位超时时间，最低2s，此处设置为10s
    self.locationManager.locationTimeout = 10;
    //   逆地理请求超时时间，最低2s，此处设置为10s
    self.locationManager.reGeocodeTimeout = 10;
    
    
}


- (void)createCommonPolyLine{
    //构造折线数据对象
    CLLocationCoordinate2D commonPolylineCoords[4];
    commonPolylineCoords[0].latitude = [_begin_lat doubleValue];
    commonPolylineCoords[0].longitude = [_begin_lng doubleValue];
    
    commonPolylineCoords[1].latitude = [_way_lat doubleValue];
    commonPolylineCoords[1].longitude = [_way_lng doubleValue];
    
    commonPolylineCoords[2].latitude = [_end_lat doubleValue];
    commonPolylineCoords[2].longitude = [_end_lng doubleValue];
    
    
    //构造折线对象
    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:3];
    
    //在地图上添加折线对象
    [_mapView addOverlay: commonPolyline];
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 5.f;
        polylineRenderer.strokeColor  = [UIColor redColor];
//        polylineRenderer.lineJoinType = kMALineJoinRound;
//        polylineRenderer.lineCapType  = kMALineCapRound;
        
        return polylineRenderer;
    }
    
    return nil;
}

@end
