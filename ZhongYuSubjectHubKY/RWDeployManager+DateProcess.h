//
//  RWDeployManager+DateProcess.h
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/25.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWDeployManager.h"

@interface RWDeployManager (DateProcess)

- (NSString *)stringClockAttribute:(RWClockAttribute)clockAttribute;

- (RWClockAttribute)clockAttributeWithString:(NSString *)attributeString;

- (NSString *)stringClockWeek:(RWClockWeek)clockWeek;

- (RWClockWeek)clockWeekWithString:(NSString *)weekString;

- (NSString *)stringClockCycle:(RWClockCycle)cycle;

- (RWClockCycle)cycleWithString:(NSString *)cycleString;

- (NSString *)stringTimeWithClockAttribute:(RWClockAttribute)attribute;

- (BOOL)isPastTime:(NSInteger)hours minute:(NSInteger)minute;

- (NSInteger)daysFromClockTimeWithClockWeek:(RWClockWeek)week AndWeekString:(NSString *)weekString;

- (NSDate *)buildClockDateWithAfterDays:(NSInteger)afterDays Hours:(NSInteger)hours AndMinute:(NSInteger)minute;

- (RWMoment)momentWithDate:(NSDate *)systemDate;

- (NSDate *)dateWithRWMoment:(RWMoment)moment;

- (NSString *)stringRWTime:(RWTime)time;

- (RWTime)timeWithString:(NSString *)timeString;

- (NSString *)stringRWDate:(RWDate)date;

- (RWDate)dateWithString:(NSString *)dateString;

- (NSString *)stringRWMoment:(RWMoment)moment;

- (RWMoment)momentWithString:(NSString *)momentString;

- (NSInteger)distanceWithBeginMoments:(RWMoment)beginMoments AndEndMoments:(RWMoment)endMomends;

@end
