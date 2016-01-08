//
//  ScoreResultCell.h
//  我爱NBA
//
//  Created by philipyu on 15/11/23.
//  Copyright (c) 2015年 com.philipyu. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ScoreResultModel.h"
//#import "ScoreResultFrameModel.h"
@class ScoreResultModel,ScoreResultFrameModel;

@protocol ScoreResultCellDelegate <NSObject>

- (void)toVideoPlay:(UIButton *)btn title:(NSString *)tle url:(NSString *)url;

@end

@interface ScoreResultCell : UITableViewCell


//link1text 定义为button可以接收点击事件
@property (nonatomic,weak) UIButton *link1textbutton;
//link1url 点击link1text会打开这个url页面
@property (nonatomic,weak) UILabel *link1textlabel;

//link2text 定义为button可以接收点击事件
@property (nonatomic,weak) UIButton *link2textbutton;
//link2url 点击link1text会打开这个url页面
@property (nonatomic,weak) UILabel *link2textlabel;
//球队1名字
@property (nonatomic,weak) UILabel *player1Name;
//球队1的图标
@property (nonatomic,weak) UIImageView *player1Icon;
//球队2名字
@property (nonatomic,weak) UILabel *player2Name;
//球队2的图标
@property (nonatomic,weak) UIImageView *player2Icon;
//比分
@property (nonatomic,weak) UILabel *scoreLabel;
//比赛状态"0":"未开赛","1":"直播中","2":"已结束"
@property (nonatomic,weak) UILabel *statusLabel;
//比赛时间
@property (nonatomic,weak) UILabel *timeLabel;

//模型数据
@property (nonatomic,strong) ScoreResultFrameModel *resultFrameModel;

//@property (nonatomic,weak) id <ScoreResultCellDelegate> delegate;
@property (assign, nonatomic) id<ScoreResultCellDelegate> delegate;

+(instancetype)ScoreResultCellWithTableview:(UITableView *)tableView;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
