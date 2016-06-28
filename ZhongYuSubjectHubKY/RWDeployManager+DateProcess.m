//
//  RWDeployManager+DateProcess.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/25.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWDeployManager+DateProcess.h"

NSInteger Log(NSInteger number)
{
    if (number <= 1)
    {
        return 0;
    }
    else
    {
        return Log(number >> 1) + 1;
    }
}

RWMoment growsYear(RWMoment moment,NSInteger growsTimes)
{
    if (growsTimes == 0)
    {
        return moment;
    }
    else
    {
        moment.date.year++;
        
        return growsYear(moment, growsTimes--);
    }
}

RWMoment growsMonth(RWMoment moment,NSInteger growsTimes)
{
    if (growsTimes <= 0)
    {
        return moment;
    }
    else
    {
        if (moment.date.month >= 12)
        {
            moment.date.month = 1;
            
            return growsMonth(growsYear(moment, 1), growsTimes--);
        }
        else
        {
            moment.date.month++;
            
            return growsMonth(moment, growsTimes--);
        }
    }
}

RWMoment growsDay(RWMoment moment,NSInteger growsTimes)
{
    if (growsTimes <= 0)
    {
        return moment;
    }
    else
    {
        if (moment.date.month == 4||moment.date.month == 6||
            moment.date.month == 9||moment.date.month == 11)
        {
            if (moment.date.day >= 30)
            {
                moment.date.day = 1;
                
                return growsDay(growsMonth(moment, 1), growsTimes--);
            }
            else
            {
                moment.date.day++;
                
                return growsDay(moment, growsTimes--);
            }
        }
        else if (moment.date.month == 2)
        {
            if ((moment.date.year % 4 == 0 && moment.date.year % 100 != 0) ||
                moment.date.year % 400 == 0)
            {
                if (moment.date.day >= 29)
                {
                    moment.date.day = 1;
                    
                    return growsDay(growsMonth(moment, 1), growsTimes--);
                }
                else
                {
                    moment.date.day++;
                    
                    return growsDay(moment, growsTimes--);
                }
            }
            else
            {
                if (moment.date.day >= 28)
                {
                    moment.date.day = 1;
                    
                    return growsDay(growsMonth(moment, 1), growsTimes--);
                }
                else
                {
                    moment.date.day++;
                    
                    return growsDay(moment, growsTimes--);
                }
            }
        }
        else
        {
            if (moment.date.day >= 31)
            {
                moment.date.day = 1;
                
                return growsDay(growsMonth(moment, 1), growsTimes--);
            }
            else
            {
                moment.date.day++;
                
                return growsDay(moment, growsTimes--);
            }
        }
    }
}

RWMoment growsHour(RWMoment moment,NSInteger growsTimes)
{
    if (growsTimes <= 0)
    {
        return moment;
    }
    else
    {
        if (moment.time.hours >= 23)
        {
            moment.time.hours = 0;
            
            return growsHour(growsDay(moment, 1), growsTimes--);
        }
        else
        {
            moment.time.hours++;
            
            return growsHour(moment, growsTimes--);
        }
    }
}

RWMoment growsMinute(RWMoment moment,NSInteger growsTimes)
{
    if (growsTimes <= 0)
    {
        return moment;
    }
    else
    {
        if (moment.time.minute >= 59)
        {
            moment.time.minute = 0;
            
            return growsMinute(growsHour(moment, 1), growsTimes--);
        }
        else
        {
            moment.time.minute++;
            
            return growsMinute(moment, growsTimes--);
        }
    }
}

RWMoment growsSecond(RWMoment moment,NSInteger growsTimes)
{
    if (growsTimes <= 0)
    {
        return moment;
    }
    else
    {
        if (moment.time.second >= 59)
        {
            moment.time.second = 0;
            
            return growsSecond(growsMinute(moment, 1), growsTimes--);
        }
        else
        {
            moment.time.second++;
            
            return growsSecond(moment, growsTimes--);
        }
    }
}


RWMoment decreaseYear(RWMoment moment,NSInteger decreaseTimes)
{
    if (decreaseTimes == 0)
    {
        return moment;
    }
    else
    {
        moment.date.year--;
        
        return decreaseYear(moment, decreaseTimes--);
    }
}

RWMoment decreaseMonth(RWMoment moment,NSInteger decreaseTimes)
{
    if (decreaseTimes <= 0)
    {
        return moment;
    }
    else
    {
        if (moment.date.month <= 1)
        {
            moment.date.month = 12;
            
            return decreaseMonth(decreaseYear(moment, 1), decreaseTimes--);
        }
        else
        {
            moment.date.month--;
            
            return decreaseMonth(moment, decreaseTimes--);
        }
    }
    
}

