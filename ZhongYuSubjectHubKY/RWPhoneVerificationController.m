//
//  RWPhoneVerificationController.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/24.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWPhoneVerificationController.h"
#import "RWLoginTableViewCell.h"
#import "RWRequsetManager+UserLogin.h"
#import "RWNewRegisterViewController.h"
#import "RWForGotPWViewController.h"

@interface RWPhoneVerificationController ()

<
    UITableViewDelegate,
    UITableViewDataSource,
    RWRequsetDelegate,
    RWTextFiledCellDelegate,
    RWLoginCellDelegate,
    UITextFieldDelegate
>

@property (strong, nonatomic)UITableView *viewList;

@property (strong, nonatomic)RWRequsetManager *requestManager;

@property (strong,nonatomic)RwLoginButtonsCell * loginButtonCell;

@property (weak, nonatomic)UIButton *clickBtn;

@property (assign ,nonatomic)NSInteger countDown;

@property (nonatomic,assign)CGPoint viewCenter;

@property (weak ,nonatomic)NSTimer *timer;

@property (nonatomic ,strong)NSString *facePlaceHolder;

@property (nonatomic,strong)UIView *contrast;

@property (nonatomic,strong)NSString *username;

@property(nonatomic,strong)NSString * password;
@end

static NSString *const textFileCell = @"textFileCell";

static NSString *const buttonCell = @"buttonCell";

@implementation RWPhoneVerificationController

@synthesize viewList;
@synthesize requestManager;
@synthesize countDown;
@synthesize clickBtn;
@synthesize viewCenter;
@synthesize facePlaceHolder;
@synthesize contrast;
@synthesize username;
@synthesize password;


#pragma mark AutoSize Keyboard
/**
 *  获取键盘通知
 */
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}
/**
 *  在键盘将要弹出来时，执行
 *
 */
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
    RwLoginButtonsCell * buttonsCell=[viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    buttonsCell.userInteractionEnabled=NO;
}
/**
 *   在键盘将要隐藏时
 */
- (void) keyboardWasHidden:(NSNotification *) notif
{
    [UIView animateWithDuration:0.3 animations:^{
        
        
        self.navigationController.view.center = viewCenter;
    }];
    RwLoginButtonsCell * buttonsCell=[viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    buttonsCell.userInteractionEnabled=YES;
    
}

#pragma mark - views

/**
 *   检测网络错误
 */
- (void)requestError:(NSError *)error Task:(NSURLSessionDataTask *)task
{
    NSLog(@"%@",error.description);
    
    [SVProgressHUD dismiss];
    
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
/**
 *  条件触摸手势
 */
- (void)addTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(releaseFirstResponder)];
    
    tap.numberOfTapsRequired = 1;
    
    [viewList addGestureRecognizer:tap];
}
/**
 *  触摸时后的事件
 */
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
/**
 *  创建整体的UI效果
 */
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
    
    [viewList registerClass:[RwLoginButtonsCell class] forCellReuseIdentifier:buttonCell];
}

-(void)buttonWithLogin:(UIButton *)button
{
    [self userLogin];
}

#pragma mark tableView的代理方法
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
    
    return 1;
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
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            cell.headerImage = [UIImage imageNamed:@"PassWordw"];
            cell.placeholder = @" 请输入密码";
            cell.textFiled.secureTextEntry=YES;
            button.frame = CGRectMake(self.view.bounds.size.width - 75 , 12.5, 60, 25);
            [button setTitle:@"忘记密码" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            button.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.4];
            [button addTarget:self action:@selector(buttonClickWithPW:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.cornerRadius = 8;
            [cell addSubview:button];

           
        }
        
        return cell;
    }
    else
    {
        RwLoginButtonsCell *cell = [tableView dequeueReusableCellWithIdentifier:buttonCell forIndexPath:indexPath];
        
        _loginButtonCell = cell;
        
        cell.delegate = self;

        [cell.buttonLogin setTitle:@"登录" forState:(UIControlStateNormal)];
        [cell.registerButton setTitle:@"注册" forState:(UIControlStateNormal)];
        
        return cell;
    }
}

