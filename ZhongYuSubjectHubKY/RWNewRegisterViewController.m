//
//  RWNewRegisterViewController.m
//  ZhongYuSubjectHubKY
//
//  Created by 中域 on 16/6/15.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//
#import "RWPhoneVerificationController.h"
#import "RWLoginTableViewCell.h"
#import "RWRequsetManager+UserLogin.h"
#import "RWNewRegisterViewController.h"
#import "RWAboutLoginViewController.h"

@interface RWNewRegisterViewController()

<
    UITableViewDelegate,
    UITableViewDataSource,
    RWRequsetDelegate,
    RWTextFiledCellDelegate,
    RWButtonCellDelegate,
    UITextFieldDelegate
>

@property (strong, nonatomic)UITableView *viewList;

@property (weak ,nonatomic)NSTimer *timer;

@property (strong, nonatomic)RWRequsetManager *requestManager;

@property (weak, nonatomic)RWDeployManager *deployManager;

@property (strong,nonatomic)RWButtonCell * loginButtonCell;

@property (weak, nonatomic)UIButton *clickBtn;

@property (assign ,nonatomic)NSInteger countDown;

@property (nonatomic,assign)CGPoint viewCenter;

@property (nonatomic ,strong)NSString *facePlaceHolder;

@property (nonatomic,strong)UIView *contrast;

@end

static NSString *const textFileCell = @"textFileCell";

static NSString *const buttonCell = @"buttonCell";

@implementation RWNewRegisterViewController

@synthesize viewList;
@synthesize requestManager;
@synthesize deployManager;
@synthesize countDown;
@synthesize clickBtn;
@synthesize viewCenter;
@synthesize facePlaceHolder;
@synthesize contrast;

#pragma mark AutoSize Keyboard

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    
    CGSize keyboardSize = [value CGRectValue].size;
    
    NSInteger gap = self.view.frame.size.height - keyboardSize.height;
    
    NSInteger height;
    
    if ([facePlaceHolder isEqualToString:@"请输入手机号"])
    {
        height = self.view.frame.size.height *0.3 + 50 * 4;
    }
    else
    {
        height = self.view.frame.size.height *0.3 + 50 * 4;
    }
    
    if (self.navigationController.view.center.y == viewCenter.y + gap - height)
    {
        return;
    }
    
    if (gap - height < 0)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            CGPoint viewPt =  self.navigationController.view.center;
            
            viewPt.y += gap - height;
            
            self.navigationController.view.center = viewPt;
        }];
    }
}

- (void) keyboardWasHidden:(NSNotification *) notif
{
    [UIView animateWithDuration:0.3 animations:^{
        
        
        self.navigationController.view.center = viewCenter;
    }];
    
}
- (void)dismissView
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - views

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
    viewList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    
    viewList.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"textBack"]];
    
    [self.view addSubview:viewList];
     [viewList mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(70);
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section

{
    
    return 20;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        RWTextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:textFileCell forIndexPath:indexPath];
        
        cell.delegate = self;
        
        if (indexPath.row == 0)
        {
            cell.textFiled.keyboardType=UIKeyboardTypeDecimalPad;
            cell.headerImage = [UIImage imageNamed:@"Loginw"];
            cell.placeholder = @" 请输入手机号";
        }
        else
        {
            cell.textFiled.keyboardType=UIKeyboardTypeDecimalPad;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            cell.headerImage = [UIImage imageNamed:@"PassWordw"];
            cell.placeholder = @" 请输入验证码";
            
            button.frame = CGRectMake(self.view.bounds.size.width - 95 , 12.5, 80, 30);
            [button setTitle:@"获取验证码" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            button.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.4];
            [button addTarget:self action:@selector(buttonClickwithIdentify:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.cornerRadius = 8;
            [cell addSubview:button];
        }
        
        return cell;
    }
    else
    {
        
        RWButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:buttonCell forIndexPath:indexPath];
        
        _loginButtonCell = cell;
        
        cell.delegate = self;
        
        if (indexPath.row==0)
        {
            cell.title = @"上一步";
            cell.button.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.4];
            cell.button.tag=101;
            
        }
        else
        {
            cell.title = @"下一步";
            cell.button.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.4];
            cell.button.tag=102;
            
        }
        return cell;
        
    }
}

-(void)buttonClickwithIdentify:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"获取验证码"])
    {
        clickBtn=button;
        [self userRegisterWithButton];
    }
}

- (void)textFiledCell:(RWTextFiledCell *)cell DidBeginEditing:(NSString *)placeholder
{
    facePlaceHolder = placeholder;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.view.frame.size.height /2.5 - 55 * 2;
    }
    
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *backView = [[UIView alloc]init];
        
        backView.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        
        titleLabel.text = @"ZHONGYU · 中域";
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont fontWithName:@"STXingkai-SC-Bold"size:30];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.shadowOffset = CGSizeMake(1, 1);
        titleLabel.shadowColor = [UIColor goldColor];
        
        [backView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(backView.mas_left).offset(40);
            make.right.equalTo(backView.mas_right).offset(-40);
            make.top.equalTo(backView.mas_top).offset(20);
            make.bottom.equalTo(backView.mas_bottom).offset(-10);
        }];
        
        return backView;
    }
    
    return nil;
}

