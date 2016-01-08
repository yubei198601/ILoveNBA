//
//  NBADropdownView.h
//  我爱NBA
//
//  Created by philipyu on 15/12/23.
//  Copyright © 2015年 com.philipyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBADropdownView : UIView
//@property (nonatomic,weak) UILabel *cityLabel;
@property (nonatomic,strong) NSMutableArray *zones;
+(instancetype)Dropdown;
-(void)refresh;
@end
