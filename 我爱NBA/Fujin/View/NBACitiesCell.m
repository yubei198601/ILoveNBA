//
//  NBACitiesCell.m
//  我爱NBA
//
//  Created by philipyu on 15/12/30.
//  Copyright © 2015年 com.philipyu. All rights reserved.
//

#import "NBACitiesCell.h"

@implementation NBACitiesCell
+(instancetype)CitiesCellWithTableview:(UITableView*)tableview
{
    static NSString *identifier = @"cities";
    NBACitiesCell *cell = [tableview dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell = (NBACitiesCell *)[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
@end
