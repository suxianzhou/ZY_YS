//
//  RWCountDownController.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/24.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWCountDownController.h"
#import "RWSetAttributeCell.h"
#import "RWClockPickView.h"
#import "RWPickerViewCell.h"
#import "RWClockSwitchCell.h"

typedef NS_ENUM(NSInteger,RWResource)
{
    RWResourceOfName = 0,
    RWResourceOfDate = 2,
    RWResourceOfTime = 5
};

@interface RWCountDownController ()

<
    UITableViewDelegate,
    UITableViewDataSource,
    RWClockPickViewDelegate,
    RWClockSwitchDelegate
>

@property (nonatomic,strong) UITableView *attribteList;

@property (nonatomic,assign) NSInteger attribteListLine;

@property (nonatomic,strong) RWDeployManager *deployManager;

@property (nonatomic,strong) UIView *coverLayer;

@property (nonatomic,strong) NSMutableArray *clockSource;

@end

static NSString *const attribteCell = @"attribteCell";

static NSString *const pickerCell = @"pickerCell";

static NSString *const plainCell = @"plainCell";

static NSString *const switchCell = @"testClcok";

@implementation RWCountDownController

@synthesize attribteList;
@synthesize attribteListLine;
@synthesize deployManager;
@synthesize coverLayer;
@synthesize clockSource;

- (void)initResource
{
    deployManager = [RWDeployManager defaultManager];
    
    clockSource = [NSMutableArray arrayWithArray:@[@"考试名称",@"",@{},@"",@"",@{}]];
    
    attribteListLine = 4;
    
    NSString *testDate = [deployManager deployValueForKey:TEST_DATE];
    
    if (testDate)
    {
        NSArray *testDates = [testDate componentsSeparatedByString:@"()"];
        
        if (testDates.count == 2)
        {
            [clockSource removeObjectAtIndex:RWResourceOfName];
            [clockSource insertObject:testDates[0] atIndex:RWResourceOfName];
            
            NSArray *dates = [testDates[1] componentsSeparatedByString:@"-"];
            
            if (dates.count == 3)
            {
                NSDictionary *contexts = @{@"0":dates[0],@"1":dates[1],@"2":dates[2]};
                
                [clockSource removeObjectAtIndex:RWResourceOfDate];
                [clockSource insertObject:contexts atIndex:RWResourceOfDate];
            }
        }
    }
    
    NSString *testClock = [deployManager deployValueForKey:TEST_CLOCK];
    
    if (![testClock isEqualToString:RWNOTFOUND])
    {
        NSArray *testClocks = [testClock componentsSeparatedByString:@"$"];
        
        if (testClocks.count == 2)
        {
            NSArray *times = [testClocks[1] componentsSeparatedByString:@":"];
            
            if (times.count == 3)
            {
                NSDictionary *contexts = @{@"0":times[0],@"1":times[1]};
                
                [clockSource removeObjectAtIndex:RWResourceOfTime];
                [clockSource insertObject:contexts atIndex:RWResourceOfTime];
                
                attribteListLine = 6;
            }
        }
    }
}

- (void)initCoverLayer
{
    CGRect rect =
        CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 50);
    
    coverLayer = [[UIView alloc]initWithFrame:rect];
    
    [self.view addSubview:coverLayer];
    
    coverLayer.backgroundColor = [UIColor lightGrayColor];
    
    coverLayer.alpha = 0.2;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(promptWithReSetClock)];
    
    tap.numberOfTapsRequired = 1;
    
    [coverLayer addGestureRecognizer:tap];
}

- (void)promptWithReSetClock
{
    NSString *title =
                @"变更提醒设置请先点击屏幕右上方的\n\n“取消提醒”按钮\n\n变更后重新保存提醒设置";
    
    [self warningWrongInformation:title Handle:^{
        
    }];
}

