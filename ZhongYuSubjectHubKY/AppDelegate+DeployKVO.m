//
//  AppDelegate+DeployKVO.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/11.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "AppDelegate+DeployKVO.h"
#import "RWRegisterViewController.h"
#import "UMComLoginManager.h"

@implementation AppDelegate (DeployKVO)

- (void)deployAddObserver
{
    RWDeployManager *deployManager = [RWDeployManager defaultManager];
    
    self.deployInformation = [deployManager obtainDeployInformation];
    
    if (self.deployInformation.count == 0)
    {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        [deployManager setDeployValue:CLOCK_OFF forKey:CLOCK];
        
        [deployManager setDeployValue:@[@"提醒1"] forKey:CLOCK_NAMES];
        
        [deployManager setDeployValue:@[DEFAULT_CLOCK] forKey:CLOCK_TIMES];
        
        [deployManager addLocalNotificationWithClockString:DEFAULT_CLOCK
                                                   AndName:@"提醒1"];
        
        [deployManager setDeployValue:@(100) forKey:EXPERIENCE_TIMES];
        [deployManager setDeployValue:@(100) forKey:TIMES_BUFFER];
        
        self.deployInformation = [deployManager obtainDeployInformation];
    }
    
    if ([deployManager deployValueForKey:LOGIN] == nil)
    {
        [deployManager setDeployValue:NOT_LOGIN forKey:LOGIN];
    }
    
    [self.deployInformation addObserver:self
                             forKeyPath:TIMES_BUFFER
                                options:NSKeyValueObservingOptionNew
                                context:nil];
    
    [self.deployInformation addObserver:self
                             forKeyPath:LOGIN
                                options:NSKeyValueObservingOptionNew
                                context:nil];
    
    [self.deployInformation addObserver:self
                             forKeyPath:CLOCK_TIMES
                                options:NSKeyValueObservingOptionNew|
                                        NSKeyValueObservingOptionOld
                                context:nil];
    
    [self.deployInformation addObserver:self
                             forKeyPath:CLOCK_NAMES
                                options:NSKeyValueObservingOptionNew|
                                        NSKeyValueObservingOptionOld
                                context:nil];
    
    [self.deployInformation addObserver:self
                             forKeyPath:CLOCK
                                options:NSKeyValueObservingOptionNew
                                context:nil];
    
    if ([self.deployInformation objectForKey:TEST_CLOCK] == nil)
    {
        [deployManager setDeployValue:RWNOTFOUND forKey:TEST_CLOCK];
    }
    
    [self.deployInformation addObserver:self
                             forKeyPath:TEST_CLOCK
                                options:NSKeyValueObservingOptionNew
                                context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:LOGIN] &&
        [[change objectForKey:NSKeyValueChangeNewKey] isEqualToString:NOT_LOGIN])
    {
        [[NSNotificationCenter defaultCenter]
                      postNotificationName:LOGIN
                                    object:[change objectForKey:NSKeyValueChangeNewKey]
                                  userInfo:nil];
        
        [UMComLoginManager userLogout];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLogoutSucceedNotification object:nil];
        
        RWTabBarViewController *tabBarController =
                        (RWTabBarViewController *)self.window.rootViewController;
        
        [tabBarController toRootViewController];
        
        RWRegisterViewController *registerView = [[RWRegisterViewController alloc]init];
        
        [tabBarController presentViewController:registerView
                                       animated:YES
                                     completion:nil];
        
        [self addExperienceTimes];
    }
    else if ([keyPath isEqualToString:CLOCK_NAMES])
    {
        NSArray *newNames = [change objectForKey:NSKeyValueChangeNewKey];
        
        NSArray *oldNames = [change objectForKey:NSKeyValueChangeOldKey];
        
        if (newNames.count > oldNames.count)
        {
            [self addClockWithNewsNames:newNames AndOldNames:oldNames];
        }
        else if (newNames.count < oldNames.count)
        {
            [self removeClockWithNewsNames:newNames AndOldNames:oldNames];
        }
        else
        {
            [self updateClockWithNewsNames:newNames AndOldNames:oldNames];
        }
    }
    else if ([keyPath isEqualToString:CLOCK_TIMES])
    {
        NSArray *newClocks = [change objectForKey:NSKeyValueChangeNewKey];
        
        NSArray *oldClocks = [change objectForKey:NSKeyValueChangeOldKey];
        
        if (newClocks.count == oldClocks.count)
        {
            [self updateClockWithNewsClocks:newClocks AndOldClocks:oldClocks];
        }
    }
    else if ([keyPath isEqualToString:CLOCK])
    {
        NSString *clockState = [change objectForKey:NSKeyValueChangeNewKey];
        
        [self changeClockState:clockState];
    }
    else if ([keyPath isEqualToString:TEST_CLOCK])
    {
        NSString *testClock  = [change objectForKey:NSKeyValueChangeNewKey];
        
        if ([testClock isEqualToString:RWNOTFOUND])
        {
            [self removeTestNotificationWithTestInformation];
        }
        else
        {
            [self addTestNotificationWithTestInformation:testClock];
        }
    }
    else if ([keyPath isEqualToString:TIMES_BUFFER])
    {
        if ([[self.deployInformation objectForKey:LOGIN] isEqualToString:NOT_LOGIN])
        {
            [self addExperienceTimes];
        }
    }
}

- (void)addExperienceTimes
{
    NSNumber *times = [NSNumber numberWithInteger:[[self.deployInformation objectForKey:TIMES_BUFFER] integerValue]];
    
    RWDeployManager *deployManager = [RWDeployManager defaultManager];
    
    [deployManager setDeployValue:times
                           forKey:EXPERIENCE_TIMES];
}

