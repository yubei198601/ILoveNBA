//
//  NBAtitleView.m
//  我爱NBA
//
//  Created by philipyu on 15/12/23.
//  Copyright © 2015年 com.philipyu. All rights reserved.
//

#import "NBAtitleView.h"
@interface NBAtitleView ()
@property (weak, nonatomic) IBOutlet UIButton *sortBtn;

@end

@implementation NBAtitleView

-(void)addTarget:(nullable id)target action:(nonnull SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.sortBtn addTarget:target action:action forControlEvents:controlEvents];
}

+(_Nonnull instancetype)titleView
{
    return [[NSBundle mainBundle]loadNibNamed:@"NBAtitleView" owner:nil options:nil][0];
}

@end
