//
//  RWFeedbackViewController.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/15.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWFeedbackViewController.h"
#import "RWLoginTableViewCell.h"
#import <SXColorGradientView.h>
#import "RWRequsetManager+UserLogin.h"

@interface RWFeedbackViewController ()

<
    UITableViewDelegate,
    UITableViewDataSource,
    RWButtonCellDelegate
>

@property (strong, nonatomic)UITableView *viewList;

@end

static NSString *const textViewCell = @"FeedBackViewCell";

static NSString *const textFiledCell = @"FeedBackFiledCell";

static NSString *const buttonCell = @"FeedBackbuttonCell";

@implementation RWFeedbackViewController

@synthesize viewList;

- (void)addTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(releaseFirstResponder)];
    
    tap.numberOfTapsRequired = 1;
    
    [viewList addGestureRecognizer:tap];
}

- (void)releaseFirstResponder
{
    RWTextViewCell *FeedbackCell = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] ;
    
    if (FeedbackCell.inputTextView.isFirstResponder)
    {
        [FeedbackCell.inputTextView resignFirstResponder];
    }
    
    RWTextFiledCell *phoneNumberFiled = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    if (phoneNumberFiled.textFiled.isFirstResponder)
    {
        [phoneNumberFiled.textFiled resignFirstResponder];
    }
    
    RWTextFiledCell *emailFiled = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    
    if (emailFiled.textFiled.isFirstResponder)
    {
        [emailFiled.textFiled resignFirstResponder];
    }
}

- (void)initViewList
{
    viewList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    
    viewList.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.jpg"]];
    
    [self.view addSubview:viewList];
    
    [viewList mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    viewList.showsVerticalScrollIndicator = NO;
    viewList.showsHorizontalScrollIndicator = NO;
    
    viewList.allowsSelection = NO;
    viewList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    viewList.delegate = self;
    viewList.dataSource = self;
    
    [viewList registerClass:[RWTextViewCell class]
     forCellReuseIdentifier:textViewCell];
    
    [viewList registerClass:[RWTextFiledCell class]
     forCellReuseIdentifier:textFiledCell];
    
    [viewList registerClass:[RWButtonCell class]
     forCellReuseIdentifier:buttonCell];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        RWTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                                textViewCell forIndexPath:indexPath];
        
        cell.placeholderText = @"请输入您的意见或建议，最多不超过140字";
        
        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;
    }
    else if (indexPath.section == 1 || indexPath.section == 2)
    {
        RWTextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                                textFiledCell forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor whiteColor];
        
        if (indexPath.section == 1)
        {
            cell.placeholder = @"请输入手机号";
            cell.textFiled.keyboardType = UIKeyboardTypeNumberPad;
        }
        else
        {
            cell.placeholder = @"请输入E-Mail (选填)";
        }
        
        return cell;
    }
    else
    {
        RWButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:buttonCell forIndexPath:indexPath];
        
        cell.delegate = self;
        
        cell.title = @"提交意见反馈";
        
        return cell;
    }
}

- (void)button:(UIButton *)button ClickWithTitle:(NSString *)title
{
    RWRequsetManager *requestManager = [[RWRequsetManager alloc] init];
    
    __block RWTextViewCell *FeedbackCell = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] ;
    
    NSString *feedBackStr = FeedbackCell.inputTextView.text;
    
    if (feedBackStr.length < 1 || feedBackStr.length > 140)
    {
        [RWRequsetManager warningToViewController:self Title:@"文字不能为空并且文字长度不得超过140字" Click:^{
            
            [FeedbackCell.inputTextView becomeFirstResponder];
        }];
        
        return;
    }
    
    __block RWTextFiledCell *phoneNumberFiled = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    if (![requestManager verificationPhoneNumber:phoneNumberFiled.textFiled.text])
    {
        [RWRequsetManager warningToViewController:self Title:@"手机号码输入有误，请重新输入" Click:^{
            
            phoneNumberFiled.textFiled.text = nil;
           
            [phoneNumberFiled.textFiled becomeFirstResponder];
        }];
        
        return;
    }
    
    __block RWTextFiledCell *emailFiled = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    
    if (emailFiled.textFiled.text.length > 0 &&
        ![requestManager verificationEmail:emailFiled.textFiled.text])
    {
        [RWRequsetManager warningToViewController:self Title:@"邮箱地址输入有误，请重新输入" Click:^{
        
            emailFiled.textFiled.text = nil;
        
            [emailFiled.textFiled becomeFirstResponder];
        }];
        
        return;
    }
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    [SVProgressHUD show];

    __block RWFeedbackViewController *weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
        [SVProgressHUD dismiss];
            
        if (requestManager.reachabilityStatus == AFNetworkReachabilityStatusUnknown)
        {
            [RWRequsetManager warningToViewController:self Title:@"网络状态异常，请稍后再试。" Click:^{
                    
            }];
        }
        else
        {
            [RWRequsetManager warningToViewController:self Title:@"提交成功，感谢您的意见和建议。" Click:^{
                    
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
    });
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 200;
    }
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.view.frame.size.height *0.16;
    }
    else if (section == 1 || section == 2)
    {
        return 1;
    }
    
    return self.view.frame.size.height * 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 0)
    {
        UIView *backView = [[UIView alloc]init];
        
        backView.backgroundColor = [UIColor clearColor];
        
        SXColorGradientView *gradientView = [SXColorGradientView createWithColorArray:
                                             @[[UIColor blackColor],Wonderful_WhiteColor10] frame:
                                             CGRectMake(20, 27,
                                                        self.view.frame.size.width - 40,
                                                        self.view.frame.size.height
                                                        * 0.3 + 250)
                                                                            direction:
                                             SXGradientToBottom];
        
        gradientView.alpha = 0.3;
        
        gradientView.layer.cornerRadius = 10;
        
        gradientView.clipsToBounds = YES;
        
        [backView addSubview:gradientView];
        
        [gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(backView.mas_left).offset(40);
            make.right.equalTo(backView.mas_right).offset(-40);
            make.top.equalTo(backView.mas_top).offset(20);
            make.bottom.equalTo(backView.mas_bottom).offset(-20);
        }];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        
        titleLabel.text = @"意  见  反  馈";
        
        titleLabel.numberOfLines = 0;
        
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold"size:20];
        
        titleLabel.textColor = [UIColor whiteColor];
        
        [backView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(backView.mas_left).offset(40);
            make.right.equalTo(backView.mas_right).offset(-40);
            make.top.equalTo(backView.mas_top).offset(20);
            make.bottom.equalTo(backView.mas_bottom).offset(-20);
        }];
        
        return backView;
    }
    
    return nil;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MAIN_NAV
    
    HIDDEN_TABBAR
    
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.view.backgroundColor =[UIColor whiteColor];
    self.title = @"意见反馈";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self initViewList];
    [self addTapGesture];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    SHOW_TABBAR
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
