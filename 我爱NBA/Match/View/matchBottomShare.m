//
//  matchBottomShare.m
//  我爱NBA
//
//  Created by philipyu on 15/12/14.
//  Copyright © 2015年 com.philipyu. All rights reserved.
//

#import "matchBottomShare.h"
#import "NBAConst.h"

@interface matchBottomShare()

@property (weak, nonatomic) IBOutlet UIButton *wechatButton;
@property (weak, nonatomic) IBOutlet UIButton *weiboButton;

@end

@implementation matchBottomShare


- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"matchBottomShare" owner:nil options:nil]lastObject];
    }
    return self;
}

-(void)addWechatTarget:(id)target action:(SEL)action
{
   [self.wechatButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

-(void)addWeiboTarget:(id)target action:(SEL)action
{
    [self.weiboButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}


@end
