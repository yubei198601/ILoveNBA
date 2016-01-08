//
//  DatabaseTool.h
//  我爱NBA
//
//  Created by philipyu on 15/11/26.
//  Copyright (c) 2015年 com.philipyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseTool : NSObject
+ (NSArray *)matches;//WithParams:(NSDictionary *)params;
+ (void)saveMatches:(NSArray *)matches;
+(void)deleteMatches;
@end
