//
//  mapViewController.m
//  HCJD-User
//
//  Created by jiang on 17/1/4.
//  Copyright © 2017年 JinNing. All rights reserved.
//

#import "mapViewController.h"
#import "AMapTipAnnotation.h"
#import "ErrorInfoUtility.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MapKit/MapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "SearchMapViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
@interface mapViewController ()<MAMapViewDelegate,AMapLocationManagerDelegate>
{
    //新郎家button
    UIButton *_groomBtn;
    //新娘家
    UIButton *_brideBtn;
    //终点
    UIButton *_endBtn;
    AMapLocationManager *_locationManager;
}


@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation mapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"路线详情";
    
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.mapView];
    
    
    //布局界面
    [self setUpUI];
    
}

#pragma mark - 布局
- (void)setUpUI{
    
    NSArray *topArray = @[@"出发地点[新郎家里?]",@"途径地点[新娘家里?]",@"终点地点[婚宴礼堂?]"];
    
    for (int i = 0; i < 3; i++) {
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(15, 20+120*i, kScreenWidth - 30, 100)];
        whiteView.backgroundColor = kRGB(250, 250, 250);
        whiteView.layer.cornerRadius = 5;
        whiteView.layer.masksToBounds = YES;
        whiteView.layer.borderWidth= 1.0;
        whiteView.layer.borderColor= [[UIColor lightGrayColor] CGColor];
        [self.view addSubview:whiteView];
        
        
        //设置分割线
        float width = whiteView.bounds.size.width;
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, width, 1)];
        lineLabel.backgroundColor = LineColor;
        [whiteView addSubview:lineLabel];
        
        //======出发地点label============
        UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 250, 50)];
        topLabel.text = topArray[i];
        topLabel.textColor = wordColorDark;
        [whiteView addSubview:topLabel];
        //==============城市label===
        UILabel *cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 50, 60, 50)];
        cityLabel.textColor = wordColorDark;
        cityLabel.text = @"郑州市";
        [whiteView addSubview:cityLabel];
        
        //=============选着button================
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(100, 50, width - 120, 50);
        if (i == 0) {
            _groomBtn = button;
        }else if (i == 1){
            _brideBtn = button;
        }else if (i == 2){
            _endBtn = button;
        }
        [button setTitle:@"请填写地址" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button addTarget:self action:@selector(selectPlace:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:button];
        
    }
}

- (void)selectPlace:(UIButton*)button{
    SearchMapViewController *vc = [[SearchMapViewController alloc]init];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    if (_groomBtn == button) {
        vc.MyBlock = ^(NSDictionary *dic){
            NSString *address = dic[@"addressName"];
            [_groomBtn setTitle:address forState:UIControlStateNormal];
            [_groomBtn setTitleColor:wordColorDark forState:UIControlStateNormal];
            NSString *latitude = dic[@"latitude"];
            NSString *longitude = dic[@"longitude"];
            [self clearAndShowAnnotationWithlatitude:latitude withlongitude:longitude withAddress:address];
        };
    }else if (_brideBtn == button){
        vc.MyBlock = ^(NSDictionary *dic){
            NSString *address = dic[@"addressName"];
            [_brideBtn setTitle:address forState:UIControlStateNormal];
            [_brideBtn setTitleColor:wordColorDark forState:UIControlStateNormal];
            NSString *latitude = dic[@"latitude"];
            NSString *longitude = dic[@"longitude"];
            [self clearAndShowAnnotationWithlatitude:latitude withlongitude:longitude withAddress:address];
        };
    }else if (_endBtn == button){
        vc.MyBlock = ^(NSDictionary *dic){
            NSString *address = dic[@"addressName"];
            [_endBtn setTitle:address forState:UIControlStateNormal];
            [_endBtn setTitleColor:wordColorDark forState:UIControlStateNormal];
            NSString *latitude = dic[@"latitude"];
            NSString *longitude = dic[@"longitude"];
            [self clearAndShowAnnotationWithlatitude:latitude withlongitude:longitude withAddress:address];
        };
    }
  
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)clearAndShowAnnotationWithlatitude:(NSString*)latitude withlongitude:(NSString*)longitude withAddress:(NSString*)address{
    [self.mapView removeAnnotations:self.mapView.annotations];
     MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    float lat = [latitude floatValue];
    float lon = [longitude floatValue];
    CLLocationCoordinate2D coordinates[1] ={
        {lat, lon}
    };
    NSMutableArray *array = [[NSMutableArray alloc]init];
    pointAnnotation.title = address;
    pointAnnotation.coordinate = coordinates[0];
    [array addObject:pointAnnotation];
    [_mapView addAnnotations:array];
    [_mapView showAnnotations:array animated:YES];
    
    //设置地图的类型
    [self.mapView setMapType:MAMapTypeStandard];
    self.mapView.delegate = self;
    
    
    _locationManager = [[AMapLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    //   定位超时时间，最低2s，此处设置为10s
    _locationManager.locationTimeout = 10;
    //   逆地理请求超时时间，最低2s，此处设置为10s
    _locationManager.reGeocodeTimeout = 10;
}


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
         
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        
        return annotationView;
    }
    return nil;
}


@end
