RWMoment decreaseDay(RWMoment moment,NSInteger decreaseTimes)
{
    if (decreaseTimes <= 0)
    {
        return moment;
    }
    else
    {
        if (moment.date.day <= 1)
        {
            if (moment.date.month == 5||moment.date.month == 7||
                moment.date.month == 10||moment.date.month == 12)
            {
                moment.date.day = 30;
                
                return decreaseDay(decreaseMonth(moment, 1), decreaseTimes--);
            }
            else if (moment.date.month == 3)
            {
                if ((moment.date.year % 4 == 0 && moment.date.year % 100 != 0) ||
                    moment.date.year % 400 == 0)
                {
                    moment.date.day = 29;
                    
                    return decreaseDay(decreaseMonth(moment, 1), decreaseTimes--);
                }
                else
                {
                    moment.date.day = 28;
                    
                    return decreaseDay(decreaseMonth(moment, 1), decreaseTimes--);
                }
            }
            else
            {
                moment.date.day = 31;
                
                return decreaseDay(decreaseMonth(moment, 1), decreaseTimes--);
            }
            
        }
        else
        {
            moment.date.day--;
            
            return decreaseDay(moment, decreaseTimes--);
        }
    }
}

RWMoment decreaseHour(RWMoment moment,NSInteger decreaseTimes)
{
    if (decreaseTimes <= 0)
    {
        return moment;
    }
    else
    {
        if (moment.time.hours <= 0)
        {
            moment.time.hours = 23;
            
            return decreaseHour(decreaseDay(moment, 1), decreaseTimes--);
        }
        else
        {
            moment.time.hours--;
            
            return decreaseHour(moment, decreaseTimes--);
        }
    }
}

RWMoment decreaseMinute(RWMoment moment,NSInteger decreaseTimes)
{
    if (decreaseTimes <= 0)
    {
        return moment;
    }
    else
    {
        if (moment.time.minute <= 0)
        {
            moment.time.minute = 59;
            
            return decreaseMinute(decreaseHour(moment, 1), decreaseTimes--);
        }
        else
        {
            moment.time.minute--;
            
            return decreaseMinute(moment, decreaseTimes--);
        }
    }
    
}

RWMoment decreaseSecond(RWMoment moment,NSInteger decreaseTimes)
{
    if (decreaseTimes <= 0)
    {
        return moment;
    }
    else
    {
        if (moment.time.second <= 0)
        {
            moment.time.second = 59;
            
            return decreaseSecond(decreaseMinute(moment, 1), decreaseTimes--);
        }
        else
        {
            moment.time.second--;
            
            return decreaseSecond(moment, decreaseTimes--);
        }
    }
}

RWDate RWDateMake(NSInteger year, NSInteger month, NSInteger day)
{
    RWDate date; date.year = year; date.month = month; date.day = day; return date;
}

RWTime RWTimeMake(NSInteger hours ,NSInteger minute ,NSInteger second)
{
    RWTime time; time.hours = hours; time.minute = minute; time.second = second;
    return time;
}

RWMoment RWMomentMake(NSInteger year, NSInteger month, NSInteger day, NSInteger hours ,NSInteger minute ,NSInteger second,RWClockWeek week)
{
    RWMoment moment;
    
    moment.date = RWDateMake(year, month, day);
    
    moment.time = RWTimeMake(hours, minute, second);
    
    moment.week = week;
    
    return moment;
}

RWClockAttribute RWClockAttributeMake(RWClockCycle  cycleType ,
                                      RWClockWeek   week ,
                                      NSInteger     hours ,
                                      NSInteger     minute )
{
    RWClockAttribute clockAttribute;
    
    clockAttribute.cycleType = cycleType;
    
    clockAttribute.hours = hours;
    
    clockAttribute.minute = minute;
    
    clockAttribute.week = week;
    
    return clockAttribute;
}

@implementation RWDeployManager (DateProcess)

- (NSString *)stringClockAttribute:(RWClockAttribute)clockAttribute
{
    return [NSString stringWithFormat:@"%d%d#%d:%d",(int)clockAttribute.week,
            (int)clockAttribute.cycleType,
            (int)clockAttribute.hours,
            (int)clockAttribute.minute];
}

