//
//  NBAFieldButton.m
//  我爱NBA
//
//  Created by philipyu on 15/12/30.
//  Copyright © 2015年 com.philipyu. All rights reserved.
//

#import "NBAFieldButton.h"

@implementation NBAFieldButton
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //label
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        self.textlabel = label;
        [self addSubview:label];
        
        //icon
        UIImageView *imageview = [[UIImageView alloc]init];
        self.imageIcon = imageview;
        [self addSubview:imageview];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.textlabel.frame = CGRectMake(frame.size.width/3, 0, frame.size.width*2/3, frame.size.height);
    self.imageIcon.frame = CGRectMake(0, 0, frame.size.width/3, frame.size.height);

}

-(void)setTitle:(NSString *)title forState:(UIControlState)state
{
    self.textlabel.text = title;
}

-(void)setImage:(UIImage *)image forState:(UIControlState)state
{
//    if (state == UIControlStateNormal)
//    {
//        self.imageIcon.image = [UIImage imageNamed:@"btn_changeCity"];
//    }
//    else if(state == UIControlStateSelected)
//    {
//        self.imageIcon.image = [UIImage imageNamed:@"btn_changeCity_selected"];
    self.imageIcon.image = image;
//    }
}
@end
