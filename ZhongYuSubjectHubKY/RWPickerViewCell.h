//
//  RWPickerViewCell.h
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/24.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RWClockPickView.h"

@interface RWPickerViewCell : UITableViewCell

@property (nonatomic,assign)RWClockPickerType type;

@property (nonatomic,strong)RWClockPickView *pickerView;

@property (nonatomic,strong)NSDictionary *contexts;

@end
