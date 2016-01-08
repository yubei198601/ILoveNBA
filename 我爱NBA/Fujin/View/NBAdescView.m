//
//  NBAdescView.m
//  我爱NBA
//
//  Created by philipyu on 15/12/18.
//  Copyright © 2015年 com.philipyu. All rights reserved.
//

#import "NBAdescView.h"

#define kArrorHeight        10
#define  kMagrinX   10
#define  kMagrinY   5
#define  kHeight    20
#define  kWidth     180

#define kBoundsW    200
#define kBoundsH    80

@implementation NBAdescView

- (void)drawRect:(CGRect)rect
{
    
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
}

- (void)drawInContext:(CGContextRef)context
{
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.8].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
    
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    
    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.font = [UIFont boldSystemFontOfSize:14];
        nameLabel.textColor = [UIColor redColor];
        self.nameLabel = nameLabel;
        [self addSubview:nameLabel];
        
        UILabel *addressLabel = [[UILabel alloc]init];
        addressLabel.font = [UIFont boldSystemFontOfSize:12];
        addressLabel.textColor = [UIColor greenColor];
        self.addressLabel = addressLabel;
        [self addSubview:addressLabel];
        
        UILabel *phoneLabel = [[UILabel alloc]init];
        phoneLabel.font = [UIFont boldSystemFontOfSize:10];
        phoneLabel.textColor = [UIColor blueColor];
        self.phoneLabel = phoneLabel;
        [self addSubview:phoneLabel];
        
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//-(void)setNameLabel:(UILabel *)nameLabel
//{
//    _nameLabel.text 
//}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.bounds = CGRectMake(0, 0, kBoundsW, kBoundsH);
    self.nameLabel.frame = CGRectMake(kMagrinX, kMagrinY, kWidth, kHeight);
    self.addressLabel.frame = CGRectMake(kMagrinX, kMagrinY*2+kHeight, kWidth, kHeight);
    self.phoneLabel.frame = CGRectMake(kMagrinX, kMagrinY*3+kHeight*2, kWidth, kHeight);
}


@end
