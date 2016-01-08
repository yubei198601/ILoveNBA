//
//  NBAMapViewController.m
//  我爱NBA
//
//  Created by philipyu on 15/12/16.
//  Copyright © 2015年 com.philipyu. All rights reserved.
//

#import "NBAMapViewController.h"
#import "Masonry.h"
#import <MAMapKit/MAMapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "NBAConst.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "NBAAnnotationModel.h"
#import "NBAIconAnnotation.h"
#import "NBAIconAnnotationView.h"
#import "NBADescAnnotation.h"
#import "NBAdescAnnotationView.h"
#import "NBARouteViewController.h"
#import "NBAFieldTableModel.h"

#define kNBAMapBtnWH    35
#define kNBAMapMargin   20


@interface NBAMapViewController ()<MAMapViewDelegate,AMapSearchDelegate>
//地图的view
@property (nonatomic,strong) MAMapView *mapView;
//搜索周边对象
@property (nonatomic,strong) AMapSearchAPI *mapSearch;
//记录用户的位置
@property (nonatomic,strong) MAUserLocation *userLocation;
//记录兴趣点查询到的数据
@property (nonatomic,strong) NSMutableArray *annotationModels;
//城市
@property (nonatomic,copy) NSString *city;
//
@property (nonatomic,strong) NBAdescAnnotationView *descAnno;
@end

@implementation NBAMapViewController
//懒加载
-(NSMutableArray*)annotationModels
{
    if (_annotationModels== nil) {
        self.annotationModels = [NSMutableArray array];
    }
    return _annotationModels;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.navigationController.tabBarController.tabBar setHidden:YES];
    
    //配置用户Key
    [MAMapServices sharedServices].apiKey = kAmapAPIKey;
    
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView];
    
    //1.隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //2.添加用户按钮
    //2.1添加返回按钮
    [self btnWithImage:@"icon_back.png" target:self action:@selector(back) constrainframe:CGRectMake(kNBAMapBtnWH, kNBAMapMargin, kNBAMapBtnWH, kNBAMapBtnWH) horizon:YES vertical:YES] ;
    //2.2添加回到用户所在的位置的按钮
    [self btnWithImage:@"userPosition.png" target:self action:@selector(returnToMyPosition) constrainframe:CGRectMake(-5, kNBAMapMargin, kNBAMapBtnWH, kNBAMapBtnWH) horizon:YES vertical:NO];
    //2.3添加放大按钮
    [self btnWithImage:@"greenPin.png" target:self action:@selector(zoomIn) constrainframe:CGRectMake(-6-kNBAMapBtnWH, -kNBAMapMargin, kNBAMapBtnWH, kNBAMapBtnWH) horizon:NO vertical:NO];
    //2.4添加缩小按
    [self btnWithImage:@"redPin.png" target:self action:@selector(zoomIn) constrainframe:CGRectMake(-5, -kNBAMapMargin, kNBAMapBtnWH, kNBAMapBtnWH) horizon:NO vertical:NO];

    //3.开启定位
    self.mapView.showsUserLocation = YES;
//    NBALog(@"%@ start-----",[NSDate date]);
    //4.设置跟踪用户移动的位置模式
    [self.mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];
    
    //5.放大倍数
    /*scaleOrigin  这个属性只是改变比例尺的初始坐标*/
//    self.mapView.scaleOrigin = CGPointMake(self.view.bounds.size.width/2,self.view.bounds.size.height/2);

   /*最大的放大倍数为20，最小为1.149*/
//   NBALog(@"min = %f max=%f", self.mapView.minZoomLevel,self.mapView.maxZoomLevel);
    CGPoint pivot = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    [self.mapView setZoomLevel:13 atPivot:pivot animated:YES];
