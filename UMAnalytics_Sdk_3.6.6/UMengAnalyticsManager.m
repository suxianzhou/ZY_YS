//
//  UMengAnalyticsManager.m
//  ZYTK
//
//  Created by 王辰 on 16/4/14.
//  Copyright © 2016年 WCX. All rights reserved.
//
#import "UMengAnalyticsManager.h"
#import "MobClick.h"

@interface UMengAnalyticsManager ()



@end

static UMengAnalyticsManager * defaultUMengAnalyticsManager = nil;

@implementation UMengAnalyticsManager

+(instancetype)defaultManager
{
    if (!defaultUMengAnalyticsManager)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            defaultUMengAnalyticsManager=[UMengAnalyticsManager new];
        });
    }
    return defaultUMengAnalyticsManager;
}

-(id)init
{
    if (self=[super init])
    {
        
    }
    return self;
}

-(void)profileSignInWithUsername:(NSString *) username
{
    [MobClick profileSignInWithPUID:username];
}

@end
