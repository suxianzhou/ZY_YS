//
//  RWClockSwitchCell.h
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/11.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RWClockSwitchDelegate <NSObject>

- (void)clockSwitch:(UISwitch *)clockSwitch ClickWithEvents:(UIControlEvents)events;

@end

@interface RWClockSwitchCell : UITableViewCell

@property (nonatomic,assign)id<RWClockSwitchDelegate> delegate;

@property (nonatomic,strong)UISwitch *clockSwitch;

@end
