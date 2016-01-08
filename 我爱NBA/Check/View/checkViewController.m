//
//  checkTViewController.m
//  我爱NBA
//
//  Created by philipyu on 15/12/7.
//  Copyright (c) 2015年 com.philipyu. All rights reserved.
//

#import "checkViewController.h"
#import "Masonry.h"
#import "AFNetworking.h"

#define kTeamCheckString  @"http://op.juhe.cn/onebox/basketball/team"
#define kAppKey  @"84be4344aa88257a0bc6ab2ea3bbb286"

@interface checkViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic,strong) UITableView *checktableview;
@property (nonatomic,strong) UISearchBar *searchBar;
@end

@implementation checkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    /**设置导航栏的内容*/
    self.navigationItem.title = @"赛事查询";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(back)];
    
    /**创建search bar*/
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.placeholder = @"请输入球队名";
//    searchBar.backgroundColor = [UIColor redColor];
//    searchBar.showsCancelButton = YES;
//    searchBar.alpha = 0.3;
//    self.tableView.tableHeaderView = searchBar;
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    self.searchBar = searchBar;
    
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(64);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(@40);
    }];
    
    /**添加UITableview*/
    UITableView *checktableview = [[UITableView alloc]init];
    [self.view addSubview:checktableview];
    self.checktableview = checktableview;
    [checktableview mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.mas_equalTo(searchBar.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(@400);
    }];
    
    
    [self testCheckData];

}

-(void)testCheckData
{
    AFHTTPRequestOperationManager *mgr = [[AFHTTPRequestOperationManager alloc]init];
    NSString *url = kTeamCheckString;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"] = kAppKey;
    params[@"team"] = @"湖人";
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"qingqiuchenggong");
        NSLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"qingqiushibai");
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"check view controller---didReceiveMemoryWarning");
    // Dispose of any resources that can be recreated.
}


#pragma mark - searchbar的代理方法
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"searchBarCancelButtonClicked----");
    [self.searchBar  resignFirstResponder];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"-----searchBarTextDidBeginEditing");
//    隐藏navigation bar
//    __block CGRect tempFrame;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [UIView animateWithDuration:1.0 animations:^{
//        
//        tempFrame = self.searchBar.frame;
//        tempFrame.origin.y= 0;
//        self.searchBar.frame = tempFrame;
//
//    }];
    
    //添加蒙板的view
    UIView *coverView =[[ UIView alloc]init];
    coverView.backgroundColor = [UIColor greenColor];
    coverView.alpha = 0.3;
    [self.view addSubview:coverView];
    
    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchBar.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}


-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"-----searchBarTextDidEndEditing");
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"-----textDidChange %@",searchText);
    if (searchText.length == 0) {
        [searchBar resignFirstResponder];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
