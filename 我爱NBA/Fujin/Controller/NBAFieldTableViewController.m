//
//  NBAFieldTableViewController.m
//  我爱NBA
//
//  Created by philipyu on 15/12/21.
//  Copyright © 2015年 com.philipyu. All rights reserved.
//

#import "NBAFieldTableViewController.h"
#import "NBAConst.h"
#import "NBAFieldButton.h"
#import "NBAFieldTableModel.h"
#import "NBAFieldTableCell.h"
#import "NBAChangeCitiesController.h"
#import "NBAFieldDetailViewController.h"
#import "NBAtitleView.h"
#import "NBASortZoneController.h"
#import "NBADropdownView.h"
#import "NBAMapViewController.h"
#import "NBACity.h"
#import "NBARegion.h"

//每页20条
#define kPAGECount   20
#define LeftBtn (self.navigationItem.leftBarButtonItem.customView)

typedef enum
{
    NBAFieldShowAll = 0,
    NBAFieldShowZone,
    NBAFieldShowOrder,
    NBAFieldShowDistance,
}NBAFieldShowCategroy;

@interface NBAFieldTableViewController ()<MAMapViewDelegate,AMapSearchDelegate,AMapLocationManagerDelegate>
//定位管理器
@property (nonatomic,strong) AMapLocationManager *localManager;
//用户的位置
@property (nonatomic,strong) CLLocation *Location;
//搜索api
@property (nonatomic,strong) AMapSearchAPI *search;
//定位到的城市
@property (nonatomic,copy) NSString *city;
//篮球场存储
@property (nonatomic,strong) NSMutableArray *fieldModels;
//当前的cell
@property (nonatomic,strong) NBAFieldTableCell *Cell;
//页数
@property (nonatomic,assign) NSInteger page;
//遮盖和弹出框
@property (nonatomic,strong) UIButton *cover;
@property (nonatomic,strong) NBADropdownView *popview;
//表格显示的场馆内容
@property (nonatomic,strong) NSMutableArray *fieldCategroyModels;
//表格显示的类型
@property (nonatomic,assign) NBAFieldShowCategroy currentCategory;
//区域文字
@property (nonatomic,copy) NSString *zoneString;

@end

@implementation NBAFieldTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //设置导航栏内容
    [self setupNav];
    
    //初始化表格加载类型
    self.currentCategory = NBAFieldShowAll;
    
    // 设置控件
    [self setupSubContrls];
    
    //定位用户的位置
    [AMapLocationServices sharedServices].apiKey = kAmapAPIKey;
    self.localManager = [[AMapLocationManager alloc] init];
    self.localManager.delegate = self;
    
    //设置定位精度为百米范围，这样可以有效节省定位时间（2-3秒）
    [self.localManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //起始页书为1
    self.page = 1;

    //配置用户搜索功能
    [AMapSearchServices sharedServices].apiKey = kAmapAPIKey;
    AMapSearchAPI *search = [[AMapSearchAPI alloc]init];
    self.search = search;
    self.search.delegate = self;

    
   //发送定位请求
        [self.localManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
        {
            if (error)
            {
                return;
            }
            NBALog(@"%@",regeocode);
            if (regeocode.city.length)
            {
                NSRange range = [regeocode.city rangeOfString:@"市"];
                regeocode.city = [regeocode.city substringToIndex:range.location];
            }
            self.city = regeocode.city;
            NBALog(@"%@",self.city);
            
            //取出导航栏左边的item按钮，将城市名字设进去
            NBAFieldButton *btn = (NBAFieldButton *)self.navigationItem.leftBarButtonItem.customView;
            [btn setTitle:self.city forState:UIControlStateNormal];

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                           , ^{
                               [self sendPIOSearch];
                           });
        }];
    

    
    //设置footview的view
    [self setFootview];
    
    //添加通知监听
    [NBANotificationCenter addObserver:self selector:@selector(zoneChange:) name:NBAChangeZoneNotification object:nil];
    
    [NBANotificationCenter addObserver:self selector:@selector(cityChange:) name:NBAChangeCityNotification object:nil];
    
    //数据加载中提示框
    [MBProgressHUD showMessage:@"数据加载中..."];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (self.navigationController.isNavigationBarHidden)
    {
        self.navigationController.navigationBarHidden = NO;
    }
    
    if (self.navigationController.tabBarController.tabBar.isHidden)
    {
        [self.navigationController.tabBarController.tabBar setHidden:NO];
    }
}