- (void)clockSwitch:(UISwitch *)clockSwitch ClickWithEvents:(UIControlEvents)events
{
    if (clockSwitch.on)
    {
        attribteListLine = 6;
        
        [attribteList reloadData];
    }
    else
    {
        attribteListLine = 4;
        
        [deployManager removeDeployValueForKey:TEST_CLOCK];
        
        [attribteList reloadData];
    }
}

- (void)initNavgationBar
{
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"考试提醒";
    
    NSString *title = [clockSource[RWResourceOfDate] count] == 0?
                                                                @"保存提醒" : @"取消提醒";
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(buttonClock:)];
    
    self.navigationItem.rightBarButtonItem = button;
    
}

- (void)buttonClock:(UIBarButtonItem *)button;
{
    if ([button.title isEqualToString:@"保存提醒"])
    {
        if (![self checkTestInformation])
        {
            return;
        }
        
        NSString *name = clockSource[RWResourceOfName];
        
        RWPickerViewCell *dateCell = [attribteList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        
        NSDictionary *contexts = dateCell.pickerView.contexts;
        
        NSString *dateString = [NSString stringWithFormat:
                                @"%@()%@-%@-%@",name,contexts[@"0"],contexts[@"1"],contexts[@"2"]];
        
        BOOL testSec = [deployManager setDeployValue:dateString forKey:TEST_DATE];
        
        BOOL clockSec = YES;
        
        if (attribteListLine == 6)
        {
            RWPickerViewCell *timeCell = [attribteList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
            
            contexts = timeCell.pickerView.contexts;
            
            NSString *timeString = [NSString stringWithFormat:
                                    @"%@$%@:%@:00",dateString,contexts[@"0"],
                                    contexts[@"1"]];

            clockSec = [deployManager setDeployValue:timeString forKey:TEST_CLOCK];
        }
        
        if (testSec && clockSec)
        {
            if (!coverLayer)
            {
                [self initCoverLayer];
            }
            else
            {
                [self.view addSubview:coverLayer];
            }
            
            button.title = @"取消提醒";
            
            [self warningWrongInformation:@"设置成功" Handle:^{
                
            }];
        }
    }
    else
    {
        [deployManager removeDeployValueForKey:TEST_DATE];
        
        [deployManager setDeployValue:RWNOTFOUND forKey:TEST_CLOCK];
        
        button.title = @"保存提醒";
        
        [coverLayer removeFromSuperview];
    }
}

- (void)warningWrongInformation:(NSString *)title Handle:(void(^)())handle
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"友情提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *registerAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        handle();
    }];
    
    [alert addAction:registerAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)checkTestInformation
{
    NSString *name = clockSource[RWResourceOfName];
    
    if ( name == nil || name.length == 0 ||
        [name isEqualToString:@""]       ||
        [name isEqualToString:@"考试名称"] ||
        [name isKindOfClass:[NSNull class]] )
    {
        [self warningWrongInformation:@"请输入考试名称" Handle:^{
            
            [self inputTextForClockName];
        }];
        
        return NO;
    }
    
    RWPickerViewCell *dateCell = [attribteList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    NSDictionary *contexts = dateCell.pickerView.contexts;
    
    NSString *dateString = [NSString stringWithFormat:
                            @"%@-%@-%@",contexts[@"0"],contexts[@"1"],contexts[@"2"]];
    
    if (attribteListLine == 6)
    {
        RWPickerViewCell *timeCell = [attribteList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
        
        contexts = timeCell.pickerView.contexts;
        
        dateString = [NSString stringWithFormat:
                                @"%@$%@:%@:00",dateString,contexts[@"0"],
                                contexts[@"1"]];
    }
    
    NSInteger distance = [deployManager
                distanceWithBeginMoments:[deployManager momentWithDate:[NSDate date]]
                           AndEndMoments:[deployManager momentWithString:dateString]];
    if (distance <= 0)
    {
        [self warningWrongInformation:@"考试时间必须大于当前时间" Handle:^{
            
        }];
        
        return NO;
    }
    
    return YES;
}

- (NSString *)clearString:(NSString *)string
{
    NSRange range = NSMakeRange(string.length - 2, 2);
    
    if ([[string substringWithRange:range] isEqualToString:@"考试"])
    {
        NSMutableString *mString = [string mutableCopy];
        
        [mString deleteCharactersInRange:range];
        
        return mString;
    }
    else
    {
        return string;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2 || indexPath.row == 5)
    {
        return 120;
    }
    
    return 50;
}

- (void)initAttribteList
{
    attribteList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    
    [self.view addSubview:attribteList];
    
    [attribteList mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    attribteList.showsVerticalScrollIndicator = NO;
    attribteList.showsHorizontalScrollIndicator = NO;
    
    attribteList.delegate = self;
    attribteList.dataSource = self;
    
    [attribteList registerClass:[RWSetAttributeCell class]
         forCellReuseIdentifier:attribteCell];
    
    [attribteList registerClass:[RWPickerViewCell class]
         forCellReuseIdentifier:pickerCell];
    
    [attribteList registerClass:[UITableViewCell class]
         forCellReuseIdentifier:plainCell];
    
    [attribteList registerClass:[RWClockSwitchCell class]
         forCellReuseIdentifier:switchCell];
    
    if ([clockSource[RWResourceOfDate] count] != 0)
    {
        if (!coverLayer)
        {
            [self initCoverLayer];
        }
        else
        {
            [self.view addSubview:coverLayer];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return attribteListLine;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row)
    {
        case 0:
        {
            RWSetAttributeCell *cell = [tableView dequeueReusableCellWithIdentifier:attribteCell forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.textLabel.text = @"考试名称:";
            
            cell.attributeField.text = clockSource[indexPath.row];
            
            return cell;
        }
        case 1:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:plainCell forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textLabel.text = @"考试时间:";
            
            return cell;
        }
        case 2:
        {
            RWPickerViewCell *cell =
                            [tableView dequeueReusableCellWithIdentifier:pickerCell
                                                            forIndexPath:indexPath];
            
            cell.type = RWClockPickerTypeOfDate;
            
            cell.contexts = clockSource[indexPath.row];
            
            [clockSource removeObjectAtIndex:RWResourceOfDate];
            
            [clockSource insertObject:cell.pickerView.contexts
                              atIndex:RWResourceOfDate];
            
            return cell;
        }
        case 3:
        {
            RWClockSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                       switchCell forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textLabel.text = @"考试提醒";
            
            cell.clockSwitch.on = attribteListLine == 6 ? YES : NO;
            
            cell.delegate = self;
            
            return cell;
        }
        case 4:
        {
            RWSetAttributeCell *cell = [tableView dequeueReusableCellWithIdentifier:attribteCell forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textLabel.text = @"提醒时间:";
            
            cell.attributeField.text = @"每天";
            
            cell.attributeField.userInteractionEnabled = NO;

            return cell;
        }
            
        default:
        {
            RWPickerViewCell *cell =
            [tableView dequeueReusableCellWithIdentifier:pickerCell
                                            forIndexPath:indexPath];
            
            cell.type = RWClockPickerTypeOfTime;
            
            cell.contexts = clockSource[indexPath.row];
            
            [clockSource removeObjectAtIndex:RWResourceOfTime];
            
            [clockSource insertObject:cell.pickerView.contexts
                              atIndex:RWResourceOfTime];
            
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        [self inputTextForClockName];
    }
}

- (void)inputTextForClockName
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    __block UITextField *text;
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        text = textField;
    }];
    
    UIAlertAction *registerAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [clockSource removeObjectAtIndex:RWResourceOfName];
        
        [clockSource insertObject:text.text atIndex:RWResourceOfName];
        
        [attribteList reloadData];
    }];
    
    [alert addAction:registerAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initResource];
    
    [self initNavgationBar];
    
    [self initAttribteList];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    HIDDEN_TABBAR
    
    [attribteList reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    SHOW_TABBAR
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
