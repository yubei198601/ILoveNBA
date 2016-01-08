//
//  NBADescAnnotationModel.h
//  我爱NBA
//
//  Created by philipyu on 15/12/18.
//  Copyright © 2015年 com.philipyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MAMapKit/MAMapKit.h>

@class NBAAnnotationModel;

@interface NBADescAnnotation : NSObject<MAAnnotation>
//经纬度
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
//数据模型
@property (nonatomic,strong) NBAAnnotationModel *anno;
//篮球场名字
@property (nonatomic,copy) NSString *name;
//篮球场地址
@property (nonatomic,copy) NSString *address;
//篮球场电话号码
@property (nonatomic,copy) NSString *phone;
@end
