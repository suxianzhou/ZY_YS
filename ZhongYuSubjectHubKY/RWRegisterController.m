//
//  RWRegisterController.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/10.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWRegisterController.h"
#import "RWLoginTableViewCell.h"
#import "RWRequsetManager+UserLogin.h"
#import <SXColorGradientView.h>

@interface RWRegisterController ()

<
    UITableViewDelegate,
    UITableViewDataSource,
    RWButtonCellDelegate,
    RWRequsetDelegate
>

@property (strong, nonatomic)UITableView *viewList;

@property (strong, nonatomic)RWRequsetManager *requestManager;

@end

static NSString *const textFileCell = @"textFileCell";

static NSString *const buttonCell = @"buttonCell";

@implementation RWRegisterController

@synthesize viewList;
@synthesize requestManager;

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
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0)
    {
        RWTextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:textFileCell forIndexPath:indexPath];
        
        cell.headerImage = [UIImage imageNamed:@"Loginw"];
        cell.placeholder = @"请输入您的手机号";
        cell.textFiled.keyboardType = UIKeyboardTypeNumberPad;
        
        return cell;
    }
    else
    {
        RWButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:buttonCell forIndexPath:indexPath];
        
        cell.delegate = self;
        
        cell.title = @"获取验证码";
        
        return cell;
    }
}

- (void)button:(UIButton *)button ClickWithTitle:(NSString *)title
{
    [self userRegister];
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

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (!requestManager)
    {
        requestManager = [[RWRequsetManager alloc]init];
        
        requestManager.delegate = self;
    }
    
    if (_type == RWVerificationTypeRegister)
    {
        self.navigationItem.title = @"注册";
    }
    else
    {
        self.navigationItem.title = @"忘记密码";
    }
    
    [self initViewList];
    [self addTapGesture];
}

-(void)userRegister
{
    __block RWTextFiledCell *textCell = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    NSString *phoneNumber = textCell.textFiled.text;
    
    if ([requestManager verificationPhoneNumber:phoneNumber])
    {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        
        [SVProgressHUD show];
        
        [requestManager obtainVerificationCodeWithPhoneNumber:phoneNumber
                                                     Complate:^(BOOL isSuccessed) {
                [SVProgressHUD dismiss];
                                
                if (isSuccessed)
                {
                    RWVerificationController *verification =
                                                [[RWVerificationController alloc] init];
                    
                    verification.phoneNumber = phoneNumber;
                    
                    verification.type = _type;
                    
                    [self.navigationController pushViewController:verification animated:YES];
                }
                else
                {
                    [RWRequsetManager warningToViewController:self
                                                        Title:@"验证码获取失败"
                                                        Click:^{
                                                            
                          textCell.textFiled.text = nil;
                                                            
                          [textCell.textFiled becomeFirstResponder];
                    }];
                }
        }];
    }
    else
    {
        [RWRequsetManager warningToViewController:self
                                            Title:@"手机号输入有误,请重新输入"
                                            Click:^{
                                                
                textCell.textFiled.text = nil;
                                                
                [textCell.textFiled becomeFirstResponder];
        }];
    }
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
