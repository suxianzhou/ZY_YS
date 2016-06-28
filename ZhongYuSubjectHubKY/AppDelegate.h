//
//  AppDelegate.h
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/4/26.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RWTabBarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic,assign)BOOL isChangeAttrbute;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSMutableDictionary *deployInformation;

@end

