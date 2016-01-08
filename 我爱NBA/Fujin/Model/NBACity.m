//
//  MTCity.m
//  美团HD
//
//  Created by apple on 14/11/23.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "NBACity.h"
#import "MJExtension.h"
#import "NBARegion.h"

@implementation NBACity
- (NSDictionary *)objectClassInArray
{
    return @{@"regions" : [NBARegion class]};
}
@end