//    比例为12时，大概每一个点的距离为29米
//    CGFloat meter = [self.mapView metersPerPointForCurrentZoomLevel];
//    NBALog(@"meter = %f",meter);
    
    //添加大头针
    for (NBAFieldTableModel *amodel in self.fieldModels)
    {
        NBAAnnotationModel *annomodel = [[NBAAnnotationModel alloc]init];
        NBAIconAnnotation *iconAnnotation = [[NBAIconAnnotation alloc]init];
        annomodel.name = amodel.name;
        annomodel.phone = amodel.tel;
        annomodel.address = amodel.address;
        annomodel.Coordinate = CLLocationCoordinate2DMake((CLLocationDegrees)amodel.location.latitude, (CLLocationDegrees)amodel.location.longitude);
        iconAnnotation.anno = annomodel;
        iconAnnotation.coordinate = annomodel.Coordinate;
        [self.annotationModels addObject:iconAnnotation];
    }
    
}
-(void)btnWithImage:(NSString*)image target:(nonnull id)target action:(nonnull SEL)action constrainframe
                   :(CGRect)rect horizon:(BOOL)isLeft vertical:(bool)isTop
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor blackColor];
    btn.alpha = 0.3;
    btn.layer.cornerRadius = 4.0;
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make)
    {
        if(isLeft)
            make.left.equalTo(self.view.mas_left).offset(rect.origin.y);
        else
            make.right.equalTo(self.view.mas_right).offset(rect.origin.y);
        
        if (isTop)
            make.top.equalTo(self.view.mas_top).offset(rect.origin.x);
        else
            make.bottom.equalTo(self.view.mas_bottom).offset(rect.origin.x);
        
        
        make.height.equalTo(@(rect.size.height));
        make.width.equalTo(@(rect.size.width));
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

-(void)zoomIn
{
    self.mapView.zoomLevel += 1;
    if (self.mapView.zoomLevel > self.mapView.maxZoomLevel) {
        self.mapView.zoomLevel -= 1;
    }
}


-(void)zoomOut
{
    self.mapView.zoomLevel -= 1;
    if (self.mapView.zoomLevel < self.mapView.minZoomLevel) {
        self.mapView.zoomLevel += 1;
    }
}

//back to previous menu
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)returnToMyPosition
{
    self.mapView.centerCoordinate = self.userLocation.coordinate;
}

//-(void)searchBasketball
//{
//    //配置用户Key
//    [AMapSearchServices sharedServices].apiKey = kAmapAPIKey;
//    
//    //初始化检索对象
//    _mapSearch = [[AMapSearchAPI alloc] init];
//    _mapSearch.delegate = self;
//    
//    //反地理编码获取城市信息
//    [self reGeoCoder];
//
//}

//-(void)reGeoCoder
//{
//    AMapReGeocodeSearchRequest *geoRequest = [[AMapReGeocodeSearchRequest alloc]init];
//    geoRequest.location = [AMapGeoPoint locationWithLatitude:_mapView.centerCoordinate.latitude longitude:_mapView.centerCoordinate.longitude];
//    geoRequest.requireExtension = YES;
//    geoRequest.radius = 1500;
//    [_mapSearch AMapReGoecodeSearch: geoRequest];
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
////实现逆地理编码的回调函数
//- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
//{
//    NBALog(@"onReGeocodeSearchDone");
//    if(response.regeocode != nil)
//    {
//        //通过AMapReGeocodeSearchResponse对象处理搜索结果
//        NSString *result = [NSString stringWithFormat:@"%@", response.regeocode];
////        NSLog(@"ReGeo: %@", result);
//        if (result.length) {
//            self.city = response.regeocode.addressComponent.city;
//        }
//        
//    }
//    
//    AMapPOIKeywordsSearchRequest *keywordrequest = [[AMapPOIKeywordsSearchRequest alloc]init];
//    {
//        keywordrequest.city = self.city;
//    }
//    
//    keywordrequest.keywords = @"篮球";
//    // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
//    // POI的类型共分为20种大类别，分别为：
//    // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
//    // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
//    // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
//    keywordrequest.types = @"体育休闲服务";
//    keywordrequest.sortrule = 0;
//    keywordrequest.requireExtension = YES;
//    //        NBALog(@"-----searchBasketball");
////    NBALog(@"searchBasketball");
//    //发起城市搜索
//    [_mapSearch AMapPOIKeywordsSearch:keywordrequest];
//}
#pragma mark - 地图定位代理方法
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    self.userLocation = userLocation;
    if(updatingLocation)
    {
        //取出当前位置的坐标
//        NBALog(@"%@-----end",[NSDate date]);
//        NBALog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}

//用户位置大头针
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
//    
//    UIImage *bigImage = [UIImage imageNamed:@"sucai.jpg"];
//    CGFloat iconW = 49;
//    CGFloat iconH = 49;
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.fillColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.3];
        pre.strokeColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:1.0];
