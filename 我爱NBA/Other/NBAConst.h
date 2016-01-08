//
//  NBAConst.h
//  我爱NBA
//
//  Created by philipyu on 15/12/9.
//  Copyright (c) 2015年 com.philipyu. All rights reserved.
//

#ifndef __NBA_NBAConst_h
#define __NBA_NBAConst_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UIBarButtonItem+NBA.h"
#import "UIView+Extension.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "Masonry.h"

#ifdef DEBUG // 处于开发阶段
#define NBALog(...) NSLog(__VA_ARGS__)
#else // 处于发布阶段
#define NBALog(...)
#endif

// RGB颜色
#define NBAColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 随机色
#define NBARandomColor NBAColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

//juhe
#define kResuestString @"http://op.juhe.cn/onebox/basketball/nba"
#define kAppKey  @"84be4344aa88257a0bc6ab2ea3bbb286"

//wechat
#define kTeamCheckString  @"http://op.juhe.cn/onebox/basketball/team"
#define kFightCheckString @"http://op.juhe.cn/onebox/basketball/combat"
#define kWechatID @"wx5045150d8e95e0d0"

//weibo
#define kWeiboAppKey @"3905607490"
#define kRedirectURL @"https://api.weibo.com/oauth2/default.html"

//amap
#define kAmapAPIKey @"26adfd87efbdb2d8082ef25c58f5e899"

#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width

#define NBANotificationCenter [NSNotificationCenter defaultCenter]

#define kAllSort  @"全部"
#define kDistanceSort  @"按距离分"
#define kOrderSort  @"按预订分"

extern NSString *const NBAChangeZoneNotification;
extern NSString *const NBAZoneName;

extern NSString *const NBAChangeCityNotification;
extern NSString *const NBACityName;
#endif
