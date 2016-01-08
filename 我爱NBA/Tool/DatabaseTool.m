//
//  DatabaseTool.m
//  我爱NBA
//
//  Created by philipyu on 15/11/26.
//  Copyright (c) 2015年 com.philipyu. All rights reserved.
//

#import "DatabaseTool.h"
#import "FMDB.h"

@implementation DatabaseTool

static FMDatabase *_db;
+ (void)initialize
{
    // 1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"matches.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
//    NSLog(@"----- check initialize diaoyong");
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_match (id integer PRIMARY KEY, match blob NOT NULL);"];
}

+ (NSArray *)matches//WithParams:(NSDictionary *)params
{
    // 根据请求参数生成对应的查询SQL语句
    NSString *sql = nil;
    {
        sql = @"SELECT * FROM t_match;";
    }
    
    // 执行SQL
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *matches = [NSMutableArray array];
    while (set.next) {
        NSData *matchData = [set objectForColumnName:@"match"];
        NSDictionary *match = [NSKeyedUnarchiver unarchiveObjectWithData:matchData];
        [matches addObject:match];
    }
    return matches;
}

+ (void)saveMatches:(NSArray *)matches
{
    // 要将一个对象存进数据库的blob字段,最好先转为NSData
    // 一个对象要遵守NSCoding协议,实现协议中相应的方法,才能转成NSData
    for (NSDictionary *match in matches) {
        // NSDictionary --> NSData
        NSData *matchData = [NSKeyedArchiver archivedDataWithRootObject:match];
        [_db executeUpdateWithFormat:@"INSERT INTO t_match(match) VALUES (%@);", matchData];
    }
}

+(void)deleteMatches
{
    NSString *sql  = @"DELETE FROM t_match;";
    if ([_db executeStatements:sql])
    {
        NSLog(@"删除数据库数据成功");
    }
    else
    {
        NSLog(@"删除数据库数据失败");
    }
}
@end
