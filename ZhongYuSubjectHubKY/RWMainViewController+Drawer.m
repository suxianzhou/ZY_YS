//
//  RWMainViewController+Drawer.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/23.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWMainViewController+Drawer.h"
#import "RWCountDownController.h"

@implementation RWMainViewController (Drawer)

- (void)compositionDrawer
{
    self.tabBarController.view.layer.shadowColor   = [[UIColor blackColor] CGColor];
    self.tabBarController.view.layer.shadowOffset  = CGSizeMake(-10,0);
    self.tabBarController.view.layer.shadowRadius  = 10;
    self.tabBarController.view.layer.shadowOpacity = 0.7;
    
    self.reloadData = NO;
    
    self.viewCenter = self.tabBarController.view.center;
    
    self.drawerView = [[RWDrawerView alloc]initWithFrame:
                    CGRectMake(-self.tabBarController.view.frame.size.width*0.65/2, 0,
                                self.tabBarController.view.frame.size.width*0.65,
                                self.tabBarController.view.frame.size.height)];
    
    self.drawerView.backgroundColor = [UIColor whiteColor];
    
    self.drawerView.backgroundImage = [UIImage imageNamed:@"drawerView"];
    
    self.drawerView.delegate = self;
    
    [[NSNotificationCenter defaultCenter]
                                    addObserverForName:LOGIN
                                                object:nil
                                                 queue:[NSOperationQueue mainQueue]
                                            usingBlock:^(NSNotification * _Nonnull note)
    {
        
        self.reloadData = YES;
        
    }];
}

- (NSInteger)numberOfRowsInMenuBar:(RWDrawerView *)bar
{
    return 5;
}

- (CGFloat)menuBar:(RWDrawerView *)bar heightForRow:(NSInteger)row
{
    return 50;
}

- (NSString *)menuBar:(RWDrawerView *)bar StringForRow:(NSInteger)row
{
    switch (row) {
        case 0:
            
            if (![[[RWDeployManager defaultManager]
                                   deployValueForKey:LOGIN] isEqualToString:NOT_LOGIN])
            {
                return @"更新数据库";
            }
            else
            {
                return @"登录";
            }
            
        case 1:
            
            return @"考试提醒";
        case 2:
            
            return @"使用说明";
        case 3:
            
            return @"关于我们";
            
        default:
            
            return @"联系客服";
    }
}

- (void)menuBar:(RWDrawerView *)bar didSelectRow:(NSInteger)row
{
    [self closeDrawer];
    
    switch (row) {
        case 0:
            
            if (![[[RWDeployManager defaultManager]
                  deployValueForKey:LOGIN] isEqualToString:NOT_LOGIN])
            {
                [self updateDatabase];
            }
            else
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [[RWDeployManager defaultManager]setDeployValue:@"transit"
                                                             forKey:LOGIN];
                    
                    [[RWDeployManager defaultManager]setDeployValue:NOT_LOGIN
                                                             forKey:LOGIN];
                });
            }
            
            break;
        case 1:
            
            [self countDownView];
            
            break;
        case 2:
            
            [self toInstructions];
            
            break;
        case 3:
            
            [self toAboutUsViewController];
            
            break;
            
        default:
            
            [[UIApplication sharedApplication] openURL:
                                        [NSURL URLWithString:@"tel://4008-355-366"]];
            
            break;
    }
}

- (void)animateOfDrawer:(CGPoint)center
{
    [UIView animateWithDuration:0.2 animations:^{
        
        self.drawerView.center = center;
    }];
}

- (void)animateOfView:(CGPoint)center
{
    [UIView animateWithDuration:0.2 animations:^{
        
        self.tabBarController.view.center = center;
    }];
}

- (void)openDrawer
{
    CGPoint viewPt = self.tabBarController.view.center;
    
    viewPt.x += self.drawerView.frame.size.width;
    
    CGPoint drawerPt = self.drawerView.center;
    
    drawerPt.x += self.drawerView.frame.size.width/2;
    
    [self animateOfDrawer:drawerPt];
    
    [self animateOfView:viewPt];
}

- (void)closeDrawer
{
    [self animateOfView:self.viewCenter];
    [self animateOfDrawer:self.drawerCenter];
}

- (void)drawerSwitch
{
    if (self.tabBarController.view.center.x ==
        self.tabBarController.view.frame.size.width / 2)
    {
        [self openDrawer];
        
        self.informationView.userInteractionEnabled = NO;
        
        if (self.reloadData)
        {
            [self.drawerView reloadData];
        }
    }
    else
    {
        [self closeDrawer];
        
        self.informationView.userInteractionEnabled = YES;
    }
}

#pragma mark - UITouch


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    
    self.startingTouches = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint moveTo = [touch locationInView:self.view];
    
    if (touch.view == self.view)
    {
        CGPoint viewPt = self.tabBarController.view.center;
        
        CGPoint drawerPt = self.drawerView.center;
        
        CGFloat moveDistance = moveTo.x - self.startingTouches.x;
        
        viewPt.x += moveDistance;
        
        drawerPt.x += moveDistance/2;
        
        if (viewPt.x >= self.tabBarController.view.frame.size.width/2 &&
            viewPt.x <= self.tabBarController.view.frame.size.width * 1.15)
        {
            self.tabBarController.view.center = viewPt;
            
            self.drawerView.center = drawerPt;
        }
    }
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGFloat criticalPoint = self.drawerView.frame.size.width/4;
    
    if (self.drawerView.center.x > criticalPoint)
    {
        CGPoint drawerPt = self.drawerView.center;
        drawerPt.x = self.tabBarController.view.frame.size.width * 0.65 /2;
        [self animateOfDrawer:drawerPt];
        
        CGPoint viewPt = self.tabBarController.view.center;
        viewPt.x = self.tabBarController.view.frame.size.width * 1.15;
        [self animateOfView:viewPt];
        
        self.informationView.userInteractionEnabled = NO;
    }
    else
    {
        CGPoint viewPt = self.tabBarController.view.center;
        viewPt.x = self.tabBarController.view.frame.size.width/2;
        [self animateOfView:viewPt];
        
        CGPoint drawerPt = self.drawerView.center;
        drawerPt.x = 0;
        [self animateOfDrawer:drawerPt];
        
        self.informationView.userInteractionEnabled = YES;
    }
}

- (void)updateDatabase
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"更新数据库后答题记录将被重置,是否更新?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *registerAction = [UIAlertAction actionWithTitle:@"暂不更新" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        
        [SVProgressHUD setFont:[UIFont systemFontOfSize:14]];
        
        [SVProgressHUD showWithStatus:@"正在更新..."];
        
        self.requestManager.delegate = self;
        
        [self.requestManager obtainServersInformation];
        
    }];
    
    [alert addAction:registerAction];
    
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)subjectHubDownLoadDidFinish:(NSArray *)subjectHubs
{
    [SVProgressHUD dismiss];
    
    [RWRequsetManager warningToViewController:self Title:@"更新成功" Click:nil];
}

- (void)toAboutUsViewController
{
    RWWebViewController *webViewController = [[RWWebViewController alloc] init];
    
    webViewController.url = ABOUT_US;
    
    webViewController.title = @"关于我们";
    
    [self.navigationController pushViewController:webViewController animated:YES];
}

-(void)toInstructions
{
    RWWebViewController *webViewController = [[RWWebViewController alloc] init];
    
    webViewController.url = README;
    
    webViewController.title = @"使用说明";
    
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)countDownView
{
    RWCountDownController *countDown = [[RWCountDownController alloc] init];
    
    [self.navigationController pushViewController:countDown animated:YES];
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
