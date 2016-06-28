//
//  RWVerificationController.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/10.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWVerificationController.h"
#import "RWLoginTableViewCell.h"
#import "RWRequsetManager+UserLogin.h"
#import <SXColorGradientView.h>

@interface RWVerificationController ()


<
    UITableViewDelegate,
    UITableViewDataSource,
    RWButtonCellDelegate,
    UITextFieldDelegate,
    RWRequsetDelegate
>

@property (strong, nonatomic)UITableView *viewList;

@property (strong, nonatomic)RWRequsetManager *requestManager;

@property (weak ,nonatomic)UIButton *again;

@property (assign ,nonatomic)NSInteger countDown;

@property (weak ,nonatomic)NSTimer *timer;

@end

static NSString *const textFileCell = @"textFileCell";

static NSString *const buttonCell = @"buttonCell";

@implementation RWVerificationController

@synthesize viewList;
@synthesize requestManager;
@synthesize countDown;

- (void)addTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(releaseFirstResponder)];
    
    tap.numberOfTapsRequired = 1;
    
    [viewList addGestureRecognizer:tap];
}

- (void)releaseFirstResponder
{
    RWTextFiledCell *cell = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    if (cell.textFiled.isFirstResponder)
    {
        [cell.textFiled resignFirstResponder];
    }
}

- (void)initViewList
{
    viewList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    
    viewList.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.jpg"]];
    
    [self.view addSubview:viewList];
    
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
    
    [viewList.backgroundView addSubview:gradientView];
    
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
    
    [viewList registerClass:[RWTextFiledCell class] forCellReuseIdentifier:textFileCell];
    
    [viewList registerClass:[RWButtonCell class] forCellReuseIdentifier:buttonCell];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0)
    {
        RWTextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:textFileCell forIndexPath:indexPath];
        
        cell.headerImage = [UIImage imageNamed:@"PassWord"];
        cell.placeholder = @"请输入验证码";
        cell.textFiled.keyboardType = UIKeyboardTypeNumberPad;
        cell.textFiled.delegate = self;
        
        return cell;
    }
    else if (indexPath.row == 1)
    {
        RWButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:buttonCell forIndexPath:indexPath];
        
        cell.delegate = self;
        
        cell.title = @"确定";
        
        return cell;
    }
    else
    {
        RWButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:buttonCell forIndexPath:indexPath];
        
        cell.delegate = self;
        
        cell.title = @"60";
        
        return cell;
    }
}

- (void)button:(UIButton *)button ClickWithTitle:(NSString *)title
{
    if ([title isEqualToString:@"确定"])
    {
        [self verificationCodeWithCode];
    }
    else if ([title isEqualToString:@"重新获取验证码"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return self.view.frame.size.height *0.25;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 0 && _type == RWVerificationTypeRegister)
    {
        UIView *backView = [[UIView alloc]init];
        
        backView.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        
        titleLabel.text = @"免费注册\n\n立即下载海量题库及历年真题";
        
        titleLabel.numberOfLines = 0;
        
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold"size:18];
        
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

- (void)verificationCodeWithCode
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    [SVProgressHUD show];
    
    [_timer setFireDate:[NSDate distantFuture]];
    
    RWTextFiledCell *cell = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    [requestManager verificationWithVerificationCode:cell.textFiled.text PhoneNumber:_phoneNumber Complate:^(BOOL isSuccessed) {
        
        [SVProgressHUD dismiss];
       
        if (isSuccessed)
        {
            [self setPassword];
        }
        else
        {
            RWButtonCell *cell = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            
            cell.title = @"重新获取验证码";
            
            [RWRequsetManager warningToViewController:self Title:@"验证失败" Click:^{
                
            }];
        }
    }];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"输入验证码";
    
    countDown = 60;
    
    requestManager = [[RWRequsetManager alloc] init];
    
    requestManager.delegate = self;
    
    [self initViewList];
    
    [self addTapGesture];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self timerStart];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_timer.fireDate == [NSDate distantPast])
    {
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)timerStart
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(renovateSecond) userInfo:nil repeats:YES];
}

- (void)renovateSecond
{
    RWButtonCell *cell = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    if (countDown <= 0)
    {
        [_timer setFireDate:[NSDate distantFuture]];
        
        cell.title = @"重新获取验证码";
        
        return;
    }
    
    countDown --;
    
    cell.title = [NSString stringWithFormat:@"%d",(int)countDown];
}

- (void)setPassword
{
    RWSetPasswordController *passwordController = [[RWSetPasswordController alloc]init];
    
    passwordController.phoneNumber = _phoneNumber;
    
    passwordController.type = _type;
    
    [self.navigationController pushViewController:passwordController animated:YES];
}

- (void)requestError:(NSError *)error Task:(NSURLSessionDataTask *)task
{
    [SVProgressHUD dismiss];
    
    [RWRequsetManager warningToViewController:self
                                        Title:@"网络连接失败，请检查网络"
                                        Click:^{
                                            
                                        }];
}


@end
