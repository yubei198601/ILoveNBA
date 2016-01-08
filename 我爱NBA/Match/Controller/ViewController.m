//
//  ViewController.m
//  我爱NBA
//
//  Created by philipyu on 15/11/23.
//  Copyright (c) 2015年 com.philipyu. All rights reserved.
//

#import "ViewController.h"
#import "matchResultViewController.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "ScoreResultModel.h"
#import "ScoreResultFrameModel.h"
#import "ScoreResultCell.h"
#import "DatabaseTool.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "matchVideoPlayController.h"
#import "NBAConst.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import "shareMatchViewController.h"
#import "matchBottomShare.h"
#import "UIImageView+WebCache.h"
#import "WeiboSDK.h"
#import "WeiboUser.h"
#import "NBAMapViewController.h"
#import "NBAFieldTableViewController.h"




#define WS(ws) __weak __typeof(&*self)ws = self

@interface ViewController ()<ScoreResultCellDelegate>

//里面存放比赛的模型数据
@property (nonatomic,strong) NSMutableArray *matchArray;
//里面存放frame数据
@property (nonatomic,strong) NSMutableArray *matchFrameArray;
//里面存放每一天的frame数据
@property (nonatomic,strong) NSMutableArray *dayFrameArray;
//bottom link网址，里面放的是字符串
@property (nonatomic,strong) NSMutableArray *bottomLinks;
//日期标题
@property (nonatomic,strong) NSMutableArray *titles;
//选中的按钮
@property (nonatomic,strong) UIButton *selectBtn;
//底部分享栏
@property (nonatomic,strong) UIView *shareview;
//遮盖
@property (nonatomic,strong) UIView *coverview;
//选中的行
@property (nonatomic,assign) NSInteger selectTableRow;
@end

@implementation ViewController

//懒加载
-(NSMutableArray*)matchArray
{
    if (_matchArray == nil) {
        self.matchArray = [NSMutableArray array];
    }
    return _matchArray;
    
}

//懒加载
-(NSMutableArray*)matchFrameArray
{
    if (_matchFrameArray == nil) {
        self.matchFrameArray = [NSMutableArray array];
    }
    return _matchFrameArray;
    
}
//懒加载
-(NSMutableArray*)dayFrameArray
{
    if (_dayFrameArray == nil) {
        self.dayFrameArray = [NSMutableArray array];
    }
    return _dayFrameArray;
    
}
//懒加载
-(NSMutableArray*)bottomLinks
{
    if (_bottomLinks == nil) {
        self.bottomLinks = [NSMutableArray array];
    }
    return _bottomLinks;
    
}

//懒加载
-(NSMutableArray*)titles
{
    if (_titles == nil)
    {
        self.titles = [NSMutableArray array];
    }
    return _titles;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.navigationController.isNavigationBarHidden) {
        self.navigationController.navigationBarHidden = NO;
    }
    
    if (self.navigationController.tabBarController.tabBar.isHidden ) {
        self.navigationController.tabBarController.tabBar.hidden = NO;
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 1.设置导航栏
    [self navSetUp];
    
    // 2.添加下拉刷新
    [self downRefresh];
    
    // 3.请求网络数据
    [self loadData];
//    [self requestNetworkData];
    
    // 4.添加底部的分享view
    [self coverView];
    [self shareView];

    NBALog(@"%@",self.navigationController.view.subviews[0]);
}

-(void)navSetUp
{
    //客制化的图片怎样添加到左右角落的item上，办法就是实用customview
    self.navigationItem.title = @"赛事详情";
    self.navigationController.navigationBar.barStyle =  UIBarStyleBlackOpaque ;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(photo:)];
}



#pragma mark - 添加分享菜单和遮盖
-(void)coverView
{
    UIButton *coverview = [[UIButton alloc]init];
    coverview.backgroundColor = [UIColor blackColor];
    coverview.alpha = 0.2;
    [coverview addTarget:self action:@selector(exitShare) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:coverview];

    [coverview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationController.view);
        make.bottom.equalTo(self.navigationController.view);
        make.left.equalTo(self.navigationController.view);
        make.right.equalTo(self.navigationController.view);
    }];
    [coverview setHidden:YES];
    self.coverview = coverview;
}

