//
//  UIBarButtonItem+NBA.h
//  我爱NBA
//
//  Created by philipyu on 15/12/24.
//  Copyright © 2015年 com.philipyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (NBA)
+(nonnull UIBarButtonItem*)itemWithTarget:(nullable id)target action:(nonnull SEL)select image:(nonnull NSString *)image highlightimage:(nonnull NSString *)highlightimage;
@end
