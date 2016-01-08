//
//  NBAFieldTableCell.h
//  我爱NBA
//
//  Created by philipyu on 15/12/21.
//  Copyright © 2015年 com.philipyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NBAFieldTableModel;

@interface NBAFieldTableCell : UITableViewCell
@property (nonatomic,assign) CGFloat cellheight;
@property (nonatomic,strong) NBAFieldTableModel *cellModel;
+(instancetype)FieldTableCellWithTableview:(UITableView *)tableview;


@end
