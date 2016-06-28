//
//  RWMainViewController+CountDownView.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/26.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWMainViewController+CountDownView.h"

@implementation RWMainViewController (CountDownView)

- (void)examineWhetherShowTestCountDownView
{
    NSString *testInformation = [self.deployManager deployValueForKey:TEST_DATE];
    
    if (testInformation)
    {
        NSArray *informations = [testInformation componentsSeparatedByString:@"()"];
        
        if (informations.count != 2)
        {
            return;
        }
        
        RWDate date = [self.deployManager dateWithString:[informations lastObject]];
        
        RWMoment faceMoment = [self.deployManager momentWithDate:[NSDate date]];
        
        RWMoment toMoment; toMoment.date = date;
        
        NSInteger days = [self.deployManager distanceWithBeginMoments:faceMoment
                                                        AndEndMoments:toMoment];
        
        if (days > 0)
        {
            [self addCountDownViewWithTestName:informations[0] Days:days];
        }
    }
}

- (void)addCountDownViewWithTestName:(NSString *)name Days:(NSInteger)days
{
    UITabBarController *tabBar = self.tabBarController;
    
    self.coverLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tabBar.view.frame.size.width, tabBar.view.frame.size.height)];
    
    
    self.coverLayer.backgroundColor = [UIColor blackColor];
    
    self.coverLayer.alpha = 0.7;
    
    [tabBar.view addSubview:self.coverLayer];
    
    self.countDown = [[RWCountDownView alloc]initWithFrame:
                      CGRectMake(0, 0, tabBar.view.frame.size.width, tabBar.view.frame.size.height)];
    
    [tabBar.view addSubview:self.countDown];
    
    self.countDown.delegate = self;
    
    self.countDown.background = [UIImage imageNamed:@"countDownback.jpg"];
    
    self.countDown.distanceDays = days;
    
    self.countDown.title = name;
}

- (void)removeCountDownView
{
    [self.countDown removeFromSuperview];
    [self.coverLayer removeFromSuperview];
    
    self.coverLayer = nil;
    self.countDown  = nil;
}


@end
