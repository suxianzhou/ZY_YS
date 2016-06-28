//
//  RWRegisterViewController.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/6.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWRegisterViewController.h"
#import "RWPhoneVerificationController.h"

@interface RWRegisterViewController ()

@end

@implementation RWRegisterViewController

- (instancetype)init
{
    RWPhoneVerificationController * reginster =
                                        [[RWPhoneVerificationController alloc]init];
    
    return [super initWithRootViewController:reginster];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self addWaterAnimation];
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self addWaterAnimation];
    
    return [super popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self addWaterAnimation];
    
    return [super popToViewController:viewController animated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
{
    [self addWaterAnimation];
    
    return [super popToRootViewControllerAnimated:animated];
}

- (void)addWaterAnimation
{
    CATransition *transition = [CATransition animation];
    
    transition.type = @"rippleEffect";
    
    transition.subtype = @"fromLeft";
    
    transition.duration = 1;
    
    [self.view.layer addAnimation:transition forKey:nil];
}

#pragma mark - Life Cycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [SVProgressHUD dismiss];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
