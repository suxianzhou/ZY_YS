//
//  RWLoginViewController.m
//  ZhongYuSubjectHubKY
//
//  Created by Wcx on 16/4/27.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWLoginViewController.h"
#import "RWRegisterViewController.h"
#import "RWRegisterController.h"
#import "RWLoginTableViewCell.h"
#import <SXColorGradientView.h>
#import "RWRequsetManager+UserLogin.h"
#import "UMComPushRequest.h"
#import "UMComUserAccount.h"

@interface RWLoginViewController ()

<
    UITableViewDelegate,
    UITableViewDataSource,
    RWButtonCellDelegate,
    RWRequsetDelegate
>

@property (strong, nonatomic)UITableView *viewList;

@property (strong, nonatomic)RWRequsetManager *requestManager;

@property (strong, nonatomic)RWDeployManager *deployManager;

@property (strong, nonatomic)NSString *username;

@property (strong, nonatomic)NSString *password;

@property (weak, nonatomic)UIButton *clickBtn;

@end

static NSString *const textFileCell = @"textFileCell";

static NSString *const buttonCell = @"buttonCell";

@implementation RWLoginViewController

@synthesize viewList;
@synthesize requestManager;
@synthesize username;
@synthesize password;
@synthesize deployManager;
@synthesize clickBtn;

- (void)obtainDeployManager
{
    if (!deployManager)
    {
        deployManager = [RWDeployManager defaultManager];
    }
}

- (void)requestError:(NSError *)error Task:(NSURLSessionDataTask *)task
{
    NSLog(@"%@",error.description);
    
    [RWRequsetManager warningToViewController:self
                                        Title:@"网络连接失败，请检查网络"
                                        Click:nil];
}

- (void)obtainRequestManager
{
    
    if (!requestManager)
    {
        requestManager = [[RWRequsetManager alloc]init];
        
        requestManager.delegate = self;
    }
}

- (void)addTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(releaseFirstResponder)];
    
    tap.numberOfTapsRequired = 1;
    
    [viewList addGestureRecognizer:tap];
}

- (void)releaseFirstResponder
{
    RWTextFiledCell *usernameFiled = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    if (usernameFiled.textFiled.isFirstResponder)
    {
        [usernameFiled.textFiled resignFirstResponder];
    }
    
    RWTextFiledCell *passwordFiled = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    if (passwordFiled.textFiled.isFirstResponder)
    {
        [passwordFiled.textFiled resignFirstResponder];
    }
}

- (void)initViewList
{
    viewList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    
    viewList.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.jpg"]];
    
    [self.view addSubview:viewList];
    
    SXColorGradientView *gradientView = [SXColorGradientView createWithColorArray:
                                         @[[UIColor blackColor],Wonderful_WhiteColor10] frame:
                                         CGRectMake(20, 20,
                                                    self.view.frame.size.width - 40,
                                                    self.view.frame.size.height
                                                    * 0.3 + 300)
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        RWTextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:textFileCell forIndexPath:indexPath];
        
        if (indexPath.row == 0)
        {
            cell.headerImage = [UIImage imageNamed:@"Loginw"];
            cell.placeholder = @"请输入账号";
            cell.textFiled.keyboardType = UIKeyboardTypeNumberPad;
        }
        else
        {
            cell.headerImage = [UIImage imageNamed:@"PassWord"];
            cell.placeholder = @"请输入密码";
            cell.textFiled.secureTextEntry = YES;
        }
        
        return cell;
    }
    else
    {
        RWButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:buttonCell forIndexPath:indexPath];
        
        cell.delegate = self;
        
        if (indexPath.row == 0)
        {
            cell.title = @"登录";
        }
        else if (indexPath.row == 1)
        {
            cell.title = @"注册";
        }
        else if (indexPath.row == 2)
        {
            cell.title = @"忘记密码";
        }
        else if (indexPath.row == 3)
        {
            cell.title = @"免费体验";
        }
        
        return cell;
    }
}

