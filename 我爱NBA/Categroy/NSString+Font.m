//
//  NSString+Font.m
//  我爱NBA
//
//  Created by philipyu on 15/11/25.
//  Copyright (c) 2015年 com.philipyu. All rights reserved.
//

#import "NSString+Font.h"

@implementation NSString (Font)
+(CGSize)sizeWithString:(NSString*)string font:(UIFont*)font
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = font;
    CGSize size = [string sizeWithAttributes:dict];
    return size;
}

-(CGSize)sizeWithString:(NSString*)string font:(UIFont*)font maxsize:(CGSize)maxsize
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = font;
    
    CGSize size = [string sizeWithAttributes:dict];
    return size;
}

@end