NSInteger intSort(NBAFieldTableModel *num1, NBAFieldTableModel *num2, void *context)
{
    double v1 = [num1.distance doubleValue];
    double v2 = [num2.distance doubleValue];
    if (v1 < v2)
        return NSOrderedAscending;
    else if (v1 > v2)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}

-(void)cityChange:(NSNotification*)notification
{
    NSString *city = notification.userInfo[NBACityName];
    NBAFieldButton *btn = (NBAFieldButton*)LeftBtn;
    self.city = city;
    
    //更新城市名
    [btn setTitle:self.city forState:UIControlStateNormal];
    //发送选中城市的PIO请求
    if (self.fieldModels.count)
    {
        [self.fieldModels removeAllObjects];
    }
    _currentCategory = NBAFieldShowAll;
    self.page = 1;
    [self.tableView.tableFooterView setHidden:YES];
    [self sendPIOSearch];
}

-(void)zoneChange:(NSNotification*)notification
{
    NBALog(@"zoneChange - zonename:%@",notification.userInfo[NBAZoneName]);
    
    //取得区域字符串
    self.zoneString = notification.userInfo[NBAZoneName];
    
    UIButton *btn = self.navigationItem.titleView.subviews.firstObject;
    
    //底部footview第一个子控件为button，第二个为提示“已经加载全部数据”的label
    if (![self.tableView.tableFooterView.subviews.lastObject isHidden])
    {
        [self.tableView.tableFooterView.subviews.lastObject setHidden:YES];
        [self.tableView.tableFooterView.subviews.firstObject setHidden:NO];
    }
    
    //全部分类
    if ([self.zoneString  isEqualToString: kAllSort])
    {
        self.page = 2;
        self.currentCategory = NBAFieldShowAll;
        [self exitSort];
        [btn setTitle:self.zoneString forState:UIControlStateNormal];
        [self.tableView reloadData];
        return;
    }
    //按照距离远近分类
    else if ([self.zoneString isEqualToString:kDistanceSort])
    {
        if(_fieldCategroyModels.count)
        {
            [_fieldCategroyModels removeAllObjects];
        }
        
        //启动定位
    [self.localManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        //定位失败
        if (error)
        {
            NBALog(@"定位出错");
            return;
        }
        
        for (NBAFieldTableModel *model in self.fieldModels)
        {
            //1.将两个经纬度点转成投影点
            MAMapPoint point1 = MAMapPointForCoordinate(location.coordinate);
            MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(model.location.latitude,model.location.longitude));
            //2.计算距离
            double distance =(double) MAMetersBetweenMapPoints(point1,point2);
//            distance
            //3.赋值距离存入模型
            model.distance = [NSNumber numberWithDouble:distance];
        }

        //分类
        NSArray *categorys = [self.fieldModels sortedArrayUsingFunction:intSort context:NULL hint:nil];
        for (NBAFieldTableModel *model in categorys)
        {
            [self.fieldCategroyModels addObject:model];
        }
        
        //隐藏显示
        [MBProgressHUD hideHUD];
        
        //更新标题文字
        self.page = 1;
        [btn setTitle:self.zoneString forState:UIControlStateNormal];
        self.currentCategory = NBAFieldShowDistance;
        [self.tableView reloadData];
        [self.tableView.tableFooterView setHidden:NO];
    }];
        //退出弹框
        [self exitSort];
        [MBProgressHUD showMessage:@"数据加载中"];
        [self.tableView.tableFooterView setHidden:YES];
        
        return;
    }
    //按照是否有电话提供预订排序
    else if([self.zoneString isEqualToString:kOrderSort])
    {
        //关闭遮盖和弹出框
        [self exitSort];
        
        //刷新列表
        if(_fieldCategroyModels.count)
        {
            [_fieldCategroyModels removeAllObjects];
        }
        
        for (NBAFieldTableModel *model in self.fieldModels)
        {
            if (model.tel.length)
            {
                [self.fieldCategroyModels addObject:model];
            }
        }
        self.page = 1;
        self.currentCategory = NBAFieldShowOrder;
        [self.tableView reloadData];
    }
    //按照城市的区域来分类
    else
    {
        //关闭遮盖和弹出框
        [self exitSort];

        //按照区域搜索（谓词过滤方式）
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"district contains %@",self.zoneString];
        NSArray *fieldCategroyModels = [self.fieldModels filteredArrayUsingPredicate:predicate];
        //如果指定的区有数据添加到分类数组，并设置为分区模式，刷新tabelview数据；否则返回，并告诉用户没有数据
        if (fieldCategroyModels.count)
        {
            //刷新列表
            if(_fieldCategroyModels.count)
            {
                [_fieldCategroyModels removeAllObjects];
            }
            [self.fieldCategroyModels addObjectsFromArray:fieldCategroyModels];
        }
        else
        {
            NBALog(@"本区域无数据");
            return;
        }
        
        NBALog(@"按照区域分类");
        self.page = 1;
        self.currentCategory = NBAFieldShowZone;
        [self.tableView reloadData];
    }
    [btn setTitle:self.zoneString forState:UIControlStateNormal];
}