//        CGRect smallRect = CGRectMake(143, 120, iconW, iconH);
//        CGImageRef smallimage = CGImageCreateWithImageInRect(bigImage.CGImage, smallRect);
        pre.image = [UIImage imageNamed:@"location.png"];
//        pre.image = [UIImage imageWithCGImage:smallimage];
        pre.lineWidth = 3;
        pre.lineDashPattern = @[@6, @3];
        [self.mapView updateUserLocationRepresentation:pre];
        view.calloutOffset = CGPointMake(0, 0);
    } 
}

#pragma mark-POI搜索
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if(response.pois.count == 0)
    {
        return;
    }
    
    //通过 AMapPOISearchResponse 对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %ld",response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
    NSString *strPoi = @"";
    for (AMapPOI *p in response.pois) {
        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@-%@-%@", strPoi, p.name,p.address,p.tel];
        NBAAnnotationModel *amodel = [[NBAAnnotationModel alloc]init];
        amodel.name = p.name;
        amodel.address = p.address;
        amodel.phone = p.tel;
        amodel.Coordinate = CLLocationCoordinate2DMake(p.location.latitude, p.location.longitude);
        NBAIconAnnotation *iconAnnotation = [[NBAIconAnnotation alloc]init];
        iconAnnotation.anno = amodel;
        iconAnnotation.coordinate = amodel.Coordinate;
        [self.annotationModels addObject:iconAnnotation];
        [_mapView addAnnotation:iconAnnotation];
    }
//    [_mapView addAnnotations:self.annotationModels];
    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
    NBALog(@"Place: %@", result);
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[NBAIconAnnotation class]])
    {
        NBAIconAnnotationView *annotationView = [NBAIconAnnotationView IconAnnotationViewWithMapview:mapView];
        annotationView.annotation = annotation;
//        NSLog(@"annotationView %.2f, %.2f", annotation.coordinate.longitude, annotation.coordinate.latitude);
        return annotationView;
    }
    else if ([annotation isKindOfClass:[NBADescAnnotation class]])
    {
        NBAdescAnnotationView *annotationView = [NBAdescAnnotationView descAnnotationViewWithMapview:mapView];
        annotationView.annotation = annotation;
        annotationView.enabled = YES;
        self.descAnno = annotationView;

        /*只对系统的偏移有效？？？*/
//        annotationView.calloutOffset = CGPointMake(0, 100);
//        NSLog(@"annotation %.2f, %.2f", annotation.coordinate.longitude, annotation.coordinate.latitude);
        return annotationView;
    }
    return nil;
}

-(void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    
    if ([view.annotation isKindOfClass:[NBAIconAnnotation class]])
    {

        //遍历大头针，将NBADescAnnotation类型的大头针移除
        NBAIconAnnotation *iconAnnotation = (NBAIconAnnotation *)view.annotation;
        NBALog(@"%@",_mapView.annotations);
        for (id annotation in _mapView.annotations)
        {
            if ([annotation isKindOfClass:[NBADescAnnotation class]]) {
                [_mapView removeAnnotation:annotation];
            }
        }
        
        NBADescAnnotation *descAnnotation = [[NBADescAnnotation alloc]init];
        descAnnotation.anno = iconAnnotation.anno;
        //必不可少，因为没有位置信息就不会响应
        descAnnotation.coordinate = iconAnnotation.anno.Coordinate;
        [_mapView addAnnotation:descAnnotation];
    }
//    else if([view.annotation isKindOfClass:[NBADescAnnotation class]])
//    {
//        //点击气泡
//        NBADescAnnotation *descAnnotation = view.annotation;
//        NBARouteViewController *vc = [[NBARouteViewController alloc]init];
//        vc.orignalCo = self.userLocation.coordinate;
//        vc.targetCo = descAnnotation.coordinate;
//        [self.navigationController pushViewController:vc animated:YES];
//    }

}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    for (NBAIconAnnotation *annotation in self.annotationModels)
    {
        //1.将annotation的经纬度点转成投影点
        MAMapPoint point = MAMapPointForCoordinate(annotation.coordinate);
        //2.判断该点是否在地图可视范围
        BOOL isContains = MAMapRectContainsPoint(_mapView.visibleMapRect, point);
        //3.如果在可见范围就添加大头针
        if(isContains)
        {
            [_mapView addAnnotation:annotation];
        }
    }
}
@end
