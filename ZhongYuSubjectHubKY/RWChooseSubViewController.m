//
//  RWChooseSubViewController.m
//  ZhongYuSubjectHubKY
//
//  Created by Wcx on 16/4/26.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWChooseSubViewController.h"
#import "RWProgressCell.h"
#import "RWAnswerViewController.h"
#import "RWDataBaseManager.h"

@interface RWChooseSubViewController ()

<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic,strong) UITableView *sujectClasses;

@property (nonatomic,strong) RWDataBaseManager *baseManager;

@end

static NSString *const classList = @"classList";

@implementation RWChooseSubViewController

@synthesize sujectClasses;
@synthesize baseManager;

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    sujectClasses = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    
    [self.view addSubview:sujectClasses];
    
    [sujectClasses mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    sujectClasses.showsVerticalScrollIndicator = NO;
    sujectClasses.showsHorizontalScrollIndicator = NO;
    
    sujectClasses.delegate = self;
    sujectClasses.dataSource = self;
    
    sujectClasses.bounces = NO;
    
    [sujectClasses registerClass:[RWProgressCell class] forCellReuseIdentifier:classList];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationItem.title = _headerTitle;
    
    if (!baseManager) {
        
        baseManager = [RWDataBaseManager defaultManager];
    }
    
    [sujectClasses reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

#pragma mark - delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _classSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    RWProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:classList forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.name = [_classSource[indexPath.row] valueForKey:@"subjectclass"];
    
    cell.fraction = [baseManager toSubjectsWithIndexName:[_classSource[indexPath.row] valueForKey:@"subjectclass"] AndHubName:[_classSource[indexPath.row] valueForKey:@"hub"] Type:RWToNumberForString];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!baseManager) {
        
        baseManager = [RWDataBaseManager defaultManager];
    }
    
    RWAnswerViewController *answerView = [[RWAnswerViewController alloc]init];
    
    answerView.headerTitle = [_classSource[indexPath.row] valueForKey:@"subjectclass"];
    
    NSArray *subjectSource = [baseManager obtainSubjectsWithIndexName:[_classSource[indexPath.row] valueForKey:@"subjectclass"] AndHubName:[_classSource [indexPath.row] valueForKey:@"hub"]];
    
    answerView.subjectSource = [NSMutableArray arrayWithArray:subjectSource];
    
    answerView.displayType = RWDisplayTypeNormal;
    
    answerView.beginIndexPath = [baseManager obtainBeginWithBeforeOfLastSubjectWithSubjectSource:subjectSource];
    
    [self.navigationController pushViewController:answerView animated:YES];
}

@end
