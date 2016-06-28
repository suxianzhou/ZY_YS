
//
//  RWInformationViewController.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/4/26.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWInformationViewController.h"
#import "RWLoginViewController.h"
#import "RWClassListCell.h"
#import "RWRequsetManager.h"
#import "MJRefresh.h"
#import "RWRegisterNowView.h"

#define APPOINTMENT @"appointment"

@interface RWInformationViewController ()

<
    UITableViewDelegate,
    UITableViewDataSource,
    RWClassListDelegate,
    RWRequsetDelegate,
    RWRegisterNowViewDelegate
>

@property (nonatomic,strong)UITableView *classList;

@property (nonatomic,strong)NSMutableArray *classSource;

@property (nonatomic,strong)RWRequsetManager *requsetManager;

@property (nonatomic,strong)RWRegisterNowView *registerView;

@end

static NSString *const classListCell = @"classListCell";

@implementation RWInformationViewController

@synthesize classList;
@synthesize classSource;
@synthesize requsetManager;
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

- (void)addMJRefresh
{
    classList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [requsetManager obtainClassList];
    }];
}

- (void)initClassList
{
    classList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    
    [self.view addSubview:classList];
    
    [classList mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    classList.delegate = self;
    classList.dataSource = self;
    
    classList.showsHorizontalScrollIndicator = NO;
    
    [self addMJRefresh];
    
    [classList registerClass:[RWClassListCell class] forCellReuseIdentifier:classListCell];
}

- (void)initBar
{
    self.navigationItem.title = @"直播课";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.translucent = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

#pragma mark - Life Cycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    RWDeployManager *deploy = [RWDeployManager defaultManager];

    if ([[deploy deployValueForKey:LOGIN] isEqualToString:NOT_LOGIN])
    {
        if ([[deploy deployValueForKey:TIMES_BUFFER] integerValue] < 100)
        {
            [self notLogin];
            
            return;
        }
    }
    
    if (registerView)
    {
        [registerView removeFromSuperview];
    }
    
    
    if (!requsetManager)
    {
        requsetManager = [[RWRequsetManager alloc] init];
        requsetManager.delegate = self;
        
        [requsetManager obtainClassList];
    }
    
    if (requsetManager.delegate != self)
    {
        requsetManager.delegate = self;
    }
}

- (void)classListDownloadDidFinish:(NSMutableArray *)classListSource
{
    classSource = classListSource;
    
    [classList reloadData];
    
    [classList.mj_header endRefreshing];
}

- (void)requestError:(NSError *)error Task:(NSURLSessionDataTask *)task
{
    [classList.mj_header endRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    MAIN_NAV
    [self initBar];
    // Do any additional setup after loading the view.
    [self initClassList];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return classSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RWClassListCell *cell = [tableView dequeueReusableCellWithIdentifier:classListCell forIndexPath:indexPath];
    
    NSArray *appointments =
                    [[NSUserDefaults standardUserDefaults] objectForKey:APPOINTMENT];
    
    if (appointments)
    {
        for (int i = 0; i < appointments.count; i++)
        {
            if ([appointments[i] integerValue] ==
                [[classSource[indexPath.row] valueForKey:@"yid"] integerValue]) {
                
                cell.didAppointment = YES;
                
                break;
            }
        }
    }
    
    cell.yid = [classSource[indexPath.row] valueForKey:@"yid"];
    
    cell.delegate = self;
    
    cell.header = [classSource[indexPath.row] valueForKey:@"title"];
    
    cell.content = [classSource[indexPath.row] valueForKey:@"teacher"];
    
    cell.date = [classSource[indexPath.row] valueForKey:@"date"];
    
    cell.userInfo = classSource[indexPath.row];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
       
        NSURL *imageURL = [NSURL URLWithString:[classSource[indexPath.row] valueForKey:@"pic"]];
        
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            cell.image = [UIImage imageWithData:imageData];
        });
    });

    return cell;
}

- (void)classListCell:(RWClassListCell *)classListCell AppointmentClick:(UIButton *)button yid:(NSNumber *)yid
{
    if (classListCell.didAppointment)
    {
        NSMutableArray *appointments =
        [[[NSUserDefaults standardUserDefaults] objectForKey:APPOINTMENT] mutableCopy];
        
        for (int i = 0; i < appointments.count; i++)
        {
            if ([appointments[i] integerValue] == yid.integerValue) {
                
                [appointments removeObjectAtIndex:i];
                
                [[NSUserDefaults standardUserDefaults] setObject:appointments forKey:APPOINTMENT];
                
                classListCell.didAppointment = NO;
                
                break;
            }
        }
    }
    else
    {
        [requsetManager postUserName:[[RWDeployManager defaultManager] deployValueForKey:USERNAME] Complete:^(BOOL isSucceed, NSString *reason, NSError *error) {
            
            if (error)
            {
                [RWRequsetManager warningToViewController:self
                                                    Title:@"网络请求失败，请检查网络"
                                                    Click:nil];
                
                return ;
            }
            
            if (!isSucceed)
            {
                [RWRequsetManager warningToViewController:self
                                                    Title:reason
                                                    Click:nil];
            }
            else
            {
                NSMutableArray *appointments =
                    [[[NSUserDefaults standardUserDefaults] objectForKey:APPOINTMENT]mutableCopy];
                
                if (appointments)
                {
                    [appointments addObject:yid];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:appointments
                                                              forKey:APPOINTMENT];
                }
                else
                {
                    appointments = [[NSMutableArray alloc] init];
                    
                    [appointments addObject:yid];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:appointments
                                                              forKey:APPOINTMENT];
                }
                
                classListCell.didAppointment = YES;
                
                NSString *wechat = [classListCell.userInfo valueForKey:@"wechat"];
                NSString *name = [classListCell.userInfo valueForKey:@"name"];
                NSString *phonenumber =
                            [classListCell.userInfo valueForKey:@"phonenumber"];
                
                NSString *noti = [NSString stringWithFormat:@"%@\n\n电话：%@\n微信：%@",name,phonenumber,wechat];
                
                UIAlertController *alert =
                    [UIAlertController alertControllerWithTitle:@"友情提示"
                                                        message:noti
                                                 preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *call = [UIAlertAction actionWithTitle:@"立即拨打" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phonenumber]]];
                }];
                
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alert addAction:call];
                
                [alert addAction:cancel];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
        
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
