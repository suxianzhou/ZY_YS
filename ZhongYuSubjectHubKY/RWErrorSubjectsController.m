//
//  RWErrorSubjectsController.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/4/26.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWErrorSubjectsController.h"
#import "RWSubjectCatalogueController.h"
#import "RWDataBaseManager.h"
#import "RWSubjectHubListCell.h"
#import "RWRegisterNowView.h"

@interface RWErrorSubjectsController ()

<
    UITableViewDataSource,
    UITableViewDelegate,
    RWRegisterNowViewDelegate
>

@property (nonatomic,strong)NSArray *classHeader;

@property (nonatomic,strong)NSMutableArray *wrongSource;

@property (nonatomic,strong)NSDictionary *subjectsSource;

@property (nonatomic,strong)RWDataBaseManager *baseManager;

@property (nonatomic,strong)UITableView *wrongList;

@property (nonatomic,strong)RWRegisterNowView *registerView;

@end

static NSString *const wrongListCell = @"wrongListCell";

@implementation RWErrorSubjectsController

@synthesize baseManager;
@synthesize wrongList;
@synthesize wrongSource;
@synthesize classHeader;
@synthesize subjectsSource;
@synthesize registerView;

- (void)notLogin
{
    if (!registerView)
    {
        CGRect frame =
        CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        registerView = [RWRegisterNowView registerViewWithFrame:frame
                                                       Delegate:self];
    }
    
    [self.view addSubview:registerView];
}

- (NSString *)titleWithRegisterView
{
    return @"立即登录\n\n免费下载海量题库及历年真题";
}

- (void)registerView:(RWRegisterNowView *)registerView Click:(UIButton *)click
{
    [[RWDeployManager defaultManager] setDeployValue:NOT_LOGIN forKey:LOGIN];
}

- (void)obtainCollectSource
{
    
    if (self.delegate == nil)
    {
         subjectsSource = [baseManager obtainCollectSubjectsWithType:RWCollectTypeOnlyWrong];
    }
    else if ([self.delegate CollectSubject] == RWDisplayTypeCollect)
    {
        subjectsSource = [baseManager obtainCollectSubjectsWithType:RWCollectTypeOnlyCollect];
    }
   
    classHeader = subjectsSource.allKeys;
    
    [wrongSource removeAllObjects];
    
    for (int i = 0; i < classHeader.count; i++)
    {
        [wrongSource addObject:[[subjectsSource objectForKey:classHeader[i]] allKeys]];
    }
    
    [wrongList reloadData];
}

- (void)initNavgationBar
{
    MAIN_NAV
    
    
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    if (_delegate)
    {
        self.navigationItem.title = @"收藏";
        
        HIDDEN_TABBAR
    }
    else
    {
        self.navigationItem.hidesBackButton = YES;
    }
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavgationBar];
    
    [self initDatas];
    
    [self initWrongList];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([[[RWDeployManager defaultManager] deployValueForKey:LOGIN]
          isEqualToString:NOT_LOGIN])
    {
        [self notLogin];
        
        return;
    }
    
    if (registerView)
    {
        [registerView removeFromSuperview];
    }
    
    if (!_delegate)
    {
        [self SegmentedHidden:NO];
    }
    
    [self obtainCollectSource];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.delegate)
    {
        SHOW_TABBAR
    }
}

- (void)initDatas
{
    baseManager = [RWDataBaseManager defaultManager];
    classHeader = [[NSArray alloc]init];
    wrongSource = [[NSMutableArray alloc]init];
    subjectsSource = [[NSDictionary alloc]init];
}

- (void)initWrongList
{
    wrongList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    
    [self.view addSubview:wrongList];
    
    [wrongList mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
    }];
    
    wrongList.showsHorizontalScrollIndicator = NO;
    wrongList.showsVerticalScrollIndicator = NO;
    
    wrongList.delegate = self;
    
    wrongList.dataSource = self;
    
    [wrongList registerClass:[RWSubjectHubListCell class] forCellReuseIdentifier:wrongListCell];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return wrongSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [wrongSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RWSubjectHubListCell *cell = [tableView dequeueReusableCellWithIdentifier:wrongListCell forIndexPath:indexPath];
    
    cell.title = wrongSource[indexPath.section][indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *subjects = [[subjectsSource objectForKey:classHeader[indexPath.section]] objectForKey:wrongSource[indexPath.section][indexPath.row]];
    
    cell.downLoadState = [NSString stringWithFormat:@"%d",(int)(subjects.count)];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat w = self.view.frame.size.width;
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, w, 30)];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    image.image = [UIImage imageNamed:@"mark"];
    
    [headerView addSubview:image];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 200, 30)];
    
    titleLabel.text = classHeader[section];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    
    [headerView addSubview:titleLabel];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self SegmentedHidden:YES];
    
    NSArray *subjects = [[subjectsSource objectForKey:classHeader[indexPath.section]] objectForKey:wrongSource[indexPath.section][indexPath.row]];
    
    RWAnswerViewController *answer = [[RWAnswerViewController alloc]init];
    
    answer.headerTitle = classHeader[indexPath.section];
    
    answer.subjectSource = [NSMutableArray arrayWithArray:subjects];
    
    if (self.delegate == nil)
    {
        answer.displayType = RWDisplayTypeWrongSubject;
    }
    else
    {
        answer.displayType = [self.delegate CollectSubject];
    }
    
    [self.navigationController pushViewController:answer animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSArray *subjects = [[subjectsSource objectForKey:classHeader[indexPath.section]] objectForKey:wrongSource[indexPath.section][indexPath.row]];
    
    for (int i = 0; i < subjects.count; i++)
    {
        if (self.delegate == nil)
        {
            [baseManager removeCollect:subjects[i] State:RWCollectTypeOnlyWrong];
        }
        else
        {
            [baseManager removeCollect:subjects[i] State:RWCollectTypeOnlyCollect];
        }
    }
    
    [self obtainCollectSource];
}

- (void)SegmentedHidden:(BOOL)hidden
{
    NSArray *viewControllers = self.navigationController.viewControllers;
    
    RWSubjectCatalogueController *subjectCatalogue =
                                        viewControllers[viewControllers.count - 2];
    
    if (hidden)
    {
        [subjectCatalogue releaseSegmentedControl];
    }
    else
    {
        [subjectCatalogue initSegmentedControl];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate == nil)
    {
        return @"清除记录";
    }
    else
    {
        return @"取消收藏";
    }
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