-(void)dealloc
{
    //移除监听器
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark-set navigation bar
-(void)setupNav
{
    //设置顶部导航条为透明色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    //设置导航条title view显示的内容
    NBAtitleView *titleview = [NBAtitleView titleView];
    self.navigationItem.titleView = titleview;
    [titleview addTarget:self action:@selector(popZoneList) forControlEvents:UIControlEventTouchUpInside];

    //显示左边定位到的城市名字
    NBAFieldButton *leftBarBtn = [[NBAFieldButton alloc]init];
    leftBarBtn.frame = CGRectMake(0, 0, 90, 30);
    [leftBarBtn setImage:[UIImage imageNamed:@"btn_changeCity"] forState:UIControlStateNormal];
    [leftBarBtn addTarget:self action:@selector(changeCity) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarBtn];
    
    //设置右边的地图图标
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(jumpToMap) image:@"icon_map" highlightimage:@"icon_map_highlighted"];
}

/**跳转到地图*/
-(void)jumpToMap
{
    NBAMapViewController *mapVC = [[NBAMapViewController alloc]init];
    mapVC.fieldModels = self.fieldModels;
    [self.navigationController pushViewController:mapVC animated:YES];
}

/**切换城市*/
-(void)changeCity
{
    NBAChangeCitiesController *changeCitiesvc = [[NBAChangeCitiesController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:changeCitiesvc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

-(void)setupSubContrls
{
    //添加遮盖
    UIButton *cover = [[UIButton alloc]init];
    cover.origin = CGPointMake(0, 0);
    cover.size = CGSizeMake(kScreenWidth, kScreenHeight);
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.2;
    [self.navigationController.view addSubview:cover];
    self.cover = cover;
    [cover addTarget:self action:@selector(exitSort) forControlEvents:UIControlEventTouchUpInside];
    
    //添加弹出框
    NBADropdownView *popview = [NBADropdownView Dropdown];
    popview.x = 0;
    popview.y = 64;
    popview.backgroundColor = [UIColor whiteColor];
    [self.navigationController.view addSubview:popview];
    self.popview = popview;
    [self exitSort];
    
}

-(void)popZoneList
{
    NBALog(@"popZoneList===============");
    NSMutableArray *zones = [NSMutableArray array];
    NSArray *cities = [NBACity objectArrayWithFilename:@"cities.plist"];
    for (NBACity *city in cities)
    {
        if ([self.city isEqualToString:city.name])
        {
            [zones addObjectsFromArray: city.regions];
        }
    }
    
    self.popview.zones = zones;
    [self.cover setHidden:NO];
    [self.popview setHidden:NO];
    [self.popview refresh];
}

-(void)exitSort
{
    [self.cover setHidden:YES];
    [self.popview setHidden:YES];
}

#pragma mark-set foot view
-(void)setFootview
{
    UIView *footview = [[UIView alloc]init];
    footview.frame = CGRectMake(0, 0, kScreenWidth , 30);
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(10, 0, kScreenWidth - 20, 30);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(loadMoreData) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"点击加载更多" forState:UIControlStateNormal];
    [footview addSubview:btn];
    
    UILabel *label = [[UILabel alloc]initWithFrame:footview.frame];
    label.text = @"已经加载完全部数据";
    label.textColor = NBAColor(230, 180, 200);
    label.textAlignment = NSTextAlignmentCenter;
    [footview addSubview:label];
    
    self.tableView.tableFooterView = footview;
    [self.tableView.tableFooterView setHidden:YES];
    
}

-(void)loadMoreData
{
    self.page += 1;
    if(self.currentCategory == NBAFieldShowAll )
    {
        if (self.page > (self.fieldModels.count/kPAGECount+1))
        {
            [self.tableView.tableFooterView.subviews.firstObject setHidden:YES];
            [self.tableView.tableFooterView.subviews.lastObject setHidden:NO];
            return;
        }
    }
    else
    {
        if (self.page > (self.fieldCategroyModels.count/kPAGECount+1))
        {
            [self.tableView.tableFooterView.subviews.firstObject setHidden:YES];
            [self.tableView.tableFooterView.subviews.lastObject setHidden:NO];
            return;
        }
    }
    [self.tableView reloadData];
}

//懒加载
-(NSMutableArray*)fieldModels
{
    if (_fieldModels == nil)
    {
        _fieldModels = [NSMutableArray array];
    }
    return _fieldModels;
}
//懒加载
-(NSMutableArray*)fieldCategroyModels
{
    if (_fieldCategroyModels == nil)
    {
        self.fieldCategroyModels =[NSMutableArray array];
    }
    return _fieldCategroyModels;
    
}

-(void)sendPIOSearch
{
    //设置请求参数
    AMapPOIKeywordsSearchRequest *keywordrequest = [[AMapPOIKeywordsSearchRequest alloc]init];
    keywordrequest.city = self.city;
    keywordrequest.keywords = @"篮球｜篮球馆｜篮球场";
    keywordrequest.types = @"体育休闲服务";
    keywordrequest.sortrule = 0;
    keywordrequest.requireExtension = YES;
    keywordrequest.offset = 50;//取值范围为1-50
    keywordrequest.page= self.page;
    
    NBALog(@"数据的页数 page ＝ %ld",keywordrequest.page);
    //发起城市搜索
    [_search AMapPOIKeywordsSearch:keywordrequest];
}



#pragma mark-POI搜索
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if(response.pois.count == 0)
    {
        //存入数据
        self.page = 2;
        return;
    }
    
    NSString *strPoi = @"";

    for (AMapPOI *p in response.pois)
    {
        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@-%@-%@", strPoi, p.name,p.address,p.tel];
    
        NBAFieldTableModel *amodel = [[NBAFieldTableModel alloc]init];
        amodel.location = p.location;
        amodel.name = p.name;
        amodel.address = p.address;
        amodel.tel = p.tel;
        amodel.district = p.district;
        amodel.businessArea = p.businessArea;
//        amodel.distance =[NSNumber numberWithDouble:p.distance];
        [self.fieldModels addObject:amodel];
    }

    NSString *result = [NSString stringWithFormat:@"%ld \n  %@", response.pois.count,  strPoi];
    NBALog(@"Place: %@", result);
  
    //第一次进入数据搜索的时候去刷新tableview列表
    if (self.tableView.tableFooterView.isHidden)
    {
        self.page++; //page = 2,第一次刷新表格去显示
//        NBALog(@"关闭加载框－－－－－－－");
        [MBProgressHUD hideHUD];
//        NBALog(@"%@－－－－－－－",self.tableView.tableFooterView.subviews);
        UIButton *btn = self.navigationItem.titleView.subviews.firstObject;
        [btn setTitle:@"全部" forState:UIControlStateNormal];
        [self.tableView.tableFooterView.subviews.lastObject setHidden:YES];
        [self.tableView.tableFooterView setHidden:NO];
        [self.tableView reloadData];
    }
    else
    {
        self.page++;
    }
    
    //再次发起PIO Search
   
    [self sendPIOSearch];
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger currentCategory = self.currentCategory;
    if (currentCategory == NBAFieldShowAll)
    {
        //为保证进入第一页的时候不加载数据
        if (self.page >= 1 && self.page < (self.fieldModels.count / kPAGECount + 1))
        {
            return (self.page - 1) * kPAGECount;
        }
        return self.fieldModels.count;
    }
    else //if (currentCategory == NBAFieldShowZone || currentCategory == NBAFieldShowDistance)
    {
        if (self.page >= 1 && self.page < (self.fieldCategroyModels.count / kPAGECount + 1))
        {
            return self.page * kPAGECount;
        }
        return self.fieldCategroyModels.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NBAFieldTableCell *cell = [NBAFieldTableCell FieldTableCellWithTableview:tableView];
    if (self.currentCategory == NBAFieldShowAll)
    {
        cell.cellModel = self.fieldModels[indexPath.row];
    }
    else
    {
        cell.cellModel = self.fieldCategroyModels[indexPath.row];
    }
    
    self.Cell = cell;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return self.Cell.cellheight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NBAFieldDetailViewController *vc = [[NBAFieldDetailViewController alloc]init];
    if (self.currentCategory == NBAFieldShowAll)
    {
        vc.fieldModel = self.fieldModels[indexPath.row];
    }
    else
    {
        vc.fieldModel = self.fieldCategroyModels[indexPath.row];
    }
    [self.navigationController pushViewController:vc animated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
