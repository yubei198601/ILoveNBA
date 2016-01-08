//
//  checkTeamCell.h
//  我爱NBA
//
//  Created by philipyu on 15/12/9.
//  Copyright (c) 2015年 com.philipyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class checkTeamModel;
@protocol checkTeamCellDelegate <NSObject>

@optional
-(void)checkTeamCell:(checkTeamModel*)model;

@end
@interface checkTeamCell : UITableViewCell


@property (nonatomic,assign) CGFloat cellheight;
@property (nonatomic,strong) checkTeamModel *teamModel;
@property (nonatomic,weak) id <checkTeamCellDelegate> delegate;

+(instancetype)cellWithTableview:(UITableView *)tableView;
@end
