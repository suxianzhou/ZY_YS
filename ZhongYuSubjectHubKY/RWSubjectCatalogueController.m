//
//  RWSubjectCatalogueController.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/6/8.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWSubjectCatalogueController.h"
#import "RWSubjectHubListCell.h"
#import "RWDataBaseManager.h"
#import "RWChooseSubViewController.h"
#import <SVProgressHUD.h>
#import "RWAnswerViewController.h"
#import "RWRequsetManager.h"
#import "RWErrorSubjectsController.h"
#import "RWProgressCell.h"

@interface RWSubjectCatalogueController ()

<

    UITableViewDelegate,
    UITableViewDataSource,
    UIAlertViewDelegate,
    RWRequsetDelegate

>

@property (nonatomic,strong)RWRequsetManager *requestManager;

@property (nonatomic,strong)RWDeployManager *deployManager;

@property (nonatomic,strong)UITableView *subjectHubList;

@property (nonatomic,strong)NSArray *subjectClassSource;

@property (nonatomic,strong)NSMutableArray *subjectSource;

@property (nonatomic,strong)RWDataBaseManager *baseManager;

@property (nonatomic,strong)NSString *selectTitle;

@end

static NSString *const hubList = @"hunList";

static NSString *const progressCell = @"ProgressCell";

@implementation RWSubjectCatalogueController

@synthesize subjectHubList;
@synthesize deployManager;
@synthesize baseManager;
@synthesize subjectClassSource;
@synthesize subjectSource;
@synthesize selectTitle;

- (void)initBar
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.translucent = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)initSegmentedControl
{
    UISegmentedControl *segmented = (UISegmentedControl *)[self.navigationController.view viewWithTag:30];
    
    if (segmented)
    {
        return;
    }
    
    segmented = [[UISegmentedControl alloc] initWithItems:@[@"题目练习",@"错题记录"]];
    
    segmented.tag = 30;
    
    segmented.frame = CGRectMake(0, 0, 200.0, 30.0);
    segmented.center = CGPointMake(self.navigationController.navigationBar.frame.size.width / 2, self.navigationController.navigationBar.frame.size.height /2);
    segmented.selectedSegmentIndex = 2;
    segmented.tintColor = [UIColor whiteColor];
    
    if ([[self.navigationController.viewControllers lastObject]
                                                        isKindOfClass:[self class]])
    {
        segmented.selectedSegmentIndex = 0;
    }
    else
    {
        segmented.selectedSegmentIndex = 1;
    }
    
    [segmented addTarget:self action:@selector(segmentedClick:) forControlEvents:UIControlEventValueChanged];
    
    [self.navigationController.navigationBar addSubview:segmented];
}

-(void)segmentedClick:(UISegmentedControl *)segmented
{
    if (segmented.selectedSegmentIndex == 0)
    {
        id controller = [self.navigationController.viewControllers lastObject];
        
        if ([controller isKindOfClass:[RWErrorSubjectsController class]])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        id controller = [self.navigationController.viewControllers lastObject];
        
        if ([controller isKindOfClass:[self class]])
        {
            RWErrorSubjectsController *errorController =
                                            [[RWErrorSubjectsController alloc] init];
            
            [self.navigationController pushViewController:errorController
                                                 animated:YES];
        }
    }
}
- (void)releaseSegmentedControl
{
    UISegmentedControl *segmented = (UISegmentedControl *)[self.navigationController.view viewWithTag:30];
    
    [segmented removeFromSuperview];
}

#pragma mark - Version > iOS 8_0

- (void)warningForNull
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"客官，后台数据更新中，完成后第一时间推送给您。" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *registerAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alert addAction:registerAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)initManagersAndDatas
{
    _requestManager = [[RWRequsetManager alloc] init];
    
    baseManager = [RWDataBaseManager defaultManager];
    
    subjectSource = [[NSMutableArray alloc] init];
    
    deployManager = [RWDeployManager defaultManager];
}

#pragma mark - RWRequsetDelegate

- (void)requestError:(NSError *)error Task:(NSURLSessionDataTask *)task {
    
    [SVProgressHUD dismiss];
    
    if (_requestManager.reachabilityStatus == AFNetworkReachabilityStatusUnknown)
    {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        
        [SVProgressHUD setFont:[UIFont systemFontOfSize:14]];
        
        [SVProgressHUD setMinimumDismissTimeInterval:0.1];
        
        [SVProgressHUD showInfoWithStatus:@"当前无网络，请检查网络设置"];
        
    }
}