-(void)shareView
{
    matchBottomShare *bottomView = [[matchBottomShare alloc]init];
    [self.navigationController.view addSubview:bottomView];

    [bottomView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.left.mas_equalTo(self.navigationController.view.mas_left);
        make.top.equalTo(self.navigationController.view.subviews[0].mas_bottom);
        make.height.mas_equalTo(@100);
        make.width.mas_equalTo(@(self.view.bounds.size.width));
    }];
    
    [bottomView addWechatTarget:self action:@selector(shareClick)];
    [bottomView addWeiboTarget:self action:@selector(weiboClick)];
   
    self.shareview =(UIView*) bottomView;
}

//响应分享按钮点击
-(void)shareClick
{
    //测试发起多媒体,发送到朋友圈
    SendMessageToWXReq *wxReq = [[SendMessageToWXReq alloc]init];
    //1.设置为多媒体分享，并发送到朋友圈
    wxReq.bText = NO;
    wxReq.scene = WXSceneTimeline;
    
    //2.取得被点击的模型数据
    ScoreResultFrameModel *frameModel = self.dayFrameArray[self.selectTableRow];
    ScoreResultModel *dataModel = frameModel.resultModel;
    
    //3.设置message  为什么不起作用
    WXMediaMessage *message = [WXMediaMessage message];
    /*标题*/
    message.title =[NSString stringWithFormat: @"%@ vs %@",dataModel.player1Name,dataModel.player2Name];
    /*描述信息*/
    message.description = [NSString stringWithFormat:@"%@",dataModel.time];
    NSURL *url1 = [NSURL URLWithString:dataModel.player1IconStr];
    /*缩略图数据*/
    message.thumbData = [NSData dataWithContentsOfURL:url1];
    /*分享的图片数据内容*/
    WXImageObject *obj = [WXImageObject object];
    obj.imageData = [NSData dataWithContentsOfURL:url1];
    message.mediaObject = obj;
//    obj.imageUrl = dataModel.player2IconStr;

//    UIImageView *imageview = [[UIImageView alloc]init];
//    [imageview sd_setImageWithURL:url1];
//
//    
//    [wxReq.message setThumbImage:imageview.image];
    wxReq.message = message;
//    NBALog(@"%d",[WXApi sendReq:wxReq]);
    if( [WXApi sendReq:wxReq])
    {
        NBALog(@"发送给微信的请求成功");
    }
//    message = nil;
    wxReq.message = nil;
    wxReq = nil;
}

-(void)weiboClick
{
    NBALog(@"weibo-------");
//    WBImageObject *imageMsg = [WBImageObject object];
    WBMessageObject *msg = [WBMessageObject message];
    msg.text = @"来自我爱nba的消息";
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:msg];
    
    if ([WeiboSDK sendRequest:request])
    {
        NBALog(@"微博发送文字消息成功");
    }
}

-(void)exitShare
{
//   1. 隐藏遮盖
    [self.coverview setHidden:YES];
    UIView *btmView = self.shareview;
    
//   2.动画移除分享框
    __block CGRect tempRect;
    [UIView animateWithDuration:1.0 animations:^{
        tempRect = btmView.frame;
        tempRect.origin.y += btmView.frame.size.height;
        btmView.frame = tempRect;
    }];
    
//  3.显示tabbar
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tabBarController.tabBar setHidden:NO];
    });
    
//    4.取消UITableview选中

//    [self.tabBarController.tabBar setHidden:NO];
}