- (RWClockAttribute)clockAttributeWithString:(NSString *)attributeString
{
    NSArray *attributes = [attributeString componentsSeparatedByString:@"#"];
    
    NSInteger type,week;
    
    if ([[attributes firstObject] integerValue] / 10 > 0)
    {
        type = [[attributes firstObject] integerValue] % 10;
        
        week = [[attributes firstObject] integerValue] / 10;
    }
    else
    {
        type = [[attributes firstObject] integerValue];
        
        week = 0;
    }
    
    NSArray *timeStrings = [[attributes lastObject] componentsSeparatedByString:@":"];
    
    NSInteger hours = [[timeStrings firstObject] integerValue];
    
    NSInteger minutes = [[timeStrings lastObject] integerValue];
    
    return RWClockAttributeMake(type, week, hours, minutes);
}

- (NSString *)stringClockWeek:(RWClockWeek)clockWeek
{
    switch (clockWeek) {
            
        case RWClockWeekOfMonday:       return @"星期一";
            
        case RWClockWeekOfTuesday:      return @"星期二";
            
        case RWClockWeekOfWednesday:    return @"星期三";
            
        case RWClockWeekOfThursday:     return @"星期四";
            
        case RWClockWeekOfFriday:       return @"星期五";
            
        case RWClockWeekOfSaturday:     return @"星期六";
            
        case RWClockWeekOfSunday:       return @"星期日";
            
        default:                        return @"无";
    }
}

- (RWClockWeek)clockWeekWithString:(NSString *)weekString
{
    if ([weekString isEqualToString:@"星期一"]||
        [weekString isEqualToString:@"Monday"])
    {
        return RWClockWeekOfMonday;
    }
    else if ([weekString isEqualToString:@"星期二"]||
             [weekString isEqualToString:@"Tuesday"])
    {
        return RWClockWeekOfTuesday;
    }
    else if ([weekString isEqualToString:@"星期三"]||
             [weekString isEqualToString:@"Wednesday"])
    {
        return RWClockWeekOfWednesday;
    }
    else if ([weekString isEqualToString:@"星期四"]||
             [weekString isEqualToString:@"Thursday"])
    {
        return RWClockWeekOfThursday;
    }
    else if ([weekString isEqualToString:@"星期五"]||
             [weekString isEqualToString:@"Friday"])
    {
        return RWClockWeekOfFriday;
    }
    else if ([weekString isEqualToString:@"星期六"]||
             [weekString isEqualToString:@"Saturday"])
    {
        return RWClockWeekOfSaturday;
    }
    else if ([weekString isEqualToString:@"星期日"]||
             [weekString isEqualToString:@"Sunday"])
    {
        return RWClockWeekOfSunday;
    }
    
    return RWClockWeekOfNone;
}

- (NSString *)stringClockCycle:(RWClockCycle)cycle
{
    switch (cycle) {
            
        case RWClockCycleEveryDay:      return @"每天";
            
        case RWClockCycleEveryWeek:     return @"每周";
            
        default:                        return @"无";
    }
}

- (RWClockCycle)cycleWithString:(NSString *)cycleString
{
    if ([cycleString isEqualToString:@"每天"])
    {
        return RWClockCycleEveryDay;
    }
    else if ([cycleString isEqualToString:@"每周"])
    {
        return RWClockCycleEveryWeek;
    }
    
    return RWClockCycleOnce;
}

- (NSString *)stringTimeWithClockAttribute:(RWClockAttribute)attribute
{
    return [NSString stringWithFormat:@"%d:%.2d",(int)attribute.hours,(int)attribute.minute];
}

- (NSInteger)daysFromClockTimeWithClockWeek:(RWClockWeek)week AndWeekString:(NSString *)weekString
{
    RWClockWeek faceWeek = [self clockWeekWithString:weekString];
    
    if (Log(week) - Log(faceWeek) < 0)
    {
        return 7 - (NSInteger)abs((int)(Log(week) - Log(faceWeek)));
    }
    else
    {
        return Log(week) - Log(faceWeek);
    }
}

- (BOOL)isPastTime:(NSInteger)hours minute:(NSInteger)minute
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"HH"];
    
    NSInteger faceHours = [[dateFormatter stringFromDate:[NSDate date]] integerValue];
    
    [dateFormatter setDateFormat:@"mm"];
    
    NSInteger faceMinute = [[dateFormatter stringFromDate:[NSDate date]] integerValue];
    
    if (faceHours > hours)
    {
        return YES;
    }
    
    if (faceHours == hours && faceMinute > minute)
    {
        return YES;
    }
    
    return NO;
}

- (NSDate *)buildClockDateWithAfterDays:(NSInteger)afterDays Hours:(NSInteger)hours AndMinute:(NSInteger)minute
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *year = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"MM"];
    NSString *month = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"dd"];
    NSString *day = [dateFormatter stringFromDate:[NSDate date]];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setYear:year.integerValue];
    [comps setMonth:month.integerValue];
    [comps setDay:day.integerValue + afterDays];
    [comps setHour:hours];
    [comps setMinute:minute];
    [comps setSecond:0];
    
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

