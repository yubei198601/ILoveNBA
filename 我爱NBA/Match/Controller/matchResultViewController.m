//
//  matchResultViewController.m
//  我爱NBA
//
//  Created by philipyu on 15/12/1.
//  Copyright (c) 2015年 com.philipyu. All rights reserved.
//

#import "matchResultViewController.h"
#import "UIBarButtonItem+NBA.h"
#import "NBAConst.h"

@interface matchResultViewController ()
@property (nonatomic,strong) UIWebView *webView;
@end


@implementation matchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //1.设置导航栏
    self.title = self.biaoTi;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"icon_back" highlightimage:@"icon_back_highlighted"];
    //2.创建网页控件
    UIWebView *webview = [[UIWebView alloc]init];
    [webview setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.webView = webview;
    [self.view addSubview:webview];
    self.webView.scalesPageToFit = YES;
    //3.加载网页
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [self.webView loadRequest:request];
}

-(void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
