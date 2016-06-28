
//
//  RWDeployIndex.h
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/10.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#ifndef RWDeployIndex_h
#define RWDeployIndex_h

#define FIRST_OPEN_APPILCATION @"$m@#$a#$%!UW!r@$$k33894"

#define EXPERIENCE_TIMES @"iwidjkqwjinnnnbhhwwwdddwqwqexpqkmkwekk"

#define TIMES_BUFFER @"timwuidqwdcd"

#define USERNAME @"zyccxovvexqoisdaxawek"

#define PASSWORD @"acxwefsdsdkllwxdfweiq"

#define NAME @"kkduenlsjiqwjidwq323"

#define LOGIN @"xiwndpsjfsdkasdklasj"

#define DID_LOGIN @"ix23f3as230"

#define UNLINK_LOGIN @"ix23xkas230"

#define NOT_LOGIN @"ewuiweoe32x"

#define EXPERIENCE_VIEW @"kwCijeiwJIddw"

#define CLOCK @"xhasdjsadjl123jkjjhkj123j"

#define CLOCK_ON @"s9jlklasnad"

#define CLOCK_OFF @"sdn5a3dnlks"

#define CLOCK_NAMES @"sxlowhbasd43j53jj"

#define CLOCK_TIMES @"ewqwbtd7eq4ad8sdj"

#define DEFAULT_CLOCK @"00#8:00"

#define TEST_DATE @"dlwq23*&$21dkwkljdsd"

#define TEST_CLOCK @"te$$k23j@@$assd(dsst"

#define RWNOTFOUND @"68^&&D232(#(h(21:#"

typedef NS_ENUM(NSInteger ,RWClockCycle) {
    
    RWClockCycleEveryDay    = 0,
    RWClockCycleEveryWeek   = 1,
    RWClockCycleOnce        = 2
};

typedef NS_ENUM(NSInteger ,RWClockWeek) {
    
    RWClockWeekOfNone       = 0     ,
    RWClockWeekOfMonday     = 1 << 1,
    RWClockWeekOfTuesday    = 1 << 2,
    RWClockWeekOfWednesday  = 1 << 3,
    RWClockWeekOfThursday   = 1 << 4,
    RWClockWeekOfFriday     = 1 << 5,
    RWClockWeekOfSaturday   = 1 << 6,
    RWClockWeekOfSunday     = 1 << 7
};

struct RWDate
{
    NSInteger year;
    NSInteger month;
    NSInteger day;
};

typedef struct RWDate RWDate;

RWDate RWDateMake(NSInteger year, NSInteger month, NSInteger day);

struct RWTime
{
    NSInteger hours;
    NSInteger minute;
    NSInteger second;
};

typedef struct RWTime RWTime;

RWTime RWTimeMake(NSInteger hours ,NSInteger minute ,NSInteger second);

struct RWMoment
{
    RWDate date;
    RWTime time;
    RWClockWeek week;
};

typedef struct RWMoment RWMoment;

RWMoment RWMomentMake(NSInteger year, NSInteger month, NSInteger day, NSInteger hours ,NSInteger minute ,NSInteger second,RWClockWeek week);

typedef struct RWClockAttribute RWClockAttribute;

struct RWClockAttribute {
    
    RWClockCycle cycleType;
    RWClockWeek  week;
    NSInteger    hours;
    NSInteger    minute;
};

RWClockAttribute RWClockAttributeMake(RWClockCycle cycleType ,
                                      RWClockWeek  week ,
                                      NSInteger    hours ,
                                      NSInteger    minute);

NSInteger Log(NSInteger number);

#pragma mark - grows

RWMoment growsYear(RWMoment moment,NSInteger growsTimes);

RWMoment growsMonth(RWMoment moment,NSInteger growsTimes);

RWMoment growsDay(RWMoment moment,NSInteger growsTimes);

RWMoment growsHour(RWMoment moment,NSInteger growsTimes);

RWMoment growsMinute(RWMoment moment,NSInteger growsTimes);

RWMoment growsSecond(RWMoment moment,NSInteger growsTimes);

#pragma mark - decrease

RWMoment decreaseYear(RWMoment moment,NSInteger decreaseTimes);

RWMoment decreaseMonth(RWMoment moment,NSInteger decreaseTimes);

RWMoment decreaseDay(RWMoment moment,NSInteger decreaseTimes);

RWMoment decreaseHour(RWMoment moment,NSInteger decreaseTimes);

RWMoment decreaseMinute(RWMoment moment,NSInteger decreaseTimes);

RWMoment decreaseSecond(RWMoment moment,NSInteger decreaseTimes);






#endif /* RWDeployIndex_h */
