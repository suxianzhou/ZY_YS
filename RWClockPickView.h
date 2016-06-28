//
//  RWClockPickView.h
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/12.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,RWClockPickerType) {
    
    RWClockPickerTypeOfWeek     = 1 << 3,
    RWClockPickerTypeOfTime     = 1 << 4,
    RWClockPickerTypeOfCycle    = 1 << 5,
    RWClockPickerTypeOfDate     = 1 << 6
};

typedef NS_ENUM(NSInteger ,RWClockDaysCount) {
    
    RWClockDaysCountOf31    = 2,
    RWClockDaysCountOf30    = 3,
    RWClockDaysCountOf28    = 4,
    RWClockDaysCountOf29    = 5
};

@class RWClockPickView;

@protocol RWClockPickViewDelegate <NSObject>

@optional

- (void)pickerView:(RWClockPickView *)pickerView CertainClickOfContext:(NSString *)context;

- (void)pickerView:(RWClockPickView *)pickerView CancelClickOfType:(RWClockPickerType)type;

@end

@interface RWClockPickView : UIView

+ (instancetype)pickerViewWithFrame:(CGRect)frame PickerViewType:(RWClockPickerType)type Delegate:(id)anyObject Context:(NSDictionary *)context;

@property (nonatomic,assign)id<RWClockPickViewDelegate> delegate;

@property (nonatomic,assign)RWClockPickerType type;

@property (nonatomic,strong)NSMutableDictionary *contexts;

@property (nonatomic,assign)BOOL addTopButton;

@end
