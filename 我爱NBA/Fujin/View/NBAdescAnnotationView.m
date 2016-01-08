//
//  NBAdescAnnotationView.m
//  我爱NBA
//
//  Created by philipyu on 15/12/18.
//  Copyright © 2015年 com.philipyu. All rights reserved.
//

#import "NBAdescAnnotationView.h"
#import "NBAdescView.h"
#import "NBAIconAnnotation.h"
#import "NBAAnnotationModel.h"
#import "NBAConst.h"

@interface NBAdescAnnotationView()

@property (nonatomic,strong) NBAdescView *backView;

@end

@implementation NBAdescAnnotationView

+(instancetype)descAnnotationViewWithMapview:(MAMapView *)mapview
{
    static NSString *iconReuseIndentifier = @"iconReuseIndentifier";
    NBAdescAnnotationView *annotationView = (NBAdescAnnotationView*)[mapview dequeueReusableAnnotationViewWithIdentifier:iconReuseIndentifier];
    if (annotationView == nil)
    {
        annotationView = [[NBAdescAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:iconReuseIndentifier];
    }
    return annotationView;
}

-(id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier])
    {
        NBAdescView *backView = [[NBAdescView alloc]init];
        self.backView = backView;
        
        [self addSubview:backView];
        self.bounds = self.backView.bounds;
    }
    return self;
}

-(void)setAnnotation:(NBAIconAnnotation*)annotation
{
//    self.annotation = annotation;
    
    self.backView.nameLabel.text = annotation.anno.name;
    self.backView.phoneLabel.text = annotation.anno.phone;
    self.backView.addressLabel.text = annotation.anno.address;
 
    [super setAnnotation:annotation];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.y -= 48;
}
@end