- (NSDate *)dateWithRWMoment:(RWMoment)moment
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setYear:moment.date.year];
    [comps setMonth:moment.date.month];
    [comps setDay:moment.date.day];
    [comps setHour:moment.time.hours];
    [comps setMinute:moment.time.minute];
    [comps setSecond:moment.time.second];
    
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

- (RWMoment)momentWithDate:(NSDate *)systemDate
{
    RWDate date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy"];
    
    date.year = [dateFormatter stringFromDate:systemDate].integerValue;
    
    [dateFormatter setDateFormat:@"MM"];
    
    date.month = [dateFormatter stringFromDate:systemDate].integerValue;
    
    [dateFormatter setDateFormat:@"dd"];
    
    date.day = [dateFormatter stringFromDate:systemDate].integerValue;
    
    RWTime time;
    
    [dateFormatter setDateFormat:@"HH"];
    
    time.hours = [dateFormatter stringFromDate:systemDate].integerValue;
    
    [dateFormatter setDateFormat:@"mm"];
    
    time.minute = [dateFormatter stringFromDate:systemDate].integerValue;
    
    [dateFormatter setDateFormat:@"ss"];
    
    time.second = [dateFormatter stringFromDate:systemDate].integerValue;
    
    [dateFormatter setDateFormat:@"EEEE"];
    
    RWMoment moment; moment.date = date; moment.time = time;
    
    moment.week =
            [self clockWeekWithString:[dateFormatter stringFromDate:systemDate]];
    
    return moment;
}

- (NSInteger)distanceWithBeginMoments:(RWMoment)beginMoments AndEndMoments:(RWMoment)endMomends
{
    RWMoment exBegin = beginMoments; exBegin.time = RWTimeMake(0, 0, 0);
    
    RWMoment exEnd = endMomends;     exEnd.time = RWTimeMake(0, 0, 0);
    
    NSDate *begin = [self dateWithRWMoment:exBegin];
    
    NSDate *end = [self dateWithRWMoment:exEnd];
    
    return [end timeIntervalSinceDate:begin] / 60 / 60 / 24;
}

- (NSString *)stringRWTime:(RWTime)time
{
    return [NSString stringWithFormat:
                @"%.2d:%.2d:%.2d",(int)time.hours,(int)time.minute,(int)time.second];
}

- (RWTime)timeWithString:(NSString *)timeString
{
    NSArray *times = [timeString componentsSeparatedByString:@":"];
    
    RWTime time;
    
    if (times.count != 3)
    {
        return time;
    }
    else
    {
        time.hours  = [times[0] integerValue];
        time.minute = [times[1] integerValue];
        time.second = [times[2] integerValue];
        
        return time;
    }
}

- (NSString *)stringRWDate:(RWDate)date
{
    return [NSString stringWithFormat:
                            @"%d-%d-%d",(int)date.year,(int)date.month,(int)date.day];
}

- (RWDate)dateWithString:(NSString *)dateString
{
    NSArray *dates = [dateString componentsSeparatedByString:@"-"];
    
    RWDate date;
    
    if (dates.count != 3)
    {
        return date;
    }
    else
    {
        date.year = [dates[0] integerValue];
        date.month = [dates[1] integerValue];
        date.day = [dates[2] integerValue];
        
        return date;
    }
}

- (NSString *)stringRWMoment:(RWMoment)moment
{
    return [NSString stringWithFormat:@"%@$%@$%@",[self stringRWDate:moment.date],
                                                  [self stringRWTime:moment.time],
                                                  [self stringClockWeek:moment.week]];
}

- (RWMoment)momentWithString:(NSString *)momentString
{
    NSArray *moments = [momentString componentsSeparatedByString:@"$"];
    
    RWMoment moment;
    
    if (moments.count > 3 || moments.count < 1)
    {
        return moment;
    }
    else
    {
        if (moments.count == 1)
        {
            moment.date = [self dateWithString:moments[0]];
            moment.time = [self timeWithString:moments[0]];
            moment.week = RWClockWeekOfNone;
            
            return moment;
        }
        else if (moments.count == 2)
        {
            moment.date = [self dateWithString:moments[0]];
            moment.time = [self timeWithString:moments[1]];
            moment.week = RWClockWeekOfNone;
            
            return moment;
        }
        else
        {
            moment.date = [self dateWithString:moments[0]];
            moment.time = [self timeWithString:moments[1]];
            moment.week = [self clockWeekWithString:moments[2]];
            
            return moment;
        }
    }
}

@end
