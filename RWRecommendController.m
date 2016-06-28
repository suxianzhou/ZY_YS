//
//  RWRecommendController.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/16.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWRecommendController.h"
#import "RWRequsetManager.h"

@interface RWRecommendController ()

<
    UITableViewDelegate,
    UITableViewDataSource,
    RWRequsetDelegate
>

@property (nonatomic,strong)UITableView *recommendList;

@property (nonatomic,strong)NSMutableArray *recommendSource;

@property (nonatomic,strong)RWRequsetManager *requestManager;

@end

static NSString *const recommendCell = @"recommendListCell";

@implementation RWRecommendController

@synthesize recommendList;
@synthesize recommendSource;

- (void)initRecommendView
{
    recommendList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    
    [self.view addSubview:recommendList];
    
    [recommendList mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    recommendList.showsHorizontalScrollIndicator = NO;
    
    recommendList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    recommendList.delegate = self;
    recommendList.dataSource = self;
    
    [recommendList registerClass:[UITableViewCell class] forCellReuseIdentifier:recommendCell];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return recommendSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                                    recommendCell forIndexPath:indexPath];
    
    cell.backgroundColor = Wonderful_GrayColor5;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(cell.mas_left).offset(30);
        make.top.equalTo(cell.mas_top).offset(10);
        make.width.equalTo(@(60));
        make.height.equalTo(@(60));
    }];
    
    cell.imageView.image =
        [UIImage imageWithData:[recommendSource[indexPath.section]objectForKey:@"img"]];
    
    cell.textLabel.text = [recommendSource[indexPath.section]objectForKey:@"title"];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[recommendSource[indexPath.section] objectForKey:@"ios_url"]]];
}

#pragma mark - Life Cycle

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    SHOW_TABBAR
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    HIDDEN_TABBAR
    
    self.navigationItem.title = @"题库推荐";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initRecommendView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    [SVProgressHUD setFont:[UIFont systemFontOfSize:14]];
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    if (!_requestManager)
    {
        _requestManager = [[RWRequsetManager alloc]init];
        
        _requestManager.delegate = self;
    }
    
    [_requestManager obtainRecommendListSource];
}

- (void)recommendListSourceDownloadFinish:(NSArray *)recommendListSource
{
    recommendSource = [recommendListSource mutableCopy];
    
    [self requestImages];
}

- (void)requestError:(NSError *)error Task:(NSURLSessionDataTask *)task
{
    [SVProgressHUD dismiss];
    
    [RWRequsetManager warningToViewController:self Title:@"网络连接失败，请稍后再试。" Click:^{
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)requestImages
{
    dispatch_group_t imageGroup = dispatch_group_create();
    
    for (int i = 0; i < recommendSource.count; i++)
    {
        dispatch_group_async(imageGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSInteger identifier = (NSInteger)i;
            
            NSURL *imageURL =
            [NSURL URLWithString:[recommendSource[identifier] objectForKey:@"img"]];
            
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            NSMutableDictionary *mDic = [recommendSource[identifier] mutableCopy];
            
            [mDic removeObjectForKey:@"img"];
            
            [mDic setObject:imageData forKey:@"img"];
            
            [recommendSource removeObjectAtIndex:identifier];
            
            [recommendSource insertObject:mDic atIndex:identifier];
        });
    }
    
    dispatch_group_notify(imageGroup, dispatch_get_main_queue(), ^{
       
        [recommendList reloadData];
        
        [SVProgressHUD dismiss];
    });
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
