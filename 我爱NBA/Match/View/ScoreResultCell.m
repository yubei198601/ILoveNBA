//
//  ScoreResultCell.m
//  我爱NBA
//
//  Created by philipyu on 15/11/23.
//  Copyright (c) 2015年 com.philipyu. All rights reserved.
//

#import "ScoreResultCell.h"
#import "ScoreResultModel.h"
#import "UIImageView+WebCache.h"
#import "ScoreResultFrameModel.h"
#import "Masonry.h"


#define kGap  10


@implementation ScoreResultCell

+(instancetype)ScoreResultCellWithTableview:(UITableView *)tableView
{
    static NSString *identifier = @"score";
    ScoreResultCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[ScoreResultCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        //添加所有的控件
        /*添加“视频集锦”按钮*/
        UIButton *link1button = [[UIButton alloc]init];
        self.link1textbutton = link1button;
//        self.link1textbutton.backgroundColor = [UIColor blueColor];
        [self.link1textbutton  setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        self.link1textbutton.titleLabel.font = techFont;
        [self.link1textbutton setTag:1];
        [self.link1textbutton addTarget:self action:@selector(videoPlay:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:link1button];
        
        /*添加“视频集锦”url*/
        UILabel *link1textlabel = [[UILabel alloc]init];
        self.link1textlabel = link1textlabel;
        [self.contentView addSubview:link1textlabel];
        
        /*添加“技术统计”按钮*/
        UIButton *link2button = [[UIButton alloc]init];
        self.link2textbutton = link2button;
        [self.link2textbutton  setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        self.link2textbutton.titleLabel.font = techFont;
        [self.link2textbutton setTag:2];
        
        [self.link2textbutton addTarget:self action:@selector(videoPlay:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:link2button];
        
        /*添加“技术统计”url*/
        UILabel *link2textlabel = [[UILabel alloc]init];
        self.link2textlabel = link2textlabel;
        [self.contentView addSubview:link2textlabel];
        
        /*添加第一支球队名字*/
        UILabel *player1Name = [[UILabel alloc]init];
        self.player1Name = player1Name;
        self.player1Name.font = nameFont;
        [self.contentView addSubview:player1Name];
        
        /*添加第一支球队的队标*/
        UIImageView *player1Icon = [[UIImageView alloc]init];
        self.player1Icon = player1Icon;
        [self.contentView addSubview:player1Icon];
        
        /*添加第二支球队名字*/
        UILabel *player2Name = [[UILabel alloc]init];
        self.player2Name = player2Name;
        self.player2Name.font = nameFont;
        [self.contentView addSubview:player2Name];
//        self.player2Icon.center.y = self.player2Name.center.y;
        
        /*添加第二支球队的队标*/
        UIImageView *player2Icon = [[UIImageView alloc]init];
        self.player2Icon = player2Icon;
        [self.contentView addSubview:player2Icon];
        
        /*添加两支球队的比分*/
        UILabel *scoreLabel = [[UILabel alloc]init];
        self.scoreLabel = scoreLabel;
        [self.scoreLabel setFont:scoreFont];
        [self.contentView addSubview:scoreLabel];
        
        /*添加比赛状态*/
        UILabel *statusLabel = [[UILabel alloc]init];
        self.statusLabel = statusLabel;
        self.statusLabel.font = nameFont;
        [self.contentView addSubview:statusLabel];
        
        /*添加比赛时间*/
        UILabel *timeLabel = [[UILabel alloc]init];
        self.timeLabel = timeLabel;
        self.timeLabel.font = nameFont;
        [self.contentView addSubview:timeLabel];
        
//        self.userInteractionEnabled = NO;
//        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    return self;
}

-(void)setResultFrameModel:(ScoreResultFrameModel *)resultFrameModel
{
    
    _resultFrameModel = resultFrameModel;
    
    ScoreResultModel *resultModel = resultFrameModel.resultModel;
    
    //设置数据
    [self.link1textbutton setTitle:resultModel.link1text forState:UIControlStateNormal];
    
    [self.link2textbutton setTitle:resultModel.link2text forState:UIControlStateNormal];

    self.link1textlabel.text = resultModel.link1url;
//    NSLog(@"%@",self.link1textlabel.text);
    self.link2textlabel.text = resultModel.link2url;
//    NSLog(@"%@",self.link2textlabel.text);
    self.player1Name.text = resultModel.player1Name;
    
    self.player2Name.text = resultModel.player2Name;
    
    NSURL *url1 = [NSURL URLWithString:resultModel.player1IconStr];
    [self.player1Icon sd_setImageWithURL:url1 placeholderImage:nil];
    
    NSURL *url2 = [NSURL URLWithString:resultModel.player2IconStr];
    [self.player2Icon sd_setImageWithURL:url2 placeholderImage:nil];
    
    self.scoreLabel.text = resultModel.score;
    
    if ([resultModel.status isEqualToString:@"0"] )
    {
        self.statusLabel.text = @"未开始";
    }
    else if ([resultModel.status isEqualToString:@"1"])
    {
        self.statusLabel.text = @"直播中";
    }
    else
    {
        self.statusLabel.text = @"已结束";
    }
    
    self.timeLabel.text = resultModel.time;
    
    //设置约束
    
    
    
    //设置frame
    self.link1textbutton.frame = resultFrameModel.link1textbuttonF;
    
    self.link2textbutton.frame = resultFrameModel.link2textbuttonF;
    
    self.player1Icon.frame = resultFrameModel.player1IconF;
    
    self.player1Name.frame = resultFrameModel.player1NameF;
    
    self.scoreLabel.frame = resultFrameModel.scoreLabelF;
    
    self.player2Name.frame = resultFrameModel.player2NameF;
    
    self.player2Icon.frame =resultFrameModel.player2IconF;
    
    self.statusLabel.frame = resultFrameModel.statusLabelF;
    
    self.timeLabel.frame = resultFrameModel.timeLabelF;
    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)videoPlay:(UIButton *)btn
{

    if ([self.delegate respondsToSelector:@selector(toVideoPlay:title:url:)])
    {
        if (btn.tag == 1) {

            [self.delegate toVideoPlay:btn title:self.link1textbutton.titleLabel.text url:self.link1textlabel.text];
        }
        else if(btn.tag == 2)
        {

            [self.delegate toVideoPlay:btn title:self.link2textbutton.titleLabel.text url:self.link2textlabel.text];
        }
       
        
    }
}
@end
