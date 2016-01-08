//
//  NBAFieldModel.h
//  我爱NBA
//
//  Created by philipyu on 15/12/21.
//  Copyright © 2015年 com.philipyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface NBAFieldTableModel : NSObject
@property (nonatomic,copy)   NSString *name;
@property (nonatomic, copy)  NSString *district; //!< 区域名称
@property (nonatomic,copy)   NSString *address;
@property (nonatomic, copy)  NSString *tel;  //!< 电话
@property (nonatomic,strong) NSNumber *distance;
@property (nonatomic, copy)  NSString *businessArea; //!< 所在商圈
@property (nonatomic, copy)  AMapGeoPoint *location; //!< 经纬度
@end
/*
 
 // 基础信息
 @property (nonatomic, copy)   NSString     *uid; //!< POI全局唯一ID
 @property (nonatomic, copy)   NSString     *name; //!< 名称
 @property (nonatomic, copy)   NSString     *type; //!< 兴趣点类型
 @property (nonatomic, copy)   AMapGeoPoint *location; //!< 经纬度
 @property (nonatomic, copy)   NSString     *address;  //!< 地址
 @property (nonatomic, copy)   NSString     *tel;  //!< 电话
 @property (nonatomic, assign) NSInteger     distance; //!< 距中心点距离
 
 // 扩展信息
 @property (nonatomic, copy)   NSString     *postcode; //!< 邮编
 @property (nonatomic, copy)   NSString     *website; //!< 网址
 @property (nonatomic, copy)   NSString     *email;    //!< 电子邮件
 @property (nonatomic, copy)   NSString     *province; //!< 省
 @property (nonatomic, copy)   NSString     *pcode;   //!< 省编码
 @property (nonatomic, copy)   NSString     *city; //!< 城市名称
 @property (nonatomic, copy)   NSString     *citycode; //!< 城市编码
 @property (nonatomic, copy)   NSString     *district; //!< 区域名称
 @property (nonatomic, copy)   NSString     *adcode;   //!< 区域编码
 @property (nonatomic, copy)   NSString     *gridcode; //!< 地理格ID
 @property (nonatomic, copy)   AMapGeoPoint *enterLocation; //!< 入口经纬度
 @property (nonatomic, copy)   AMapGeoPoint *exitLocation; //!< 出口经纬度
 @property (nonatomic, copy)   NSString     *direction; //!< 方向
 @property (nonatomic, assign) BOOL          hasIndoorMap; //!< 是否有室内地图
 @property (nonatomic, copy)   NSString     *businessArea; //!< 所在商圈
 */