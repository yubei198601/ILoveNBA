//
//  NBAFieldTableCell.m
//  我爱NBA
//
//  Created by philipyu on 15/12/21.
//  Copyright © 2015年 com.philipyu. All rights reserved.
//

#import "NBAFieldTableCell.h"
#import "NBAFieldTableModel.h"
@interface NBAFieldTableCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *districtLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (nonatomic, copy)  AMapGeoPoint *location; //!< 经纬度 *label;

@end

@implementation NBAFieldTableCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype)FieldTableCellWithTableview:(UITableView *)tableview
{
    static NSString *identifier = @"fieldcell";
    NBAFieldTableCell *cell = [tableview dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"NBAFieldTableCell" owner:nil options:nil]lastObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

-(void)setCellModel:(NBAFieldTableModel *)cellModel
{
    _cellModel = cellModel;
    self.nameLabel.text = cellModel.name;
    double distance = [cellModel.distance doubleValue];
    if( distance > 0.0)
    {
        [self.distanceLabel setHidden:NO];
        if (distance >= 1000)
        {
            self.distanceLabel.text = [NSString stringWithFormat:@"%.1f千米",distance/1000.0 ];
        }
        else
        {
            self.distanceLabel.text = [NSString stringWithFormat:@"%d米",(int)distance];
        }

    }
    else
    {
        [self.distanceLabel setHidden:YES];
    }
    
    if(cellModel.businessArea.length)
        self.districtLabel.text = cellModel.businessArea/*cellModel.district*/;
    else
        self.districtLabel.text = cellModel.district;

    self.addressLabel.text = cellModel.address;
    self.cellheight = CGRectGetMaxY(self.addressLabel.frame) + 10;
    self.location = cellModel.location;
//    self.
}

@end
