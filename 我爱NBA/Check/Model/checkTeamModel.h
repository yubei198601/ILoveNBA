//
//  checkTeamModel.h
//  我爱NBA
//
//  Created by philipyu on 15/12/9.
//  Copyright (c) 2015年 com.philipyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface checkTeamModel : NSObject
/**
link1text = "\U89c6\U9891\U76f4\U64ad";
link1url = "http://sports.qq.com/kbsweb/game.htm?mid=100000:1467961";
link2text = "\U6280\U672f\U7edf\U8ba1";
link2url = "";
"m_link1url" = "http://sports.qq.com/kbsweb/kbsshare/game.htm?mid=100000:1467961";
"m_link2url" = "";
"m_player1url" = "http://sports.qq.com/kbsweb/kbsshare/team.htm?cid=100000";
"m_player2url" = "http://sports.qq.com/kbsweb/kbsshare/team.htm?cid=100000";
"m_time" = "12-10 \U5468\U56db 09:00";
player1 = "\U6e56\U4eba";
player1logo = "http://mat1.gtimg.com/sports/nba/logo/78/13.png";
player1url = "http://kbs.sports.qq.com/kbsweb/teams.htm?tid=13";
player2 = "\U68ee\U6797\U72fc";
player2logo = "http://mat1.gtimg.com/sports/nba/logo/78/16.png";
player2url = "http://kbs.sports.qq.com/kbsweb/teams.htm?tid=16";
score = VS;
status = 0;
time = "12/10 09:00";
 */

@property (nonatomic,copy) NSString *link1text;
@property (nonatomic,copy) NSString *link1url;
@property (nonatomic,copy) NSString *link2text;
@property (nonatomic,copy) NSString *m_link1url;
@property (nonatomic,copy) NSString *m_time;
@property (nonatomic,copy) NSString *player1;
@property (nonatomic,copy) NSString *player1logo;
@property (nonatomic,copy) NSString *player1url;
@property (nonatomic,copy) NSString *player2;
@property (nonatomic,copy) NSString *player2logo;
@property (nonatomic,copy) NSString *player2url;
@property (nonatomic,copy) NSString *score;
@end