/**
 *  点击忘记密码时跳转
 */
-(void)buttonClickWithPW:(UIButton *)button{
    RWForGotPWViewController * FGVC=[[RWForGotPWViewController alloc]init];
    [self.navigationController pushViewController:FGVC animated:YES];
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
        return self.view.frame.size.height / 2.5 - 55 * 2;
    }
    
    return  40; //self.view.frame.size.height * 0.02;
}
/**
 *  组透视图
 */
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
            make.bottom.equalTo(backView.mas_bottom).offset(-20);
        }];
        
        return backView;
    }
    
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==1) {
    
        
        return  self.view.frame.size.height*0.35;
    }
    
    return 0;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if(section==1)
    {
        UIView *backView = [[UIView alloc]init];
        
        backView.backgroundColor = [UIColor clearColor];

        UIButton * blockButton=[[UIButton alloc]init];
        [blockButton setTitle:@"跳过登录进入试用" forState:(UIControlStateNormal)];
        
        blockButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:14];
        [blockButton addTarget:self action:@selector(block:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [backView addSubview:blockButton];
        
        [blockButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(@(150));
            make.height.equalTo(@(30));
            make.centerX.equalTo(backView.mas_centerX).offset(0);
            make.bottom.equalTo(backView.mas_bottom).offset(-30);
        }];
        
        return backView;
    }
    
    
    return nil;
    
}
-(void)block:(UIButton *)Button{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
/**
 *  注册
 */
-(void)buttonWithRegister
{
    RWNewRegisterViewController * registerVC=[[RWNewRegisterViewController alloc]init];
    [ self.navigationController pushViewController:registerVC animated:YES
     ];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MAIN_NAV
    
    contrast = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    contrast.backgroundColor = [UIColor blackColor];
    
    viewCenter = self.navigationController.view.center;
    
    countDown = 60;
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.view.backgroundColor =[UIColor whiteColor];
    self.title = @"登录";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    
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

-(void)userLogin
{
    [self obtainRequestManager];
    
    __block RWTextFiledCell *textCell = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    NSString *phoneNumber = textCell.textFiled.text;

    __block RWTextFiledCell *verCell = [viewList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    NSString *userPassword = verCell.textFiled.text;
    
    
    if ([requestManager verificationPhoneNumber:phoneNumber])
    {
        
        if ([requestManager verificationPassword:userPassword])
        {
            
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            
            [SVProgressHUD show];
            
            [requestManager userinfoWithUsername:phoneNumber AndPassword:userPassword];
        }
        else
        {
            
            [RWRequsetManager warningToViewController:self
             
                                                Title:@"密码输入错误"
             
                                                Click:^
            {
                                                    
                textCell.textFiled.text = nil;
                
                [textCell.textFiled becomeFirstResponder];
            }];
        }

    
    
        

    }else{
        
        
        [RWRequsetManager warningToViewController:self
                                            Title:@"手机号输入有误,请重新输入"
                                            Click:^{
                                                
                                                verCell.textFiled.text = nil;
                                                
                                                [verCell
                                                 .textFiled becomeFirstResponder];
                                            }];

        
        
    }
}

- (void)dismissView
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillShowNotification name:nil object:self];
    [[NSNotificationCenter defaultCenter ] removeObserver:UIKeyboardWillHideNotification name:nil object:self];
}

- (void)userLoginResponds:(BOOL)isSuccessed ErrorReason:(NSString *)reason
{
    [SVProgressHUD dismiss];
    
    if (isSuccessed)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [RWRequsetManager warningToViewController:self
                                            Title:reason
                                            Click:nil];
    }
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    CATransition *transition = [CATransition animation];
    
    transition.type = @"rippleEffect";
    
    transition.subtype = @"fromLeft";
    
    transition.duration = 1;
    
    [self.view.layer addAnimation:transition forKey:nil];
    
    [super dismissViewControllerAnimated:flag completion:completion];
}

@end
