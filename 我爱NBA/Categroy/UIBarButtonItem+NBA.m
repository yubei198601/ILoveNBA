//
//  UIBarButtonItem+NBA.m
//  我爱NBA
//
//  Created by philipyu on 15/12/24.
//  Copyright © 2015年 com.philipyu. All rights reserved.
//

#import "UIBarButtonItem+NBA.h"
#import "UIView+Extension.h"

@implementation UIBarButtonItem (NBA)
+(nonnull UIBarButtonItem *)itemWithTarget:(nullable id)target action:(nonnull SEL)select image:(nonnull NSString *)image highlightimage:(nonnull NSString *)highlightimage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highlightimage] forState:UIControlStateHighlighted];
    btn.size = btn.currentBackgroundImage.size;
    [btn addTarget:target action:select forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
   
}
@end