- (void)subjectHubDownLoadDidFinish:(NSArray *)subjectHubs {
    
    subjectClassSource = subjectHubs;
    
    for (int i = 0;  i < subjectClassSource.count; i ++) {
        
        [subjectSource addObject:[baseManager obtainHubNamesWithTitle:[subjectClassSource[i] valueForKey:@"title"]]];
    }
    
    [subjectHubList reloadData];
    
    [SVProgressHUD dismiss];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return subjectSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [subjectSource[section] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat w = self.view.frame.size.width;
        
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, w, 30)];
        
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        
    image.image = [UIImage imageNamed:@"mark"];
        
    [headerView addSubview:image];
        
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 200, 30)];
        
    titleLabel.text = [subjectClassSource[section] valueForKey:@"title"];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentLeft;
        
    [headerView addSubview:titleLabel];
        
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([baseManager isExistHubWithHubName:[subjectSource[indexPath.section][indexPath.row] valueForKey:@"title"]])
    {
        RWProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:progressCell forIndexPath:indexPath];
        
        cell.name = [subjectSource[indexPath.section][indexPath.row] valueForKey:@"title"];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.fraction = [self fractionWithRow:indexPath.row
                                      Section:indexPath.section];
        
        return cell;
    }
    else
    {
        RWSubjectHubListCell *cell = [tableView dequeueReusableCellWithIdentifier:hubList forIndexPath:indexPath];
        
        cell.title = [subjectSource[indexPath.section][indexPath.row] valueForKey:@"title"];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.downLoadState = @"未下载";
        
        return cell;
    }
}

- (NSString *)fractionWithRow:(NSInteger)row Section:(NSInteger)section
{
    NSString *name = [subjectSource[section][row] valueForKey:@"title"];
    
    NSArray *items = [baseManager obtainIndexNameWithHub:name];
    
    unsigned int makes = 0,counts = 0;
    
    for (int i = 0; i < items.count; i++)
    {
        RWSubjectClassModel *item = items[i];
        
        NSString *itemfra = [baseManager toSubjectsWithIndexName:item.subjectclass
                                                      AndHubName:item.hub
                                                            Type:RWToNumberForString];
        
        NSArray *arr = [itemfra componentsSeparatedByString:@"/"];
        
        if (arr.count != 2)
        {
            return nil;
        }
        
        makes += [arr[0] intValue];
        counts += [arr[1] intValue];
    }
    
    return [NSString stringWithFormat:@"%d/%d",makes,counts];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([baseManager isExistHubWithHubName:[subjectSource[indexPath.section][indexPath.row] valueForKey:@"title"]])
    {
        return 80;
    }
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectTitle = [subjectSource[indexPath.section][indexPath.row] valueForKey:@"title"];
    
    _requestManager.delegate = self;
    
    NSArray *classSource = [baseManager obtainIndexNameWithHub:selectTitle];
    
    if (classSource.count == 0)
    {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        
        [SVProgressHUD setFont:[UIFont systemFontOfSize:14]];
        
        [SVProgressHUD showWithStatus:@"正在下载..."];
        
        if ([[subjectSource[indexPath.section][indexPath.row] valueForKey:@"formalDBURL"]
             rangeOfString:@".db"].location == NSNotFound)
        {
            [SVProgressHUD dismiss];
            
            [self warningForNull];
            
            return;
        }
        
        [_requestManager obtainBaseWith:
         [subjectSource[indexPath.section][indexPath.row]valueForKey:@"formalDBURL"]
                                 AndHub:selectTitle
                         DownLoadFinish:^(BOOL declassify) {
             
         }];
    }
    else
    {
        RWChooseSubViewController *choose = [[RWChooseSubViewController alloc] init];
        
        choose.headerTitle = selectTitle;
        
        choose.classSource = [baseManager obtainIndexNameWithHub:selectTitle];
        
        [self releaseSegmentedControl];
        
        [self.navigationController pushViewController:choose animated:YES];
        
        [SVProgressHUD dismiss];
    }
}

- (void)subjectBaseDeployDidFinish:(NSArray *)subjectHubs
{
    RWChooseSubViewController *choose = [[RWChooseSubViewController alloc] init];
    
    choose.headerTitle = selectTitle;
    
    choose.classSource = subjectHubs;
    
    [SVProgressHUD dismiss];
    
    [self releaseSegmentedControl];
    
    [self.navigationController pushViewController:choose animated:YES];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MAIN_NAV
    
    [self initManagersAndDatas];
    
    [self initBar];
    
    subjectHubList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    
    [self.view addSubview:subjectHubList];
    
    [subjectHubList mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        
    }];
    
    subjectHubList.showsHorizontalScrollIndicator = NO;
    subjectHubList.showsVerticalScrollIndicator   = NO;
    
    subjectHubList.delegate   = self;
    subjectHubList.dataSource = self;
    
    [subjectHubList registerClass:[RWSubjectHubListCell class]
           forCellReuseIdentifier:hubList];
    
    [subjectHubList registerClass:[RWProgressCell class]
           forCellReuseIdentifier:progressCell];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self initSegmentedControl];
    
    if (!subjectClassSource) {
        
        subjectClassSource = [baseManager obtainHubClassNames];
        
        if (subjectClassSource.count == 0) {
            
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            
            [SVProgressHUD setFont:[UIFont systemFontOfSize:14]];
            
            [SVProgressHUD showWithStatus:@"正在初始化请稍后..."];
            
            _requestManager.delegate = self;
            
            [_requestManager obtainServersInformation];
            
        }else {
            
            for (int i = 0;  i < subjectClassSource.count; i ++) {
                
                [subjectSource addObject:[baseManager obtainHubNamesWithTitle:[subjectClassSource[i] valueForKey:@"title"]]];
            }
        }
    }
    
    [subjectHubList reloadData];
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
