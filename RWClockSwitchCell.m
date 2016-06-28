//
//  RWClockSwitchCell.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/11.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWClockSwitchCell.h"

@implementation RWClockSwitchCell

@synthesize clockSwitch;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        clockSwitch = [[UISwitch alloc] init];
        
        [self addSubview:clockSwitch];
        
        [clockSwitch addTarget:self action:@selector(SwitchClick:Events:) forControlEvents:UIControlEventTouchUpInside|
                             UIControlEventTouchDragInside];
    }
    
    return self;
}

- (void)SwitchClick:(UISwitch *)cellSwitch Events:(UIControlEvents)events
{
    [self.delegate clockSwitch:cellSwitch ClickWithEvents:events];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [clockSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@(50));
        make.height.equalTo(@(30));
        make.right.equalTo(self.mas_right).offset(-30);
        make.centerY.equalTo(self.mas_centerY).offset(0);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
