//
//  RWPickerViewCell.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/24.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWPickerViewCell.h"

@implementation RWPickerViewCell

@synthesize pickerView;

- (void)setType:(RWClockPickerType)type
{
    _type = type;
    
    if (_type == RWClockPickerTypeOfDate)
    {
        
        [self initDatePicker];
    }
    else if (_type == RWClockPickerTypeOfTime)
    {
     
        [self initTimePicker];
    }
}

- (void)setContexts:(NSDictionary *)contexts
{
    _contexts = contexts;
    
    if (contexts.count != 0)
    {
        pickerView.contexts = [_contexts mutableCopy];
    }
}

- (void)initDatePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy年"];
    
    NSString *year = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"MM月"];
    
    NSString *month = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"dd日"];
    
    NSString *day = [dateFormatter stringFromDate:[NSDate date]];
    
    pickerView = [RWClockPickView pickerViewWithFrame:
                  CGRectMake(0, 0, self.frame.size.width,
                             self.frame.size.height)
                                       PickerViewType:RWClockPickerTypeOfDate
                                             Delegate:self
                                              Context:@{@"0":year,@"1":month,@"2":day}];
    
    pickerView.addTopButton = NO;
    
    [self addSubview:pickerView];
}

- (void)initTimePicker
{
    pickerView = [RWClockPickView pickerViewWithFrame:CGRectMake(0, 0,
                                                                 self.frame.size.width,
                                                                 self.frame.size.height)
                          PickerViewType:RWClockPickerTypeOfTime
                                Delegate:self
                                 Context:@{@"0":@"8",
                                           @"1":@"00"}];
    
    pickerView.addTopButton = NO;
    
    [self addSubview:pickerView];
}

@end
