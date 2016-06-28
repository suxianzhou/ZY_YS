//
//  AppDelegate.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/4/26.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+DeployKVO.h"
#import "AppDelegate+JPush.h"
#import "MagicalRecord.h"
#import "MobClick.h"
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/Extend/SMSSDK+AddressBookMethods.h>
#import "UMCommunity.h"
#import "RWRequestIndex.h"

@interface AppDelegate ()

@end

static NSString *const baseName = @"ZhongYuSubjuectHub";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self initApplicationDeployInformation];
    
    [self initJPushWithLaunchOptions:launchOptions];

    [self initRootViewControllerToWindow];
    
    [self examinePushInformation];
    
    [self registerVendorsWithLaunchOptions:launchOptions];

    return YES;
}

- (void)initApplicationDeployInformation
{
    _isChangeAttrbute = NO;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:baseName];
    
    [self deployAddObserver];
}

- (void)registerVendorsWithLaunchOptions:(NSDictionary *) launchOptions
{
    //UMCommunity
    
    [UMCommunity setAppKey:UMengCommunityAppkey
             withAppSecret:UMengCommunityAppSecret];
    //MobSMS
    [SMSSDK registerApp:SMSSDK_APPKEY
             withSecret:SMSSDK_SECRET];
    
    [SMSSDK enableAppContactFriends:NO];
    
    //MobClick
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    [MobClick startWithAppkey:MOB_CLICK
                 reportPolicy:BATCH
                    channelId:@"App Store"];
}

- (void)initRootViewControllerToWindow
{
    _window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [_window makeKeyAndVisible];
    
    RWTabBarViewController *tabBarController = [[RWTabBarViewController alloc]init];
    
    _window.rootViewController = tabBarController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [self examinePushInformation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [self.deployInformation removeObserver:self
                                forKeyPath:LOGIN];
    
    [self.deployInformation removeObserver:self
                                forKeyPath:CLOCK_TIMES];
    
    [self.deployInformation removeObserver:self
                                forKeyPath:CLOCK_NAMES];
    
    [self.deployInformation removeObserver:self
                                forKeyPath:CLOCK];
    
    if ([[[RWDeployManager defaultManager] deployValueForKey:LOGIN]
                                                    isEqualToString:DID_LOGIN])
    {
        [[RWDeployManager defaultManager] setDeployValue:UNLINK_LOGIN
                                                  forKey:LOGIN];
    }
}

@end
