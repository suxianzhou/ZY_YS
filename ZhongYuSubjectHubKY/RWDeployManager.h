//
//  RWDeployManager.h
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/10.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWDeployIndex.h"

@interface RWDeployManager : NSObject

+ (RWDeployManager *)defaultManager;
/**
 *  写入一条配置信息  OC基本数据类型
 *
 *  @param value
 *  @param key
 *
 *  @return
 */
- (BOOL)setDeployValue:(id)value forKey:(NSString *)key;
/**
 *  获取一条备用信息
 *
 *  @param key 
 *
 *  @return
 */
- (id)deployValueForKey:(NSString *)key;
/**
 *  清除一条配置信息
 *
 *  @param key
 *
 *  @return
 */
- (BOOL)removeDeployValueForKey:(NSString *)key;
/**
 *  变更登录状态
 *
 *  @param status   登录状态
 *  @param username 用户名
 *  @param password 密码
 *  @param name     昵称
 */
- (void)changeLoginStatusWithStatus:(NSString *)status Username:(NSString *)username Password:(NSString *)password termOfEndearment:(NSString *)name;

- (NSString *)encryptionString:(NSString *)string;

- (NSString *)declassifyString:(NSString *)string;

- (NSMutableDictionary *)obtainDeployInformation;

- (void)addLocalNotificationWithClockString:(NSString *)clockString
                                    AndName:(NSString *)name;

- (void)cancelLocalNotificationWithName:(NSString *)name;

- (void)addAlarmClockWithTime:(NSDate *)date Cycle:(RWClockCycle)cycle
                    ClockName:(NSString *)name Content:(NSString *)content;

- (void)addLocalNotificationToRWMoment:(RWMoment)moment AndName:(NSString *)name;

@end
