//
//  RWCatalogueBaseController.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/6/30.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWCatalogueBaseController.h"

@interface RWCatalogueBaseController ()

<
    UIAlertViewDelegate
>

@property (nonatomic,strong)RWDeployManager *deployManager;

@end

@implementation RWCatalogueBaseController

@synthesize deployManager;

- (void)initBar
{
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.translucent = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
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
    
    _baseManager = [RWDataBaseManager defaultManager];
    
    _subjectSource = [[NSMutableArray alloc] init];
    
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

- (void)subjectHubDownLoadDidFinish:(NSArray *)subjectHubs
{
    _subjectClassSource = subjectHubs;
    
    for (int i = 0;  i < _subjectClassSource.count; i ++) {
        
        [_subjectSource addObject:[_baseManager obtainHubNamesWithTitle:[_subjectClassSource[i] valueForKey:@"title"]]];
    }
    
    [_subjectHubList reloadData];
    
    [SVProgressHUD dismiss];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _subjectSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_subjectSource[section] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat w = self.view.frame.size.width;
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, w, 30)];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    image.image = [UIImage imageNamed:@"mark"];
    
    [headerView addSubview:image];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 200, 30)];
    
    titleLabel.text = [_subjectClassSource[section] valueForKey:@"title"];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    
    [headerView addSubview:titleLabel];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_baseManager isExistHubWithHubName:[_subjectSource[indexPath.section][indexPath.row] valueForKey:@"title"]])
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

#pragma mark - in this

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    _selectTitle = [_subjectSource[indexPath.section][indexPath.row]
                                                            valueForKey:@"title"];
    
    _requestManager.delegate = self;
    
    NSArray *classSource = [_baseManager obtainIndexNameWithHub:_selectTitle];
    
    if (classSource.count == 0)
    {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        
        [SVProgressHUD setFont:[UIFont systemFontOfSize:14]];
        
        [SVProgressHUD showWithStatus:@"正在下载..."];
        
        NSString *formalDBURL = [_subjectSource[indexPath.section][indexPath.row]
                                                            valueForKey:@"formalDBURL"];
        
        if ([formalDBURL rangeOfString:@".db"].location == NSNotFound)
        {
            [SVProgressHUD dismiss];
            
            [self warningForNull];
            
            return;
        }
        
        [_requestManager obtainBaseWith:formalDBURL
                                 AndHub:_selectTitle
                         DownLoadFinish:nil];
    }
}

- (void)subjectBaseDeployDidFinish:(NSArray *)subjectHubs
{

}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MAIN_NAV
    
    [self initManagersAndDatas];
    
    [self initBar];
    
    _subjectHubList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    
    [self.view addSubview:_subjectHubList];
    
    [_subjectHubList mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        
    }];
    
    _subjectHubList.showsHorizontalScrollIndicator = NO;
    _subjectHubList.showsVerticalScrollIndicator   = NO;
    
    _subjectHubList.delegate   = self;
    _subjectHubList.dataSource = self;
    
    [_subjectHubList registerClass:[RWSubjectHubListCell class]
           forCellReuseIdentifier:hubList];
    
    [_subjectHubList registerClass:[RWProgressCell class]
           forCellReuseIdentifier:progressCell];
    
    [_subjectHubList registerClass:[RWSliderCell class]
            forCellReuseIdentifier:sliderCell];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!_subjectClassSource) {
        
        _subjectClassSource = [_baseManager obtainHubClassNames];
        
        if (_subjectClassSource.count == 0) {
            
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            
            [SVProgressHUD setFont:[UIFont systemFontOfSize:14]];
            
            [SVProgressHUD showWithStatus:@"正在初始化请稍后..."];
            
            _requestManager.delegate = self;
            
            [_requestManager obtainServersInformation];
            
        }else {
            
            for (int i = 0;  i < _subjectClassSource.count; i ++) {
                
                [_subjectSource addObject:[_baseManager obtainHubNamesWithTitle:[_subjectClassSource[i] valueForKey:@"title"]]];
            }
        }
    }
    
    [_subjectHubList reloadData];
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
