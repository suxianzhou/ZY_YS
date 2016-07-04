//
//  RWSubjectManagerController.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/6/30.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWSubjectManagerController.h"
#import "RWRandomSubjectController.h"
#import "RWSubjectCatalogueController.h"
#import "RWErrorSubjectsController.h"

@interface RWSubjectManagerController ()

@property (nonatomic,strong)NSArray *controllers;

@end

@implementation RWSubjectManagerController

- (void)initBar
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.translucent = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)initSegmentedControlWithIndex:(NSInteger)index
{
    UISegmentedControl *segmented = (UISegmentedControl *)[self.navigationController.view viewWithTag:30];
    
    if (segmented)
    {
        return;
    }
    
    segmented = [[UISegmentedControl alloc] initWithItems:@[@"随机答题",@"题目练习",@"错题记录"]];
    
    segmented.tag = 30;
    
    segmented.frame = CGRectMake(0, 0, 260.0, 30.0);
    segmented.center = CGPointMake(self.navigationController.navigationBar.frame.size.width / 2, self.navigationController.navigationBar.frame.size.height /2);
    segmented.selectedSegmentIndex = 2;
    segmented.tintColor = [UIColor whiteColor];
    
    segmented.selectedSegmentIndex = index;
    
    [segmented addTarget:self action:@selector(segmentedClick:) forControlEvents:UIControlEventValueChanged];
    
    [self.navigationController.navigationBar addSubview:segmented];
}

-(void)segmentedClick:(UISegmentedControl *)segmented
{
    [self toSelectedViewControllerWithIndex:segmented.selectedSegmentIndex];
}

- (void)toSelectedViewControllerWithIndex:(NSInteger)index
{
    [self.navigationController popViewControllerAnimated:NO];
    
    NSString *classString = _controllers[index];
    
    Class controller = NSClassFromString(classString);
    
    id viewController = [[controller alloc] init];
    
    [viewController setValue:self
                      forKey:@"managerController"];
    
    [self.navigationController pushViewController:viewController
                                         animated:NO];
}

- (void)releaseSegmentedControl
{
    UISegmentedControl *segmented = (UISegmentedControl *)[self.navigationController.view viewWithTag:30];
    
    [segmented removeFromSuperview];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MAIN_NAV
    
    _controllers = @[@"RWRandomSubjectController",
                     @"RWSubjectCatalogueController",
                     @"RWErrorSubjectsController"];
    
    [self initBar];
    [self initSegmentedControlWithIndex:RWSegmentedOfRandom];
    [self toSelectedViewControllerWithIndex:RWSegmentedOfRandom];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
