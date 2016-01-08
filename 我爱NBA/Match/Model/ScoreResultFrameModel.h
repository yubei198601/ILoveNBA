//
//  ScoreResultFrameModel.h
//  我爱NBA
//
//  Created by philipyu on 15/11/25.
//  Copyright (c) 2015年 com.philipyu. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ScoreResultModel.h"
#import <UIKit/UIKit.h>


#define nameFont [UIFont systemFontOfSize:11]
#define scoreFont [UIFont systemFontOfSize:10]
#define techFont  [UIFont systemFontOfSize:12]

@class ScoreResultModel;
@interface ScoreResultFrameModel : NSObject
//link1text 定义为button可以接收点击事件
@property (nonatomic,assign) CGRect link1textbuttonF;
//link1url 点击link1text会打开这个url页面
//@property (nonatomic,weak) UILabel *link1textlabel;

//link2text 定义为button可以接收点击事件
@property (nonatomic,assign) CGRect link2textbuttonF;
//link2url 点击link1text会打开这个url页面
//@property (nonatomic,weak) UILabel *link2textlabel;
//球队1名字
@property (nonatomic,assign) CGRect player1NameF;
//球队1的图标
@property (nonatomic,assign) CGRect player1IconF;
//球队2名字
@property (nonatomic,assign) CGRect player2NameF;
//球队2的图标
@property (nonatomic,assign) CGRect player2IconF;
//比分
@property (nonatomic,assign) CGRect scoreLabelF;
//比赛状态"0":"未开赛","1":"直播中","2":"已结束"
@property (nonatomic,assign) CGRect statusLabelF;
//比赛时间
@property (nonatomic,assign) CGRect timeLabelF;

@property (nonatomic,assign) CGFloat cellHeight;

@property (nonatomic,strong) ScoreResultModel *resultModel;
@end
