//
//  NBAAnnotationModel.h
//  我爱NBA
//
//  Created by philipyu on 15/12/17.
//  Copyright © 2015年 com.philipyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface NBAAnnotationModel : NSObject
//篮球场名字
@property (nonatomic,copy) NSString *name;
//篮球场地址
@property (nonatomic,copy) NSString *address;
//篮球场电话号码
@property (nonatomic,copy) NSString *phone;
//篮球场经纬度
@property (nonatomic,assign) CLLocationCoordinate2D Coordinate;
@end
