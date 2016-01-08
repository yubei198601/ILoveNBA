//
//  ScoreResultFrameModel.m
//  我爱NBA
//
//  Created by philipyu on 15/11/25.
//  Copyright (c) 2015年 com.philipyu. All rights reserved.
//

#import "ScoreResultFrameModel.h"
#import "ScoreResultModel.h"
#import "UIImageView+WebCache.h"
#import "NSString+Font.h"
#import "NBAConst.h"



#define  gap 10
#define  IconHW   50
#define kScreenOrient  ([UIApplication sharedApplication].statusBarOrientation)


@implementation ScoreResultFrameModel


-(void)setResultModel:(ScoreResultModel *)resultModel
{
    _resultModel = resultModel;
    

    /**1.设置第一支球队图像的frame*/
    CGFloat player1iconX = gap;
    CGFloat player1iconY = gap;
    CGFloat player1iconHW = IconHW;
    self.player1IconF = CGRectMake(player1iconX, player1iconY,player1iconHW , player1iconHW);
    
    /**2.设置第一支球队的名字的frame*/
    CGFloat play1nameX = CGRectGetMaxX(self.player1IconF)+gap;
    
    CGSize play1namesize = [NSString sizeWithString:resultModel.player1Name font:nameFont];
    CGFloat play1nameY = player1iconY + (player1iconHW - play1namesize.height)/2;
    
    self.player1NameF = CGRectMake(play1nameX, play1nameY, play1namesize.width, play1namesize.height);
    

    
    /**3.设置第二支球队图像的frame*/
    CGFloat player2iconX = 0;
    player2iconX = [UIScreen mainScreen].bounds.size.width - gap - IconHW;
    self.player2IconF = CGRectMake(player2iconX, player1iconX, IconHW, IconHW);
    
    /**4.设置第二支球队的名字的frame*/
    CGSize play2namesize = [NSString sizeWithString:resultModel.player2Name font:nameFont];
    CGFloat play2nameX = player2iconX - gap - play2namesize.width;
    CGFloat play2nameY = play1nameY;
    self.player2NameF = CGRectMake(play2nameX, play2nameY, play2namesize.width, play2namesize.height);

    /**5.设置分数*/
    
    CGSize scoresize = [NSString sizeWithString:resultModel.score font:scoreFont];
    CGFloat scoreX = 0;

    scoreX = ([UIScreen mainScreen].bounds.size.width - scoresize.width)/2;
    CGFloat scoreY = player1iconY + (player1iconHW - scoresize.height)/2;
    self.scoreLabelF = (CGRect){{scoreX,scoreY},scoresize};
    
    /**6.视频集锦*/
    CGFloat linkvideoX = player1iconX;
    CGFloat linkvideoY = CGRectGetMaxY(self.player1IconF)+gap;
    CGSize linkvideoSize = [NSString sizeWithString:resultModel.link1text font:techFont];
    self.link1textbuttonF = (CGRect){{linkvideoX,linkvideoY},linkvideoSize};
    
    /**7.视频集锦*/
    CGFloat linktechX = CGRectGetMaxX(self.link1textbuttonF)+gap;
    CGFloat linktechY = linkvideoY;
    CGSize linktechSize = [NSString sizeWithString:resultModel.link2text font:techFont];
    self.link2textbuttonF = (CGRect){{linktechX,linktechY},linktechSize};
    
    /**8.比赛状态*/
//    CGFloat statusX = CGRectGetMaxX(self.link2textbuttonF)+gap*3;
    CGFloat statusY = linkvideoY;
    NSMutableString *statusStr = [NSMutableString string];
    switch ([resultModel.status intValue])
    {
        case 0:
            statusStr.string = @"未开始";
            break;
        case 1:
            statusStr.string = @"直播中";
            break;
        default:
            statusStr.string = @"已结束";
            break;
    }
    CGSize statusSize = [NSString sizeWithString:statusStr font:nameFont];
    CGFloat statusX = (kScreenWidth - statusSize.width)/2;
    self.statusLabelF = (CGRect){{statusX,statusY},statusSize};
    
    /**9.比赛开始时间*/
    CGSize timeSize = [NSString sizeWithString:resultModel.time font:nameFont];
    CGFloat timeX = kScreenWidth-3*gap-timeSize.width;
    CGFloat timeY = linkvideoY;
//    NSLog(@"%@",resultModel.time);
//    CGSize timeSize = [NSString sizeWithString:resultModel.time font:nameFont];
    self.timeLabelF = (CGRect){{timeX,timeY},timeSize};
    
    /**cell的高度*/
    self.cellHeight = MAX(CGRectGetMaxY(self.link1textbuttonF), CGRectGetMaxY(self.statusLabelF)) + gap;
    
}
@end