-(void)layoutBtn
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width , 120)];
    [self.view addSubview:view];
    
    /*添加球队赛程，球员排名，社区论坛等按钮*/
    for (int i=0; i<self.bottomLinks.count; i++)
    {
        UIButton *matchBtn = [[UIButton alloc]init];
        [matchBtn setTitle:self.bottomLinks[i][@"text"] forState:UIControlStateNormal];
        [matchBtn setTitle:self.bottomLinks[i][@"text"] forState:UIControlStateSelected];
        [matchBtn setBackgroundColor:[UIColor purpleColor]];
        [matchBtn setTag:(i+1)];
        [matchBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [matchBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [matchBtn addTarget:self action:@selector(topButtonResponder:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:matchBtn];
    }
    
    /*添加日期分组功能*/
    for (int j=0; j<self.titles.count; j++)
    {
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitle:self.titles[j] forState:UIControlStateNormal];
        [btn setTitle:self.titles[j] forState:UIControlStateSelected];
        [btn setBackgroundColor:[UIColor greenColor]];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(dateButtonResponder:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:(self.bottomLinks.count+j+1)];
        [view addSubview:btn];
    }
    
    /*添加日期日期下面的指示线*/
    UIView *indicatorView = [[UIView alloc]init];
    [view addSubview:indicatorView];
    indicatorView.tag = self.bottomLinks.count + self.titles.count + 1;
    indicatorView.backgroundColor = [UIColor purpleColor];
    [self addBtnConstraints:view];
    self.tableView.tableHeaderView = view;
    
    /*进入界面就显示当前日期的数据列表*/
    [self dateButtonResponder:(UIButton *)[view viewWithTag:6]];
  
}


-(void)addBtnConstraints:(UIView*)view
{
    CGFloat padding = 10;
//    WS(ws);
    UIButton *uv1 = (UIButton*)[view viewWithTag:1];
    UIButton *uv2 = (UIButton*)[view viewWithTag:2];
    UIButton *uv3 = (UIButton*)[view viewWithTag:3];
    UIButton *uv4 = (UIButton*)[view viewWithTag:4];
    
    UIButton *uv5 = (UIButton*)[view viewWithTag:5];
    UIButton *uv6 = (UIButton*)[view viewWithTag:6];
    UIButton *uv7 = (UIButton*)[view viewWithTag:7];
    UIView *uv8 = [view viewWithTag:8];
//    UIButton *uv4 = (UIButton*)[view viewWithTag:4];
    [uv1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(padding);
        make.left.equalTo(view).with.offset(padding);
        make.width.equalTo(uv2);
        make.height.equalTo(uv2);
    }];
    
    [uv2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(uv1);
        make.left.equalTo(uv1.mas_right).with.offset(padding);
        make.right.equalTo(view.mas_right).with.offset(-padding);
        make.width.equalTo(uv3);
        make.height.equalTo(uv3);
    }];
    
    [uv3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(uv1.mas_bottom).with.offset(padding);
        make.left.equalTo(uv1);
        make.width.equalTo(uv4);
        make.height.equalTo(uv4);
        make.bottom.equalTo(uv5.mas_top).with.offset(-padding);
    }];
    
    [uv4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(uv3);
        make.left.equalTo(uv2);
        make.right.equalTo(view.mas_right).with.offset(-padding);
        make.bottom.equalTo(uv3);
        make.height.equalTo(uv1);
    }];
    
    [uv5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(padding);
        make.bottom.equalTo(view.mas_bottom).with.offset(-padding);
        
        make.width.equalTo(uv6);
        make.height.equalTo(uv6);
    }];

    [uv6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(uv5.mas_right).with.offset(padding);
        make.bottom.equalTo(uv5);
        make.width.equalTo(uv7);
        make.height.equalTo(uv7);
    }];
    
    
    [uv7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(uv6.mas_right).with.offset(padding);
        make.bottom.equalTo(uv6);
        make.right.equalTo(view.mas_right).with.offset(-padding);
    }];
    
    [uv8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).with.offset((view.bounds.size.width - padding)/3+padding);
        make.bottom.equalTo(view.mas_bottom).with.offset(-5);
        make.height.equalTo(@2);
        make.width.equalTo(@((view.bounds.size.width - 4*padding)/3));
    }];
}


-(void)topButtonResponder:(UIButton*)btn
{
//    NSLog(@"topButtonResponder-----");

    matchResultViewController *matchVC = [[matchResultViewController alloc]init];
    matchVC.urlStr = self.bottomLinks[btn.tag-1][@"url"];
    matchVC.biaoTi = self.bottomLinks[btn.tag-1][@"text"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:matchVC];
    [self presentViewController:nav animated:YES completion:nil];
    
}

