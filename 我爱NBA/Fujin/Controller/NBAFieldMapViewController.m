//
//  NBAFieldMapViewController.m
//  我爱NBA
//
//  Created by philipyu on 15/12/22.
//  Copyright © 2015年 com.philipyu. All rights reserved.
//

#import "NBAFieldMapViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
#import "NBAFieldTableModel.h"
#import "NBAConst.h"
#import <MapKit/MapKit.h>

//#import "MAMapURLSearchConfig.h"



@interface NBAFieldMapViewController ()<MAMapViewDelegate>
@property (nonatomic,strong) MAMapView *mapview;
@property (nonatomic,strong) AMapSearchAPI *search;
//@property (nonatomic,strong) id <MAAnnotation> annotation;
@end

@implementation NBAFieldMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置导航栏
    [self setupNav];
    
    //开启高德地图
    [MAMapServices sharedServices].apiKey = kAmapAPIKey;

    CGRect mapRect = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
    self.mapview = [[MAMapView alloc]initWithFrame:mapRect];
    [self.view addSubview:self.mapview];
    
    CLLocationDegrees latitude = (CLLocationDegrees)self.fieldModel.location.latitude;
    CLLocationDegrees longtitude = (CLLocationDegrees)self.fieldModel.location.longitude;
    
    self.mapview.centerCoordinate = CLLocationCoordinate2DMake(latitude, longtitude);
    self.mapview.mapType = MKMapTypeStandard;
    [self.mapview setZoomLevel:12 animated:YES];
    self.mapview.delegate = self;
    
    //开启定位
    self.mapview.showsUserLocation = YES;
//    self.mapview.userTrackingMode = MKUserTrackingModeFollow;
    
    MAPointAnnotation *position = [[MAPointAnnotation alloc]init];
    position.coordinate = self.mapview.centerCoordinate;
    position.title = self.fieldModel.name;
    position.subtitle = self.fieldModel.address;
    
    [self.mapview addAnnotation:position];
    
    
    
    [AMapSearchServices sharedServices].apiKey = kAmapAPIKey;
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
}

-(void)setupNav
{
    
    //标题
    self.title = self.fieldModel.name;
    
    //左上角
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"icon_back" highlightimage:@"icon_back_highlighted"];
    
    //右上角
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(naviToAmapRoute) image:@"navi" highlightimage:@"navi"];

}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

//唤起高德app导航，默认是公交车导航
-(void)naviToAmapRoute
{
    //配置导航参数
    MARouteConfig * config = [[MARouteConfig alloc] init];
    config.startCoordinate = _mapview.userLocation.location.coordinate;
    config.destinationCoordinate = CLLocationCoordinate2DMake((CLLocationDegrees)self.fieldModel.location.latitude, (CLLocationDegrees)self.fieldModel.location.longitude);//终点坐标，Annotation的坐标
    config.appScheme = [self getApplicationScheme];//返回的Scheme，需手动设置
    config.appName = [self getApplicationName];//应用名称，需手动设置
    config.routeType = MARouteSearchTypeTransit;
    config.transitStrategy = MATransitStrategyFastest;
    if (![MAMapURLSearch openAMapRouteSearch:config])
    {
        [MAMapURLSearch getLatestAMapApp];
    };
    
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
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

-(void)mapView:(MAMapView *)mapView didAnnotationViewCalloutTapped:(MAAnnotationView *)view
{
//    NBALog(@"mapView didAnnotationViewCalloutTapped-------");
    
    //调起高德地图，启动导航
    if ([view.annotation isKindOfClass:[MAPointAnnotation class]])
    {
        //配置导航参数
        MANaviConfig * config = [[MANaviConfig alloc] init];
        config.destination = view.annotation.coordinate;//终点坐标，Annotation的坐标
        config.appScheme = [self getApplicationScheme];//返回的Scheme，需手动设置
        config.appName = [self getApplicationName];//应用名称，需手动设置
        config.strategy = MADrivingStrategyShortest;
//        若未调起高德地图App,引导用户获取最新版本的
        if(![MAMapURLSearch openAMapNavigation:config])
        {
            [MAMapURLSearch getLatestAMapApp];
        }
    }
}

- (NSString *)getApplicationName
{
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    return [bundleInfo valueForKey:@"CFBundleDisplayName"];
}

- (NSString *)getApplicationScheme
{
    NSDictionary *bundleInfo    = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleIdentifier  = [[NSBundle mainBundle] bundleIdentifier];
    NSArray *URLTypes           = [bundleInfo valueForKey:@"CFBundleURLTypes"];
    
    NSString *scheme;
//    for (NSDictionary *dic in URLTypes)
    {
        NSString *URLName = [URLTypes[2] valueForKey:@"CFBundleURLName"];
        if ([URLName isEqualToString:bundleIdentifier])
        {
            scheme = [[URLTypes[2] valueForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
//            break;
        }
    }
    
    return scheme;
}
@end
