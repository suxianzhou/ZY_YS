
//
//  RWInformationViewController.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/4/26.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWInformationViewController.h"
#import "RWLoginViewController.h"
#import "RWRequsetManager.h"
#import "RWCompleteCutView.h"
#import "RWClassListModel.h"

@interface RWInformationViewController ()

<
    RWRequsetDelegate,
    RWCompleteCutViewDelegate
>

@property (nonatomic,strong)RWCompleteCutView *cut;

@property (nonatomic,strong)NSMutableArray *classSource;

@property (nonatomic,strong)RWRequsetManager *requsetManager;

@end

@implementation RWInformationViewController

@synthesize classSource;
@synthesize requsetManager;
@synthesize cut;

- (void)initClassList
{
    cut = [[RWCompleteCutView alloc] initWithConstraint:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    [self.view addSubview:cut];
    
    cut.eventSource = self;
}

- (void)buttonDidClickWithIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)initBar
{
    self.navigationItem.title = @"视频";
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
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    [SVProgressHUD setFont:[UIFont systemFontOfSize:14]];
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
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
    
    [self obtainImages];
}

- (void)requestError:(NSError *)error Task:(NSURLSessionDataTask *)task
{
    [SVProgressHUD dismiss];
}

- (void)obtainImages
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
       
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
        for (RWClassListModel *classModel in classSource)
        {
            NSURL *imageURL = [NSURL URLWithString:classModel.pic];
            
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            UIImage *image = [UIImage imageWithData:imageData];
            
            [arr addObject:image];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            cut.cardSource = arr;
            
            [SVProgressHUD dismiss];
        });
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    MAIN_NAV
    [self initBar];
    // Do any additional setup after loading the view.
    [self initClassList];
}

@end