-(void)dateButtonResponder:(UIButton*)btn
{
    if (self.matchFrameArray.count == 0)
    {
        return;
    }
    
    self.selectBtn.selected = NO;
    btn.selected = YES;
    self.selectBtn = btn;
    
    if (self.dayFrameArray.count)
    {
        [self.dayFrameArray removeAllObjects];
    }

    NSDate *date = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"MM/dd";
    NSString* strToday = [format stringFromDate:date];
    NSDate *date1 = [format dateFromString:strToday];
    
    for (ScoreResultFrameModel *model in self.matchFrameArray)
    {
        NSString *str = model.resultModel.time;
        NSRange range = [str rangeOfString:@" "];
        NSString *substring = [str substringToIndex:range.location];
        NSDate *date2 = [format dateFromString:substring];
        switch (btn.tag)
        {
            case 5:
                if ([date1 compare:date2] == NSOrderedDescending)
                {
                    [self.dayFrameArray addObject:model];
                }
                break;
            case 6:
                if ([date1 compare:date2] == NSOrderedSame)
                {
                    [self.dayFrameArray addObject:model];
                }
                break;
            case 7:
                if ([date1 compare:date2] == NSOrderedAscending)
                {
                    [self.dayFrameArray addObject:model];
                }
                break;
            default:
                break;
        }
    }
    
    UIView *superView = self.tableView.tableHeaderView;
    UIView *line = [superView viewWithTag:8];
    CGFloat padding = 10.0;
    
    __block CGRect tempRect;
    [UIView animateWithDuration:0.5 animations:^{
        tempRect = line.frame;
        if (btn.tag == 5)
        {
            tempRect.origin.x = padding;
        }
        else if(btn.tag == 6)
        {
            tempRect.origin.x = (superView.frame.size.width - padding)/3 + padding;
        }
        else
        {
            tempRect.origin.x = (superView.frame.size.width - padding)*2/3 + padding;
        }
       line.frame = tempRect;
    }];
    
    
    [self.tableView reloadData];
}

-(void)downRefresh
{
    UIRefreshControl *freshCtrl = [[UIRefreshControl alloc]init];
    [freshCtrl addTarget:self action:@selector(refreshValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:freshCtrl];
}

-(void)refreshValueChange:(UIRefreshControl*)freshcontrol
{
    //1.先清除数据库中所有的数据
    [DatabaseTool deleteMatches];

    //2.发送网络请求
    [self requestNetworkData:freshcontrol];
    
}

-(void)loadData
{
    NSArray *matchesArray = [DatabaseTool matches];
//    NSLog(@"match count:%ld",matchesArray.count);
    if (matchesArray.count)
    {
        for (ScoreResultModel *result in matchesArray)
        {
            ScoreResultFrameModel *Framemodel = [[ScoreResultFrameModel alloc]init];
            Framemodel.resultModel = result;
            [self.matchFrameArray addObject:Framemodel];
        }
        NBALog(@"从数据库中取数据，非网络请求获取");
        [self.tableView reloadData];
    }
    else
    {
        [self requestNetworkData:nil];
    }
}

//afn请求数据更简洁
-(void)requestNetworkData:(UIRefreshControl*)freshcontrol
{
    //创建网络管理者
    AFHTTPRequestOperationManager *mgr = [[AFHTTPRequestOperationManager alloc]init];
    NSString *str  = kResuestString;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kAppKey;
    
    //发送请求
    [mgr GET:str parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSDictionary *dict = responseObject;
        //取得查询比赛结果的字典
        NSDictionary *dictResult = dict[@"result"];
//        NSLog(@"%@",dictResult[@"teammatch"]);
        //取得赛事列表的数组,里面放的是数据字典
        NSArray *listArray = dictResult[@"list"];
//        NSLog(@"%@",listArray);
        
        //遍历数组中的对阵数据,先删除原有的数据再下载
        if (self.matchFrameArray.count)
        {
            [self.matchFrameArray removeAllObjects];
        }
        
        if (self.matchArray.count)
        {
            [self.matchArray removeAllObjects];
        }
        
        NSArray *bottomLink = listArray[0][@"bottomlink"];
        
        for (NSDictionary *dict in bottomLink)
        {
            [self.bottomLinks addObject:dict];
        }


        for (NSDictionary *dictionary in listArray)
        {
            NSArray *arrayModel  = [ScoreResultModel objectArrayWithKeyValuesArray:dictionary[@"tr"]];
            [self.matchArray addObjectsFromArray:arrayModel];
            [self.titles addObject:dictionary[@"title"]];
        }
       
        
        for (ScoreResultModel *model in _matchArray)
        {
            ScoreResultFrameModel *frameModel = [[ScoreResultFrameModel alloc]init];
            frameModel.resultModel = model;
            [self.matchFrameArray addObject:frameModel];
        }
        
        if ([DatabaseTool matches].count)
        {
            [DatabaseTool saveMatches:self.matchArray];
        }

//        刷新tableview显示数据
        [self.tableView reloadData];
        if (freshcontrol)
        {
            [freshcontrol endRefreshing];
        }
        else
        {
            [self layoutBtn];
            
        }
        
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NBALog(@"加载网络数据失败");
        if (freshcontrol)
        {
            [freshcontrol endRefreshing];
        }
    }];
    
}

