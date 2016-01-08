//
//  NBATabBarController.m
//  我爱NBA
//
//  Created by philipyu on 15/12/7.
//  Copyright (c) 2015年 com.philipyu. All rights reserved.
//

#import "NBATabBarController.h"
#import "ViewController.h"
#import "checkViewController.h"
#import "checkMatchController.h"
#import "NBAFieldTableViewController.h"


@interface NBATabBarController ()

@end

@implementation NBATabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //添加四个控制器
    //1.添加第一个控制器（主要用于球赛的显示）
    ViewController *resultvc = [[ViewController alloc]init];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
//    nav.title = @"赛事详情";
//     nav.tabBarItem =  [nav.tabBarItem initWithTabBarSystemItem:UITabBarSystemItemMore tag:1];
//    [self addChildViewController:nav];
    [self addChildViewController:resultvc title:@"赛事详情" TabBarSystemItem:UITabBarSystemItemMore  tag:1];
    
    //2.添加查询赛事的控制器（主要用于比赛查询）
    checkMatchController *checkvc = [[checkMatchController alloc]init];
//    UINavigationController *nav1 =[[UINavigationController alloc]initWithRootViewController:chvc];
//    nav1.title = @"赛事查询";
//    nav1.tabBarItem = [nav1.tabBarItem initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:2];
//    
//    [self addChildViewController:nav1];
    [self addChildViewController:checkvc title:@"赛事查询" TabBarSystemItem:UITabBarSystemItemBookmarks  tag:2];
    
    //1.添加第一个控制器（主要用于球赛的显示）
    NBAFieldTableViewController *nearbyvc = [[NBAFieldTableViewController alloc]init];
    //    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    //    nav.title = @"赛事详情";
    //     nav.tabBarItem =  [nav.tabBarItem initWithTabBarSystemItem:UITabBarSystemItemMore tag:1];
    //    [self addChildViewController:nav];
    [self addChildViewController:nearbyvc title:@"附近" TabBarSystemItem:UITabBarSystemItemRecents  tag:3];
    
}

-(void)addChildViewController:(UIViewController *)childController title:(NSString*)title TabBarSystemItem:(UITabBarSystemItem)systemItemType tag:(NSUInteger)tag
{
//    checkMatchController *chvc = [[checkMatchController alloc]init];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:childController];
    nav.title = title;
    nav.tabBarItem = [nav.tabBarItem initWithTabBarSystemItem:systemItemType tag:tag];
    [self addChildViewController:nav];
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
