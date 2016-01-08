//
//  checkTeamCell.m
//  我爱NBA
//
//  Created by philipyu on 15/12/9.
//  Copyright (c) 2015年 com.philipyu. All rights reserved.
//

#import "checkTeamCell.h"
#import "checkTeamModel.h"
#import "UIImageView+WebCache.h"

@interface checkTeamCell()
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *player1icon;
@property (weak, nonatomic) IBOutlet UILabel *player1name;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *player2name;
@property (weak, nonatomic) IBOutlet UIImageView *player2icon;
@property (weak, nonatomic) IBOutlet UIImageView *videoicon;

@property (weak, nonatomic) IBOutlet UIButton *linkplay;
- (IBAction)linkplayClick:(UIButton *)sender;



@end

@implementation checkTeamCell

+(instancetype)cellWithTableview:(UITableView *)tableView
{
    static NSString *ID = @"CheckTeamcell";
    checkTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
       cell = [[NSBundle mainBundle]loadNibNamed:@"checkTeamCell" owner:nil options:nil][0];
    }
    
    return cell;
}

- (void)awakeFromNib
{
    // Initialization code
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTeamModel:(checkTeamModel *)teamModel
{
    _teamModel = teamModel;

    self.time.text = teamModel.m_time;
    
    [self.player1icon sd_setImageWithURL:[NSURL URLWithString:teamModel.player1logo] placeholderImage:nil];
    self.player1name.text = teamModel.player1;
    
    [self.player2icon sd_setImageWithURL:[NSURL URLWithString:teamModel.player2logo] placeholderImage:nil];
    self.player2name.text = teamModel.player2;
    
    self.score.text = teamModel.score;
    
    [self.linkplay setTitle:teamModel.link1text forState:UIControlStateNormal];
    
    
    self.cellheight = CGRectGetMaxY(self.time.frame) + 12;
}


- (IBAction)linkplayClick:(UIButton *)sender {
    //跳转页面
    if([self.delegate respondsToSelector:@selector(checkTeamCell:)])
        [self.delegate checkTeamCell:self.teamModel];
}
@end
