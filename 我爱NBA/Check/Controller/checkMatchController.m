//
//  checkMatchController.m
//  我爱NBA
//
//  Created by philipyu on 15/12/9.
//  Copyright (c) 2015年 com.philipyu. All rights reserved.
//

#import "checkMatchController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "NBAConst.h"
#import "checkTeamCell.h"
#import "checkTeamModel.h"
#import "MJExtension.h"
#import "Masonry.h"
#import "checkTeamCell.h"
#import "NSString+Unicode.h"
#import "NBAcheckVideoController.h"

@interface checkMatchController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,checkTeamCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *teamText;
@property (weak, nonatomic) IBOutlet UITextField *hostNameText;
@property (weak, nonatomic) IBOutlet UITextField *guestNameText;
- (IBAction)teamCheckClick:(UIButton *)sender;
- (IBAction)fightCheckClick:(UIButton *)sender;
@property (nonatomic,strong) NSMutableArray *checkTeamModels;
@property (nonatomic,strong) NSMutableArray *nbaTeams;
@property (nonatomic,strong) checkTeamCell *cell;
@end

@implementation checkMatchController

//懒加载
-(NSMutableArray*)checkTeamModels
{
    if (_checkTeamModels == nil) {
        self.checkTeamModels = [NSMutableArray array];
    }
    return _checkTeamModels;
    
}

-(NSString *)replaceUnicode:(NSString *)unicodeStr {
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    
    //NSLog(@"Output = %@", returnStr);
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"赛事查询";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setHidden:YES];
    
    self.teamText.delegate = self;
    self.hostNameText.delegate = self;
    self.guestNameText.delegate = self;
    

    
    [self loadNBATeams];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)showMessage:(NSString*)str
{
    [MBProgressHUD showMessage:str];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
    });
}

-(void)loadNBATeams
{
    
        NSString *path = [[NSBundle mainBundle]pathForResource:@"team" ofType:@"plist"];
//        NSMutableArray *teams = [NSMutableArray array];
        if (path != nil)
        {
            NSMutableArray *teams = [[NSMutableArray alloc]initWithContentsOfFile:path];
             self.nbaTeams = teams;
        }
}

-(void)requestTeamDataWithBtn:(UIButton*)btn teamName:(NSString*)tname hostName:(NSString*)hname guestName:(NSString*)gname
{
    AFHTTPRequestOperationManager *mgr = [[AFHTTPRequestOperationManager alloc]init];
    NSString *url = nil;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"] = kAppKey;
    if (btn.tag == 1)
    {
        url = kTeamCheckString;
        params[@"team"] = tname;
    }
    else if(btn.tag == 2)
    {
        url = kFightCheckString;
        params[@"hteam"] = hname;
        params[@"vteam"] = gname;
    }
    
    
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求成功 \n %@",responseObject);
        if ([responseObject[@"error_code"] intValue] != 0)
        {
            [self showMessage:[NSString replaceUnicode:responseObject[@"reason"]]];
            NSLog(@"%@",[NSString replaceUnicode:responseObject[@"reason"]]);
            return;
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict = responseObject;

        NSLog(@"%@",dict[@"result"][@"list"]);

        NSArray *checkArray = [checkTeamModel objectArrayWithKeyValuesArray:dict[@"result"][@"list"]];
        
        if (self.checkTeamModels.count ) {
            [self.checkTeamModels removeAllObjects];
        }
        
        [self.checkTeamModels addObjectsFromArray:checkArray];
        
        [self.tableView setHidden:NO];
        [self.tableView reloadData];
        
//        NSLog(@"%@",self.checkTeamModels);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"qingqiushibai");
    }];
}

- (IBAction)teamCheckClick:(UIButton *)sender
{
    unsigned int i;
    [self.view endEditing:YES];
    if ([self.tableView isHidden] == NO) {
        [self.tableView setHidden:YES];
    }
    

    if(self.teamText.text.length == 0) {
        [self showMessage:@"请输入要查询的球队名字"];
    }
    else
    {

            for (i =0; i < self.nbaTeams.count; i++)
            {
                if([self.teamText.text isEqualToString:self.nbaTeams[i]])
                    break;
            }
            if (i == self.nbaTeams.count) {
                [self showMessage:@"输入的队名不存在，请重新输入"];

            }
            else
            {
                 //发送网络查询请求
                 [self requestTeamDataWithBtn:sender teamName:self.teamText.text hostName:nil guestName:nil];
            }
        

    }
    
}

- (IBAction)fightCheckClick:(UIButton *)sender
{
    NSUInteger i = 0,j = 0;
    [self.view endEditing:YES];
    if ([self.tableView isHidden] == NO) {
        [self.tableView setHidden:YES];
    }
    
    if (self.hostNameText.text.length == 0 || self.guestNameText.text.length == 0)
    {
        [self showMessage:@"没有输入主队名或者客队名,请重新输入"];

    }
    else
    {
            NSUInteger count =  self.nbaTeams.count;
            for (i =0; i < count; i++)
            {
                if([self.hostNameText.text isEqualToString:self.nbaTeams[i]])
                    break;
            }
            
            if (i == count)
            {
                [self showMessage:@"输入的主队名不存在，请重新输入"];

            }
            else
            {
                for (j = 0; j < count; j++)
                {
                    if([self.hostNameText.text isEqualToString:self.nbaTeams[i]])
                        break;
                }
                
                if (j == count)
                {
                    [self showMessage:@"输入的客队名不存在，请重新输入"];

                }
                else
                {
                    if ([self.hostNameText.text isEqualToString:self.guestNameText.text])
                    {
                        return;
                    }
                    // 发送网络查询请求
                    [self requestTeamDataWithBtn:sender teamName:nil hostName:self.hostNameText.text guestName:self.guestNameText.text];
                }
            }
        
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.checkTeamModels.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    checkTeamCell *cell = [checkTeamCell cellWithTableview:tableView];
    cell.teamModel = self.checkTeamModels[indexPath.row];
    self.cell = cell;
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cell.cellheight;
}

#pragma mark-textfield delegate method
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//    NBALog(@"textFieldDidBeginEditing-%@ %@",textField.textInputMode,NSStringFromCGRect(textField.inputView.frame));
    UIPickerView *pickerView = [[UIPickerView alloc]init];
    pickerView.dataSource = self;
    pickerView.delegate =self;
    
    textField.inputView = pickerView;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

#pragma mark-pick view delegate method
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
   return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"team" ofType:@"plist"];
//    self.nbaTeams = [[NSMutableArray alloc]initWithContentsOfFile:path];
   return self.nbaTeams.count;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.nbaTeams[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([self.teamText isFirstResponder])
    {
        self.teamText.text = self.nbaTeams[row];
    }
    else if([self.hostNameText isFirstResponder])
    {
        self.hostNameText.text = self.nbaTeams[row];
    }
    else if([self.guestNameText isFirstResponder])
    {
        self.guestNameText.text = self.nbaTeams[row];
    }
    
    pickerView = nil;
//    [self.teamText endEditing:YES];
}

#pragma mark---checkcell delegate
-(void)checkTeamCell:(checkTeamModel*)model
{
    //modal
    NBAcheckVideoController *vc=[[NBAcheckVideoController alloc]init];
    vc.biaoti = model.link1text;
    vc.url = model.link1url;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
@end
