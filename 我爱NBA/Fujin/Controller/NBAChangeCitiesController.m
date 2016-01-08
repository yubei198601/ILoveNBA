//
//  NBAChangeCitiesController.m
//  我爱NBA
//
//  Created by philipyu on 15/12/30.
//  Copyright © 2015年 com.philipyu. All rights reserved.
//

#import "NBAChangeCitiesController.h"
#import "MJExtension.h"
#import "NBACityGroup.h"
#import "NBAConst.h"
#import "NBACitiesCell.h"

@interface NBAChangeCitiesController()
@property (nonatomic,strong) NSArray *citiesGroupArray;
@end

@implementation NBAChangeCitiesController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置导航栏
    self.title = @"切换城市";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"icon_back" highlightimage:@"icon_back_highlighted"];
    
    // 加载城市数据
    self.citiesGroupArray = [NBACityGroup objectArrayWithFilename:@"cityGroups.plist"];
}

-(void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.citiesGroupArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NBACityGroup *group = self.citiesGroupArray[section];
    return group.cities.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NBACitiesCell *cell = [NBACitiesCell CitiesCellWithTableview:tableView];
    NBACityGroup *group = self.citiesGroupArray[indexPath.section];

    cell.textLabel.text = group.cities[indexPath.row];
    
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NBACityGroup *group = self.citiesGroupArray[section];
    return group.title;
}

-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *titles = [NSMutableArray array];
    for (NBACityGroup *group in self.citiesGroupArray)
    {
        [titles addObject: group.title];
    }
    return titles;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //取出点击行的城市
    NBACityGroup *group = self.citiesGroupArray[indexPath.section];
    NSString *city = group.cities[indexPath.row];
    
    // 通知场地控制器去切换城市
    [NBANotificationCenter postNotificationName:NBAChangeCityNotification object:nil userInfo:@{NBACityName:city}];
    
    //dismiss掉当前控制器
    [self back];
}
@end
