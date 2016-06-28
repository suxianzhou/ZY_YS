//
//  RWSetPasswordController.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/10.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWSetPasswordController.h"
#import "RWLoginTableViewCell.h"
#import <SXColorGradientView.h>
#import "RWRequsetManager+UserLogin.h"
#import "RWRegisterController.h"

@interface RWSetPasswordController ()

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

@implementation RWSetPasswordController

@synthesize viewList;
@synthesize requestManager;

- (void)obtainRequestManager
{
    if (!requestManager)
    {
        requestManager = [[RWRequsetManager alloc] init];
        
        requestManager.delegate = self;
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
    
    if (indexPath.row != 2)
    {
        RWTextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:textFileCell forIndexPath:indexPath];
        
        cell.headerImage = [UIImage imageNamed:@"PassWord"];
        cell.placeholder = @"请输入您的密码";
        
        if (indexPath.row == 1)
        {
            cell.placeholder = @"请再次输入您的密码";
        }
        
        cell.textFiled.secureTextEntry = YES;
        
        return cell;
    }
    else
    {
        RWButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:buttonCell forIndexPath:indexPath];
        
        cell.delegate = self;
        
        cell.title = @"确定";
        
        return cell;
    }
}

- (void)button:(UIButton *)button ClickWithTitle:(NSString *)title
{
    [self registerButtonAction:button];
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
    
    if (_type == RWVerificationTypeForgetPassword)
    {
        self.title = @"忘记密码";
    }
    else
    {
        self.title = @"注册";
    }
    
    [self initViewList];
}

-(void)registerButtonAction:(UIButton *)button
{
    [self obtainRequestManager];
    
    __block RWTextFiledCell *passwordFiled = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    __block RWTextFiledCell *surePasswordFiled = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    NSString *password     = [NSString stringWithString:passwordFiled.textFiled.text];
    
    NSString *surePassword = [NSString stringWithString:
                                                    surePasswordFiled.textFiled.text];
    
    passwordFiled.textFiled.text = nil;
    
    surePasswordFiled.textFiled.text = nil;
    
    if (![requestManager verificationPassword:password])
    {
        [RWRequsetManager warningToViewController:self
                                            Title:@"密码长度为 6 - 18 位，请重新输入"
                                            Click:^{
                                                
            passwordFiled.textFiled.text = nil;
                                                
            surePasswordFiled.textFiled.text = nil;
                                                
            [passwordFiled.textFiled becomeFirstResponder];
        }];
        
        return;
    }

    if ([password isEqualToString:surePassword])
    {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        
        [SVProgressHUD show];
        
        [self obtainRequestManager];
        
        if (_type == RWVerificationTypeRegister)
        {
            [requestManager registerWithUsername:_phoneNumber AndPassword:password];
        }
        else if (_type == RWVerificationTypeForgetPassword)
        {
            [requestManager replacePasswordWithUsername:
                                                _phoneNumber AndPassword:password];
        }
    }
    else
    {
        [RWRequsetManager warningToViewController:self
                                            Title:@"密码输入不一致，请重新输入"
                                            Click:^{
                                                
            passwordFiled.textFiled.text = nil;
                                                
            surePasswordFiled.textFiled.text = nil;
                                                
            [passwordFiled.textFiled becomeFirstResponder];
            
        }];
    }
}

- (void)registerResponds:(BOOL)isSuccessed ErrorReason:(NSString *)reason
{
    [self responds:isSuccessed Reason:reason];
}

- (void)replacePasswordResponds:(BOOL)isSuccessed ErrorReason:(NSString *)reason
{
    [self responds:isSuccessed Reason:reason];
}

- (void)responds:(BOOL)isSuccessed Reason:(NSString *)reason
{
    [SVProgressHUD dismiss];
    
    if (isSuccessed)
    {
        NSString *title;
        
        if (_type == RWVerificationTypeRegister)
        {
            title = @"注册成功";
        }
        else
        {
            title = @"修改成功";
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:reason preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];

    }
    else
    {
        NSString *title;
        
        if (_type == RWVerificationTypeRegister)
        {
            title = @"注册失败";
        }
        else
        {
            title = @"修改失败";
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:reason preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *registerAction = [UIAlertAction actionWithTitle:@"再试一次" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            NSArray *viewControllers = self.navigationController.viewControllers;
            
            for (int i = 0; i < viewControllers.count; i++)
            {
                if ([viewControllers[i] isKindOfClass:[RWRegisterController class]])
                {
                    [self.navigationController popToViewController:viewControllers[i]
                                                          animated:YES];
                    
                    break;
                }
            }
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        
        [alert addAction:registerAction];
        
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)requestError:(NSError *)error Task:(NSURLSessionDataTask *)task
{
    NSLog(@"%@",error.description);
    
    [SVProgressHUD dismiss];
    
    [RWRequsetManager warningToViewController:self
                                        Title:@"网络连接失败，请检查网络"
                                        Click:^{
                                            
                                        }];
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