//-(void)testUrlConnectData
//{
//    //1.url string
//    NSMutableString *str = [NSMutableString string];
//    
//    //2.append url string
//    [str appendString:kResuestString];
//    [str appendString:@"?key="];
//    [str appendString:kAppKey];
////    NSLog(@"%@",str);
//    
//    //3.url
//    NSURL *url = [NSURL URLWithString:str];
////    NSLog(@"%@",url);
//    
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    //4.queue
//    NSOperationQueue *queue = [NSOperationQueue mainQueue];
//    
//    //5.发送请求(异步请求在子线程发送，毁掉时回到主线程，执行block里面的回调代码)
//    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        if(data == nil ||  connectionError)
//        {
//            return;
//        }
//        
//        //6.json解析
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//        
//        NSString *jsonString = [[NSString alloc]initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
//        NSLog(@"dict=%@",jsonString);
//    }];
//}
#pragma mark -tableview的数据源方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dayFrameArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dayFrameArray.count == 0)  return nil;

    ScoreResultCell *cell = [ScoreResultCell ScoreResultCellWithTableview:tableView];
    cell.resultFrameModel = self.dayFrameArray[indexPath.row];
    cell.delegate = self;

    return cell;
}

#pragma mark -tableview的代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScoreResultFrameModel *frame = self.dayFrameArray[indexPath.row];
    
    return frame.cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*分享数据到微信，微博，qq等*/
    //1.隐藏tabbar
    [self.tabBarController.tabBar setHidden:YES];
    //2.显示遮盖
    [self.coverview setHidden:NO];
    //3.动画弹出分享菜单
    UIView *btmView = self.shareview;

    __block CGRect tempRect;
    [UIView animateWithDuration:1.0 animations:^{
        tempRect = btmView.frame;
        tempRect.origin.y -= btmView.frame.size.height;
        btmView.frame = tempRect;
    }];
    
    //4.记录被选择的row
    self.selectTableRow = indexPath.row;
    
}

#pragma mark－ cell的代理方法
-(void)toVideoPlay:(UIButton *)btn title:(NSString *)tle url:(NSString *)url
{
    matchVideoPlayController *matchPC = [[matchVideoPlayController alloc]init];
    matchPC.biaoTi = tle;
    matchPC.strUrl = url;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:matchPC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    for (ScoreResultFrameModel *framemodel in self.dayFrameArray)
    {
        [framemodel setResultModel:framemodel.resultModel];
    }
    [self addBtnConstraints:self.tableView.tableHeaderView];
    [self shareView];
    [self.tableView reloadData];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{

}
@end
