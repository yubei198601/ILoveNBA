//
//  NBAFieldDetailViewController.m
//  我爱NBA
//
//  Created by philipyu on 15/12/22.
//  Copyright © 2015年 com.philipyu. All rights reserved.
//

#import "NBAFieldDetailViewController.h"

#import "NBAFieldTableModel.h"
#import "NBAConst.h"
#import "NBAFieldMapViewController.h"


#define kPadding   10
#define kHeight    30
@interface NBAFieldDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableview;
@end

@implementation NBAFieldDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置导航栏
    self.title = @"场馆详情";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"icon_back" highlightimage:@"icon_back_highlighted"];
    
    
    
    //添加控件
    CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.tableview = [[UITableView alloc]initWithFrame:rect style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.tag = 1;
    [self.view addSubview:self.tableview];

}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)popCallView
{
    if (self.fieldModel.tel.length == 0) {
        return;
    }
    NSString *msg = @"";
    
    if ([self.fieldModel.tel containsString:@";" ]) {
        NSRange range = [self.fieldModel.tel rangeOfString:@";"];
        msg = [self.fieldModel.tel substringToIndex:range.location];
    }
    else
    {
        msg = self.fieldModel.tel;
    }

    [self callPhone:msg];
}

-(void)jumpToPosition
{
    NBAFieldMapViewController *mapPosition = [[NBAFieldMapViewController alloc]init];
    mapPosition.fieldModel = self.fieldModel;
    [self.navigationController pushViewController:mapPosition animated:YES];
}


- (void)callPhone:(NSString *)phoneNumber
{
    NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNumber];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

#pragma mark-
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.fieldModel.tel.length) {
        return 2;
    }
    else
    {
        return 1;
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1
                                                  reuseIdentifier:nil];

    //第一行显示电话号码，第二行显示地址
    if (row == 0)
    {
        if (self.fieldModel.tel.length)
        {
            cell.textLabel.text = @"电话";
            cell.detailTextLabel.text = self.fieldModel.tel;
        }
        else
        {
            cell.textLabel.text = @"地址";
            cell.detailTextLabel.text = self.fieldModel.address;
        }

     }
     else if (row == 1)
     {
         cell.textLabel.text = @"地址";
         cell.detailTextLabel.text = self.fieldModel.address;
     }
     cell.textLabel.font =  [UIFont boldSystemFontOfSize:14];
     cell.textLabel.textColor =  [UIColor grayColor];
     cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
     cell.detailTextLabel.textColor =  [UIColor blueColor];
     cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;

     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

     return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger length = self.fieldModel.tel.length;
    if (row == 0) {
        if (length)
        {
            [self popCallView];
        }
        else
        {
            [self jumpToPosition];
        }
    }
    else if (row == 1)
    {
        [self jumpToPosition];
    }
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UILabel *label  = [[UILabel alloc]init];
    label.bounds = CGRectMake(0, 0, self.view.bounds.size.width, 35);
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = self.fieldModel.name;
    label.textColor = [UIColor grayColor];
    return label;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
 
    UITableView *tableview = [self.view viewWithTag:1];
    tableview.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [tableview reloadData];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
}
@end
