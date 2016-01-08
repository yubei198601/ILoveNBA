//
//  shareMatchViewController.m
//  我爱NBA
//
//  Created by philipyu on 15/12/14.
//  Copyright © 2015年 com.philipyu. All rights reserved.
//

#import "shareMatchViewController.h"
#import "matchBottomShare.h"
#import "Masonry.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import "NBAConst.h"

@interface shareMatchViewController ()

@end

@implementation shareMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //1.设置导航条内容
    [self setupNavBar];
    
    //2.添加分享菜单
    [self addShareMenu];
}


-(void)setupNavBar
{
    self.title = @"分享";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    
}

-(void)addShareMenu
{
    matchBottomShare *share = [[matchBottomShare alloc]init];
    [self.view addSubview:share];
    
    //添加约束
    [share mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(@100);
    }];
    
    [share addWechatTarget:self action:@selector(startWechatShare)];
    [share addWeiboTarget:self action:@selector(startWeiboShare)];
}


-(void)startWechatShare
{
    //仅测试发起文本消息，不发多媒体,发送到朋友圈
        SendMessageToWXReq *wxReq = [[SendMessageToWXReq alloc]init];
        wxReq.text = @"";
//        wxReq.message.title = [NSString stringWithFormat:@"%@ vs %@",];
        wxReq.bText = NO;
        wxReq.scene = WXSceneTimeline;
    
       if( [WXApi sendReq:wxReq])
       {
           NBALog(@"发送给微信的请求成功");
       }
    
       wxReq = nil;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