/**
 *  点击下一步按钮
 */
-(void)button:(UIButton *)button ClickWithTitle:(NSString *)title{
    
    if (button.tag == 101)
    {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else
    {
        [self verificationCodeWithCode];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MAIN_NAV
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.view.backgroundColor =[UIColor whiteColor];
    self.title = @"注册手机号";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    contrast = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    contrast.backgroundColor = [UIColor blackColor];
    
    viewCenter = self.navigationController.view.center;
    
    countDown = 60;
    
    requestManager = [[RWRequsetManager alloc] init];
    
    [self registerForKeyboardNotifications];
    [self initViewList];
    [self addTapGesture];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [clickBtn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    
    if (requestManager && requestManager.delegate == nil)
    {
        requestManager.delegate = self;
    }
    
    [self.view.window insertSubview:contrast atIndex:1];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    requestManager.delegate = nil;
    [contrast removeFromSuperview];
}

/**
 *  注册验证
 */
#pragma mark  注册验证

-(void)userRegisterWithButton
{
    [self obtainRequestManager];
    
    __block RWTextFiledCell *textCell = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    NSString *phoneNumber = textCell.textFiled.text;
    
    __block RWTextFiledCell *verCell = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    verCell.textFiled.text = nil;
    
    if ([requestManager verificationPhoneNumber:phoneNumber])
    {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        
        [SVProgressHUD show];
        
        [requestManager obtainVerificationCodeWithPhoneNumber:phoneNumber
                                                     Complate:^(BOOL isSuccessed)
        {
            [SVProgressHUD dismiss];
            
            if (isSuccessed)
            {
                [self timerStart];
                
                [textCell.textFiled becomeFirstResponder];
            }
            else
            {
                
                [RWRequsetManager warningToViewController:self
                                                    Title:@"验证码获取失败"
                                                    Click:^
                {
                    textCell.textFiled.text = nil;
                    
                    [textCell.textFiled  becomeFirstResponder];
                    
                 }];
            }
        }];
    }
    else
    {
        [RWRequsetManager warningToViewController:self
                                            Title:@"手机号输入有误,请重新输入"
                                            Click:^
        {
            textCell.textFiled.text = nil;
            
            [textCell.textFiled becomeFirstResponder];
        }];
    }

}



- (void)timerStart
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(renovateSecond) userInfo:nil repeats:YES];
}

- (void)renovateSecond
{
    if (countDown <= 0)
    {
        [_timer setFireDate:[NSDate distantFuture]];
        
        [clickBtn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
        
        return;
    }
    
    countDown --;
    [clickBtn setTitle:[NSString stringWithFormat:@"%dS",(int)countDown] forState:UIControlStateNormal];
    
}

-(void)verificationCodeWithCode
{

    [_timer setFireDate:[NSDate distantFuture]];
    
    RWTextFiledCell *phoneNumberCell = [viewList cellForRowAtIndexPath:
                                        [NSIndexPath indexPathForRow:0 inSection:0]];
    
    RWTextFiledCell *verificationCell = [viewList cellForRowAtIndexPath:
                                         [NSIndexPath indexPathForRow:1 inSection:0]];
    
    if ([requestManager verificationPhoneNumber:phoneNumberCell.textFiled.text])
    {
        if (!verificationCell.textFiled.text)
        {
            [RWRequsetManager warningToViewController:self
                                                Title:@"请输入验证码"
                                                Click:nil];
        }
        
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        
        [SVProgressHUD show];
        
        [requestManager verificationWithVerificationCode:verificationCell.textFiled.text
                                             PhoneNumber:phoneNumberCell.textFiled.text
                                                Complate:^(BOOL isSuccessed)
         {
             [SVProgressHUD dismiss];
             
             if (isSuccessed)
             {
                 
                 
                 RWAboutLoginViewController *ALVC=[[RWAboutLoginViewController alloc]init];
                 ALVC.userPassword=phoneNumberCell.textFiled.text;
                 [self.navigationController pushViewController:ALVC animated:YES];
                 
             }
             else
             {
                 
                 [RWRequsetManager warningToViewController:self
                                                     Title:@"验证失败"
                                                     Click:nil];
             }
        }];
    
    }
    else
    {
    
        [RWRequsetManager warningToViewController:self
                                            Title:@"手机号码输入错误"
                                            Click:nil];
    }
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillShowNotification name:nil object:self];
    [[NSNotificationCenter defaultCenter ] removeObserver:UIKeyboardWillHideNotification name:nil object:self];
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
