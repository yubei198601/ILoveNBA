//
//  NBAIconAnnotation.h
//  我爱NBA
//
//  Created by philipyu on 15/12/17.
//  Copyright © 2015年 com.philipyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@class NBAAnnotationModel;

@interface NBAIconAnnotation : NSObject<MAAnnotation>
//经纬度
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
//数据模型
@property (nonatomic,strong) NBAAnnotationModel *anno;
@end
