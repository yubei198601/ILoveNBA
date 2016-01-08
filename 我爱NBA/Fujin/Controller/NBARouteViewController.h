//
//  NBARouteViewController.h
//  我爱NBA
//
//  Created by philipyu on 15/12/18.
//  Copyright © 2015年 com.philipyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface NBARouteViewController : UIViewController
@property (nonatomic,assign) CLLocationCoordinate2D orignalCo;
@property (nonatomic,assign) CLLocationCoordinate2D targetCo;
@end
