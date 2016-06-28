//
//  RWClockAttributeCell.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/12.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWClockAttributeCell.h"

@interface RWClockAttributeCell ()

@property (nonatomic ,strong)UILabel *nameLabel;

@property (nonatomic ,strong)UILabel *cycleLabel;

@property (nonatomic ,strong)UILabel *weekLabel;

@property (nonatomic ,strong)UILabel *timeLabel;

@end

@implementation RWClockAttributeCell

@synthesize nameLabel;
@synthesize cycleLabel;
@synthesize timeLabel;
@synthesize weekLabel;

- (void)setName:(NSString *)name
{
    _name = name;
    
    nameLabel.text = _name;
}

- (void)setWeek:(NSString *)week
{
    _week = week;
    
    weekLabel.text = _week;
}

- (void)setTime:(NSString *)time
{
    _time = time;
    
    timeLabel.text = _time;
}

- (void)setCycle:(NSString *)cycle
{
    _cycle = cycle;
    
    cycleLabel.text = _cycle;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.mas_right).offset(-30);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.equalTo(@(50));
    }];
    
    [weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(timeLabel.mas_left).offset(-10);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.equalTo(@(50));
    }];
    
    [cycleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(weekLabel.mas_left).offset(-10);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.equalTo(@(50));
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.right.equalTo(cycleLabel.mas_left).offset(-10);
    }];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        nameLabel = [[UILabel alloc] init];
        
        nameLabel.font = [UIFont systemFontOfSize:16];
        
        [self addSubview:nameLabel];
        
        cycleLabel = [[UILabel alloc] init];
        
        cycleLabel.font = [UIFont systemFontOfSize:14];
        
        cycleLabel.textAlignment = NSTextAlignmentCenter;
        
        cycleLabel.textColor = [UIColor grayColor];
        
        [self addSubview:cycleLabel];
        
        weekLabel = [[UILabel alloc] init];
        
        weekLabel.font = [UIFont systemFontOfSize:14];
        
        weekLabel.textAlignment = NSTextAlignmentCenter;
        
        weekLabel.textColor = [UIColor grayColor];
        
        [self addSubview:weekLabel];
        
        timeLabel = [[UILabel alloc] init];
        
        timeLabel.font = [UIFont systemFontOfSize:14];
        
        timeLabel.textAlignment = NSTextAlignmentCenter;
        
        timeLabel.textColor = [UIColor grayColor];
        
        [self addSubview:timeLabel];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
