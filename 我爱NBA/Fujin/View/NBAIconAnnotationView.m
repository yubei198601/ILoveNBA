//
//  NBAIconAnnotationView.m
//  我爱NBA
//
//  Created by philipyu on 15/12/17.
//  Copyright © 2015年 com.philipyu. All rights reserved.
//

#import "NBAIconAnnotationView.h"

@implementation NBAIconAnnotationView

+(instancetype)IconAnnotationViewWithMapview:(MAMapView *)mapview
{
    static NSString *iconReuseIndentifier = @"iconReuseIndentifier";
    NBAIconAnnotationView *annotationView = (NBAIconAnnotationView*)[mapview dequeueReusableAnnotationViewWithIdentifier:iconReuseIndentifier];
    if (annotationView == nil)
    {
        annotationView = [[NBAIconAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:iconReuseIndentifier];
    }
    return annotationView;
}

-(void)setAnnotation:(id<MAAnnotation>)annotation
{
    self.image = [UIImage imageNamed:@"16*16.png"];
    [super setAnnotation:annotation];
}
@end
