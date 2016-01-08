//
//  matchVideoPlayController.m
//  我爱NBA
//
//  Created by philipyu on 15/12/3.
//  Copyright (c) 2015年 com.philipyu. All rights reserved.
//

#import "matchVideoPlayController.h"

@interface matchVideoPlayController ()
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation matchVideoPlayController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.biaoTi;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    UIWebView *webview = [[UIWebView alloc]init];
    [webview setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.webView = webview;
    [self.view addSubview:webview];
    
    // Do any additional setup after loading the view.
    self.webView.scalesPageToFit = YES;
    
    // 2.加载网页
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.strUrl]];
    [self.webView loadRequest:request];
}

-(void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
