//
//  NBAdescAnnotationView.h
//  我爱NBA
//
//  Created by philipyu on 15/12/18.
//  Copyright © 2015年 com.philipyu. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@class NBAdescView;
@interface NBAdescAnnotationView : MAAnnotationView


+(instancetype)descAnnotationViewWithMapview:(MAMapView*)mapview;
@end
