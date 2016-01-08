//
//  NBASortZoneController.m
//  我爱NBA
//
//  Created by philipyu on 15/12/23.
//  Copyright © 2015年 com.philipyu. All rights reserved.
//

#import "NBASortZoneController.h"
#import "NBAConst.h"

@interface NBASortZoneController ()

@end

@implementation NBASortZoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 240)];
    view.backgroundColor = [UIColor blueColor];
    [self.view addSubview: view];
}



@end
