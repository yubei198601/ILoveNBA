//
//  ScoreResultModel.h
//  我爱NBA
//
//  Created by philipyu on 15/11/24.
//  Copyright (c) 2015年 com.philipyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreResultModel : NSObject<NSCoding>
//link1text 视频集锦
@property (nonatomic,copy) NSString *link1text;
//link1url 点击link1text会打开这个url页面
@property (nonatomic,copy) NSString *link1url;

//link2text 技术统计
@property (nonatomic,copy) NSString *link2text;
//link2url 点击link1text会打开这个url页面
@property (nonatomic,copy) NSString *link2url;
//球队1名字
@property (nonatomic,copy) NSString *player1Name;
//球队1的图标
@property (nonatomic,copy) NSString *player1IconStr;
//球队2名字
@property (nonatomic,copy) NSString *player2Name;
//球队2的图标
@property (nonatomic,copy) NSString *player2IconStr;
//比分
@property (nonatomic,copy) NSString *score;
//比赛状态"0":"未开赛","1":"直播中","2":"已结束"
@property (nonatomic,copy) NSString *status;
//比赛时间
@property (nonatomic,copy) NSString *time;


@end
