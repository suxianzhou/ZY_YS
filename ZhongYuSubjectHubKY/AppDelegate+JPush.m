//
//  AppDelegate+JPush.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/21.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "AppDelegate+JPush.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "RWRequsetManager.h"
#import "RWWebViewController.h"

@implementation AppDelegate (JPush)

- (void)initJPushWithLaunchOptions:(NSDictionary *) launchOptions
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
    {
        [JPUSHService registerForRemoteNotificationTypes:UIUserNotificationTypeAlert|
                                                         UIUserNotificationTypeBadge|
                                                         UIUserNotificationTypeSound
                                              categories:nil];
    }
    
    [JPUSHService setupWithOption:launchOptions
                           appKey:JPUSH_KEY
                          channel:@"App Store"
                 apsForProduction:1];
}

- (void)examinePushInformation
{
    if ([UIApplication sharedApplication].applicationIconBadgeNumber == 0 ||
                    [[[RWDeployManager defaultManager]
                            deployValueForKey:FIRST_OPEN_APPILCATION] boolValue])
    {
        return;
    }
    

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    UIViewController *viewController = [self getPresentedViewController];
    
    [self toPushViewControllerFromViewController:viewController];
}

- (void)toPushViewControllerFromViewController:(__kindof UIViewController *)viewController
{
    __block RWWebViewController *webView = [[RWWebViewController alloc] init];
    
    [viewController.navigationController pushViewController:webView animated:YES];
    
    [[[RWRequsetManager alloc] init] receivePushMessageOfHTML:^(NSString *html, NSError *error)
    {
        if (error)
        {
            [RWRequsetManager warningToViewController:viewController
                                                Title:@"网络连接失败，请检查网络"
                                                Click:^{
                                                    
                [viewController.navigationController popViewControllerAnimated:YES];
                
            }];
            
            return;
        }
        
        webView.url = html;
    }];
}

- (__kindof UIViewController *)getPresentedViewController
{
    RWTabBarViewController *rootTabBar =
                            (RWTabBarViewController *)self.window.rootViewController;
    
    UIViewController *topViewController;
    
    
    if (rootTabBar.presentedViewController)
    {
        UINavigationController *registerView =
                        (UINavigationController *)rootTabBar.presentedViewController;
        
        topViewController = [registerView.viewControllers lastObject];
    }
    else
    {
        UINavigationController *mianView =
                                rootTabBar.viewControllers[rootTabBar.selectedIndex];
        
        topViewController = [mianView.viewControllers lastObject];
    }
    
    return topViewController;
}

- (void)openFromAlrteClickWithNotification:(NSNotification *)notification
{
//    NSString *body = notification.alertBody
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


@end
