//
//  ScoreResultModel.m
//  我爱NBA
//
//  Created by philipyu on 15/11/24.
//  Copyright (c) 2015年 com.philipyu. All rights reserved.
//

#import "ScoreResultModel.h"

@implementation ScoreResultModel
- (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"player1Name" : @"player1",
             @"player2Name" : @"player2",
             @"player1IconStr":@"player1logo",
             @"player2IconStr":@"player2logo",};
}
//@property (nonatomic,copy) NSString *link1text;
////link1url 点击link1text会打开这个url页面
////@property (nonatomic,strong) NSString *link1textlabel;
//
////link2text 技术统计
//@property (nonatomic,copy) NSString *link2text;
////link2url 点击link1text会打开这个url页面
////@property (nonatomic,strong) NSString *link2textlabel;
////球队1名字
//@property (nonatomic,copy) NSString *player1Name;
////球队1的图标
//@property (nonatomic,copy) NSString *player1IconStr;
////球队2名字
//@property (nonatomic,copy) NSString *player2Name;
////球队2的图标
//@property (nonatomic,copy) NSString *player2IconStr;
////比分
//@property (nonatomic,copy) NSString *score;
////比赛状态"0":"未开赛","1":"直播中","2":"已结束"
//@property (nonatomic,copy) NSString *status;
////比赛时间
//@property (nonatomic,copy) NSString *time;

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.link1text forKey:@"link1text"];
    [encoder encodeObject:self.link2text forKey:@"link2text"];
    [encoder encodeObject:self.link1url forKey:@"link1url"];
    [encoder encodeObject:self.link2url forKey:@"link2url"];
    [encoder encodeObject:self.player1Name forKey:@"player1Name"];
    [encoder encodeObject:self.player1IconStr forKey:@"player1IconStr"];
    [encoder encodeObject:self.player2IconStr forKey:@"player2IconStr"];
    [encoder encodeObject:self.player2Name forKey:@"player2name"];
    [encoder encodeObject:self.score forKey:@"score"];
    [encoder encodeObject:self.status forKey:@"status"];
    [encoder encodeObject:self.time forKey:@"time"];

}

-(id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
       self.link1text =  [decoder decodeObjectForKey:@"link1text"];
       self.link2text =  [decoder decodeObjectForKey:@"link2text"];
       self.link1url =  [decoder decodeObjectForKey:@"link1url"];
       self.link2url =  [decoder decodeObjectForKey:@"link2url"];
       self.player1Name =  [decoder decodeObjectForKey: @"player1Name"];
       self.player1IconStr =  [decoder decodeObjectForKey:@"player1IconStr"];
       self.player2IconStr =  [decoder decodeObjectForKey:@"player2IconStr"];
       self.player2Name =  [decoder decodeObjectForKey:@"player2name"];
       self.score =  [decoder decodeObjectForKey:@"score"];
       self.status = [decoder decodeObjectForKey:@"status"];
       self.time = [decoder decodeObjectForKey: @"time"];
    }
    return self;
}
@end