- (void)button:(UIButton *)button ClickWithTitle:(NSString *)title
{
    
    if ([title isEqualToString:@"登录"])
    {
        [self userLogin];
    }
    else if ([title isEqualToString:@"注册"])
    {
        [self verificationWithType:RWVerificationTypeRegister];
    }
    else if ([title isEqualToString:@"忘记密码"])
    {
        [self verificationWithType:RWVerificationTypeForgetPassword];
    }
    else
    {
        [self ExperienceTheView];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.view.frame.size.height *0.25;
    }
    
    return self.view.frame.size.height * 0.05;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 0)
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
    
    MAIN_NAV
    
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.view.backgroundColor =[UIColor whiteColor];
    self.title = @"登录";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self initViewList];
    [self addTapGesture];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)userLogin
{
    
    __block RWTextFiledCell *userCell = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    __block RWTextFiledCell *passCell = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    username = userCell.textFiled.text;
    
    password = passCell.textFiled.text;
    
//    
//    UMComUserAccount *userAccount = [[UMComUserAccount alloc] init];
//    userAccount.usid = userCell.textFiled.text;
//    userAccount.name = userCell.textFiled.text;
//    ////登录之前先设置登录前的viewController，方便登录逻辑完成之后，跳转回来
//    [UMComPushRequest loginWithCustomAccountForUser:userAccount completion:^(id responseObject, NSError *error) {
//        
//        NSLog(@"res = %@",responseObject);
//        
//        if(!error){
//            //登录成功
//            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//            
//        }else{
//            //登录失败
//            NSLog(@"登录失败");
//        }
//    }];

    
    
    [self obtainRequestManager];
    
    if (![requestManager verificationPhoneNumber:username])
    {
        [RWRequsetManager warningToViewController:self
                                            Title:@"账号输入有误，请重新输入"
                                            Click:^{
            
            userCell.textFiled.text = nil;
            
            passCell.textFiled.text = nil;
            
            [userCell.textFiled becomeFirstResponder];
            
        }];
        
        return;
    }
    if (![requestManager verificationPassword:password])
    {
        [RWRequsetManager warningToViewController:self Title:@"密码长度为 6 - 18 位"
                                            Click:^{
            
            passCell.textFiled.text = nil;
            
            [passCell.textFiled becomeFirstResponder];
            
        }];
        
        return;
    }
    
    clickBtn.userInteractionEnabled = NO;
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    [SVProgressHUD setFont:[UIFont systemFontOfSize:14]];
    
    [SVProgressHUD showWithStatus:@"登录中..."];
    
    [self obtainRequestManager];
    
    [requestManager userinfoWithUsername:username AndPassword:password];
}

- (void)userLoginResponds:(BOOL)isSuccessed ErrorReason:(NSString *)reason
{
    [SVProgressHUD dismiss];
    
    if (isSuccessed)
    {
        [self obtainDeployManager];
        
        [deployManager setDeployValue:username forKey:USERNAME];
        
        [deployManager setDeployValue:password forKey:PASSWORD];
        
        [deployManager setDeployValue:DID_LOGIN forKey:LOGIN];
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [RWRequsetManager warningToViewController:self Title:reason Click:^{
            
            RWTextFiledCell *userCell = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            
            RWTextFiledCell *passCell = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            
            userCell.textFiled.text = nil;
            
            passCell.textFiled.text = nil;
            
        }];
    }
    
    clickBtn.userInteractionEnabled = YES;
}

-(void)verificationWithType:(RWVerificationType)type
{
    RWRegisterController *registerController =[[RWRegisterController alloc]init];
    
    registerController.type = type;
    
    [self.navigationController pushViewController:registerController animated:YES];
}

- (void)ExperienceTheView
{
    [self obtainDeployManager];
    
    [deployManager setDeployValue:EXPERIENCE_VIEW forKey:LOGIN];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
