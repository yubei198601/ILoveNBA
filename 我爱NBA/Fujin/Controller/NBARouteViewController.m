//
//  NBARouteViewController.m
//  我爱NBA
//
//  Created by philipyu on 15/12/18.
//  Copyright © 2015年 com.philipyu. All rights reserved.
//

#import "NBARouteViewController.h"
#import "NBAConst.h"
#import <AMapSearchKit/AMapSearchKit.h>


@interface NBARouteViewController ()<AMapSearchDelegate>
@property (nonatomic,strong) AMapSearchAPI *search;
@end

@implementation NBARouteViewController


-(void)viewDidLoad
{
    //配置用户Key
    [AMapSearchServices sharedServices].apiKey = kAmapAPIKey;
    
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    //构造AMapDrivingRouteSearchRequest对象，设置驾车路径规划请求参数
    AMapDrivingRouteSearchRequest *request = [[AMapDrivingRouteSearchRequest alloc] init];
    request.origin = [AMapGeoPoint locationWithLatitude:39.994949 longitude:116.447265];
    request.destination = [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.481476];
    request.strategy = 2;//距离优先
    request.requireExtension = YES;
    
    //发起路径搜索
    [_search AMapDrivingRouteSearch: request];
}

//实现路径搜索的回调函数
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if(response.route == nil)
    {
        return;
    }
    
    //通过AMapNavigationSearchResponse对象处理搜索结果
    NSString *route = [NSString stringWithFormat:@"Navi: %@", response.route];
    NSLog(@"%@", route);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