- (void)addClockWithNewsNames:(NSArray *)newNames AndOldNames:(NSArray *)oldNames
{
    RWDeployManager *deployManager = [RWDeployManager defaultManager];
    
    NSString *newClock, *newName;
    
    BOOL findNewsClocks = NO;
    
    for (int i = 0; i < newNames.count; i++)
    {
        if (oldNames.count == 0 && newNames.count == 1)
        {
            NSArray *clocks = [deployManager deployValueForKey:CLOCK_TIMES];
            
            newClock = clocks[0];
            
            newName = newNames[0];
            
            break;
        }
        
        for (int j = 0; j < oldNames.count; j++)
        {
            if ([newNames[newNames.count - 1 - i] isEqualToString:oldNames[j]])
            {
                break;
            }
            
            NSArray *clocks = [deployManager deployValueForKey:CLOCK_TIMES];
            
            newClock = clocks[newNames.count - 1 - i];
            
            newName = newNames[newNames.count - 1 - i];
                
            findNewsClocks = YES;
                
            break;
        }
        
        if (findNewsClocks)
        {
            break;
        }
    }
    
    [deployManager addLocalNotificationWithClockString:newClock AndName:newName];
}

- (void)removeClockWithNewsNames:(NSArray *)newNames AndOldNames:(NSArray *)oldNames
{
    NSString *oldName;
    
    BOOL findNewsClocks = NO;
    
    
    RWDeployManager *deployManager = [RWDeployManager defaultManager];
    
    if (newNames.count == 0 && oldNames.count == 1)
    {
        [deployManager cancelLocalNotificationWithName:[oldNames firstObject]];
        
        return;
    }
    
    for (int i = 0; i < oldNames.count; i++)
    {
        for (int j = 0; j < newNames.count; j++)
        {
            if ([oldNames[oldNames.count - 1 - i] isEqualToString:newNames[j]])
            {
                break;
            }
            
            if (j == newNames.count - 1)
            {
                oldName = oldNames[oldNames.count - 1 - i];
                
                findNewsClocks = YES;
            }
        }
        
        if (findNewsClocks)
        {
            break;
        }
    }
    
    [deployManager cancelLocalNotificationWithName:oldName];
}

- (void)updateClockWithNewsClocks:(NSArray *)newClocks AndOldClocks:(NSArray *)oldClocks
{
    for (int i = 0; i < newClocks.count; i++)
    {
        if (![newClocks[i] isEqualToString:oldClocks[i]])
        {
            self.isChangeAttrbute = YES;
            
            break;
        }
    }
}

- (void)updateClockWithNewsNames:(NSArray *)newNames AndOldNames:(NSArray *)oldNames
{
    if (!self.isChangeAttrbute)
    {
        return;
    }
    
    for (int i = 0; i < newNames.count; i++)
    {
        if (![newNames[i] isEqualToString:oldNames[i]])
        {
            RWDeployManager *deployManager = [RWDeployManager defaultManager];
            
            NSArray *clocks = [deployManager deployValueForKey:CLOCK_TIMES];
            
            [deployManager cancelLocalNotificationWithName:oldNames[i]];
            
            [deployManager addLocalNotificationWithClockString:clocks[i]
                                                       AndName:newNames[i]];
            
            self.isChangeAttrbute = NO;

        }
    }
}

- (void)changeClockState:(NSString *)clockState
{
    if ([clockState isEqualToString:CLOCK_ON])
    {
        RWDeployManager *deployManager = [RWDeployManager defaultManager];
        
        NSArray *names = [deployManager deployValueForKey:CLOCK_NAMES];
        
        if (names.count == 0)
        {
            return;
        }
        
        NSArray *clocks = [deployManager deployValueForKey:CLOCK_TIMES];
        
        if (names.count == clocks.count)
        {
            for (int i = 0; i < names.count; i++)
            {
                [deployManager addLocalNotificationWithClockString:clocks[i]
                                                           AndName:names[i]];
            }
        }
    }
    else if ([clockState isEqualToString:CLOCK_OFF])
    {
        NSArray *notifications =
                    [[UIApplication sharedApplication] scheduledLocalNotifications];
        
        for (int i = 0; i < notifications.count; i++)
        {
            UILocalNotification *notification = notifications[i];
            
            if (![[notification.userInfo objectForKey:CLOCK_NAMES]
                                                        isEqualToString:TEST_CLOCK])
            {
                [[UIApplication sharedApplication]
                                                cancelLocalNotification:notification];
            }
        }
    }
}

- (void)addTestNotificationWithTestInformation:(NSString *)testInformation
{
    NSArray *informations = [testInformation componentsSeparatedByString:@"()"];
    
    if (informations.count == 2)
    {
        RWMoment moment = [[RWDeployManager defaultManager]
                                                    momentWithString:informations[1]];
        
        [[RWDeployManager defaultManager] addLocalNotificationToRWMoment:moment AndName:informations[0]];
    }
}

- (void)removeTestNotificationWithTestInformation
{
    NSArray *notifications =
                    [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (int i = 0; i < notifications.count; i++)
    {
        UILocalNotification *notification = notifications[i];
        
        if ([[notification.userInfo objectForKey:CLOCK_NAMES]
              isEqualToString:TEST_CLOCK])
        {
            [[UIApplication sharedApplication]
                                        cancelLocalNotification:notification];
        }
    }
}

@end
