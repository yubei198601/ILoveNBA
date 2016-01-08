//
//  NBADropdownView.m
//  我爱NBA
//
//  Created by philipyu on 15/12/23.
//  Copyright © 2015年 com.philipyu. All rights reserved.
//

#import "NBADropdownView.h"
#import "NBAConst.h"
#import "NBARegion.h"
#import "NBACity.h"

@interface NBADropdownView()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *maintable;
@property (weak, nonatomic) IBOutlet UITableView *subtable;
@property (nonatomic,strong) NSArray *categorys;

@property (nonatomic,assign) NSInteger selectIdx;
@end

@implementation NBADropdownView

+(instancetype)Dropdown
{
    
    return [[NSBundle mainBundle]loadNibNamed:@"NBADropdownView" owner:nil options:nil][0];
}

-(void)refresh
{
    [self.maintable reloadData];
    
    [self.subtable reloadData];
}

//懒加载
//-(NSMutableArray*)zones
//{
//    if (_zones == nil)
//    {
//
//    
//    }
//    return _zones;
//}

-(void)awakeFromNib
{
    _categorys = @[@"全部",@"按区域分",@"按距离分",@"按预订分"];
//    _zones = @[@"全部",@"福田区",@"南山区",@"罗湖区",@"宝安区",@"龙岗区"];

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.maintable)
    {
        return _categorys.count;
    }
    else
    {
        if (self.selectIdx == 1)
        {
            return _zones.count;
        }
        return 0;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (tableView == self.maintable)
    {
        static NSString *iden = @"main";
        cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        }
        cell.textLabel.text = _categorys[indexPath.row];
        cell.textLabel.font =[UIFont boldSystemFontOfSize:14];
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_dropdown_leftpart"]];
        [cell.textLabel setTextColor:[UIColor lightGrayColor]];
        
    }
    else
    {
        static NSString *iden = @"sub";
        cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        }
        
        cell.textLabel.font =[UIFont boldSystemFontOfSize:14];
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_dropdown_rightpart"]];
        
        [cell.textLabel setTextColor:[UIColor lightGrayColor]];
        if (self.selectIdx == 1)
        {
            NBARegion *region = _zones[indexPath.row];
            cell.textLabel.text = region.name;
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.maintable == tableView)
    {
        self.selectIdx = indexPath.row;
        [self.subtable reloadData];
        if (self.selectIdx == 0)  //全部数据
        {
            NSDictionary *dict = @{NBAZoneName:kAllSort};
            [NBANotificationCenter postNotificationName:NBAChangeZoneNotification object:nil userInfo:dict];
        }
        else if (self.selectIdx == 2)//按距离排序
        {
            NSDictionary *dict = @{NBAZoneName:kDistanceSort};
            [NBANotificationCenter postNotificationName:NBAChangeZoneNotification object:nil userInfo:dict];
        }
        else if (self.selectIdx == 3)//按预订排序
        {
            NSDictionary *dict = @{NBAZoneName:kOrderSort};
            [NBANotificationCenter postNotificationName:NBAChangeZoneNotification object:nil userInfo:dict];
        }
    }
    else
    {
        if (self.selectIdx == 1)
        {
//        返回原来的界面
            NBARegion *region = _zones[indexPath.row];
          NSDictionary *dict = @{NBAZoneName:region.name};
          [NBANotificationCenter postNotificationName:NBAChangeZoneNotification object:nil userInfo:dict];
            
        }
    }
}
@end
