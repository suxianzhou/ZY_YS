//
//  RWClockAttributeController.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/12.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWClockAttributeController.h"
#import "RWSetAttributeCell.h"
#import "RWClockPickView.h"

@interface RWClockAttributeController ()

<
    UITableViewDelegate,
    UITableViewDataSource,
    RWClockPickViewDelegate
>

@property (nonatomic,strong) UITableView *attribteList;

@property (nonatomic,assign) NSInteger attribteListLine;

@property (nonatomic,strong) RWDeployManager *deployManager;

@property (nonatomic,strong) UIView *coverLayer;

@property (nonatomic,strong) NSString *cycle;

@property (nonatomic,strong)NSString *time;

@property (nonatomic,strong)NSString *week;

@end

static NSString *const attribteCell = @"attribteCell";

@implementation RWClockAttributeController

@synthesize attribteList;
@synthesize attribteListLine;
@synthesize deployManager;
@synthesize coverLayer;
@synthesize cycle;
@synthesize time;
@synthesize week;
@synthesize name;

- (void)initNavgationBar
{
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"设置提醒";
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveClock)];
    
    self.navigationItem.rightBarButtonItem = saveBtn;

}

- (void)saveClock
{
    if (![self checkClockName])
    {
        return;
    }
    
    RWClockCycle cycleType = [deployManager cycleWithString:cycle];
    
    RWClockWeek saveWeek = [deployManager clockWeekWithString:week];
    
    NSMutableString *timeStr = [time mutableCopy];
    
    NSInteger hours =
            [[[timeStr componentsSeparatedByString:@":"] firstObject] integerValue];
    
    NSInteger minute =
            [[[timeStr componentsSeparatedByString:@":"] lastObject] integerValue];
    
    NSString *clockStr = [deployManager stringClockAttribute:
                            RWClockAttributeMake(cycleType, saveWeek, hours, minute)];
    
    NSMutableArray *clockNames =
                    [[deployManager deployValueForKey:CLOCK_NAMES] mutableCopy];
    
    NSMutableArray *clocks =
                    [[deployManager deployValueForKey:CLOCK_TIMES] mutableCopy];
    
    if (!_faceIndexPath)
    {
        
        [clocks addObject:clockStr];
        
        BOOL clockSec = [deployManager setDeployValue:clocks forKey:CLOCK_TIMES];
        
        [clockNames addObject:name];
        
        BOOL nameSec = [deployManager setDeployValue:clockNames forKey:CLOCK_NAMES];
        
        if (nameSec && clockSec)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        [clocks removeObjectAtIndex:_faceIndexPath.row - 1];
        
        [clockNames removeObjectAtIndex:_faceIndexPath.row - 1];
        
        [clocks insertObject:clockStr atIndex:_faceIndexPath.row -1];
        
        BOOL clockSec = [deployManager setDeployValue:clocks forKey:CLOCK_TIMES];
        
        [clockNames insertObject:name atIndex:_faceIndexPath.row - 1];
        
        BOOL nameSec = [deployManager setDeployValue:clockNames forKey:CLOCK_NAMES];
        
        if (nameSec && clockSec)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)warningNamesWrong:(NSString *)title Handle:(void(^)())handle
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"友情提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *registerAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        handle();
    }];
    
    [alert addAction:registerAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)checkClockName
{
    NSArray *names = [deployManager deployValueForKey:CLOCK_NAMES];
    
    for (int i = 0; i < names.count; i++)
    {
        if ([names[i] isEqualToString:name])
        {
            [self warningNamesWrong:@"提醒名称重复，请重新输入" Handle:^{
                
                [self inputTextForClockName];
            }];
            
            return NO;
        }
    }
    
    if ( name == nil || name.length == 0 ||
        [name isEqualToString:@""]       ||
        [name isKindOfClass:[NSNull class]] )
    {
        [self warningNamesWrong:@"提醒名称不能为空，请输入一个名称" Handle:^{
            
            [self inputTextForClockName];
        }];
        
        return NO;
    }
    
    return YES;
}

- (void)addCoverLayers
{
    if (!coverLayer)
    {
        coverLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        coverLayer.backgroundColor = [UIColor blackColor];
        
        coverLayer.alpha = 0.7;
        
        coverLayer.userInteractionEnabled = NO;
    }
    
    attribteList.userInteractionEnabled = NO;
    
    [self.view addSubview:coverLayer];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return attribteListLine;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RWSetAttributeCell *cell = [tableView dequeueReusableCellWithIdentifier:attribteCell forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"提醒名称:";
            
            cell.attributeField.text = name;

            return cell;
        }
        case 1:
        {
            cell.textLabel.text = @"提醒周期:";
            
            cell.attributeField.text = cycle;
            
            [self setTextFiledKeyBoardWithTextFiled:cell.attributeField
                                               Type:RWClockPickerTypeOfCycle
                                              Title:cell.attributeField.text];
            
            return cell;
        }
        case 2:
        {
            cell.textLabel.text = @"提醒时间:";
            
            cell.attributeField.text = time;
            
            [self setTextFiledKeyBoardWithTextFiled:cell.attributeField
                                               Type:RWClockPickerTypeOfTime
                                              Title:cell.attributeField.text];
            
            return cell;
        }
            
        default:
        {
            cell.textLabel.text = @"提醒星期:";
            
            if (week)
            {
                cell.attributeField.text = week;
            }
            else
            {
                cell.attributeField.text = @"星期一";
                
                week = @"星期一";
            }
            
            [self setTextFiledKeyBoardWithTextFiled:cell.attributeField
                                               Type:RWClockPickerTypeOfWeek
                                              Title:cell.attributeField.text];
            
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RWSetAttributeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row != 0)
    {
        [self addCoverLayers];
        
        cell.attributeField.userInteractionEnabled = YES;
        
        [cell.attributeField becomeFirstResponder];
    }
    else
    {
        [self inputTextForClockName];
    }
}

- (void)inputTextForClockName
{
    __block RWSetAttributeCell *cell =
    [attribteList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    __block UITextField *text;
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        text = textField;
    }];
    
    UIAlertAction *registerAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        cell.attributeField.text = text.text;
        
        name = text.text;
    }];
    
    [alert addAction:registerAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setTextFiledKeyBoardWithTextFiled:(UITextField *)textFiled Type:(RWClockPickerType)type Title:(NSString *)title
{
    if (type == RWClockPickerTypeOfTime)
    {
        NSArray *times = [[title mutableCopy] componentsSeparatedByString:@":"];
        
        textFiled.inputView =
        [RWClockPickView pickerViewWithFrame:CGRectMake(0, 0, 300, 260)
                              PickerViewType:type
                                    Delegate:self
                                     Context:@{@"0":[times firstObject],
                                               @"1":[times lastObject]}];
    }
    else
    {
        textFiled.inputView =
                [RWClockPickView pickerViewWithFrame:CGRectMake(0, 0, 300, 260)
                                      PickerViewType:type
                                            Delegate:self
                                             Context:@{@"0":title}];
    }
}

- (void)pickerView:(RWClockPickView *)pickerView CertainClickOfContext:(NSString *)context
{
    RWSetAttributeCell *cell;
    
    switch (pickerView.type) {
            
        case RWClockPickerTypeOfTime:
        {
            cell = [attribteList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            
            if (context)
            {
                time = context;
            }
        }
            break;
            
        case RWClockPickerTypeOfWeek:
        {
            cell = [attribteList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
            
            if (context)
            {
                week = context;
            }
        }
            break;
            
        default:
        {
            if (![context isEqualToString:@"每天"])
            {
                if (attribteListLine != 4)
                {
                    attribteListLine = 4;
                    
                    [attribteList reloadData];
                }
            }
            else
            {
                if (attribteListLine != 3)
                {
                    attribteListLine = 3;
                    
                    [attribteList reloadData];
                }
            }
            
            cell = [attribteList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            
            if (context)
            {
                cycle = context;
            }
        }
            break;
    }
    
    if (context)
    {
        cell.attributeField.text = context;
    }

    [cell.attributeField resignFirstResponder];
    
    cell.attributeField.userInteractionEnabled = NO;
    
    [coverLayer removeFromSuperview];
    
    attribteList.userInteractionEnabled = YES;
}

- (void)pickerView:(RWClockPickView *)pickerView CancelClickOfType:(RWClockPickerType)type
{
    RWSetAttributeCell *cell;
    
    switch (type) {
            
        case RWClockPickerTypeOfTime:
        {
            cell = [attribteList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        }
            break;
            
        case RWClockPickerTypeOfWeek:
        {
            cell = [attribteList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        }
            break;
            
        default:
        {
            cell = [attribteList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        }
            break;
    }
    
    [cell.attributeField resignFirstResponder];
    
    cell.attributeField.userInteractionEnabled = NO;
    
    [coverLayer removeFromSuperview];
    
    attribteList.userInteractionEnabled = YES;
}

- (void)setAttribute:(NSString *)attribute
{
    _attribute = attribute;
    
    deployManager = [RWDeployManager defaultManager];
    
    RWClockAttribute clockAttribute =[deployManager clockAttributeWithString:_attribute];
    
    cycle = [deployManager stringClockCycle:clockAttribute.cycleType];
    
    time = [deployManager stringTimeWithClockAttribute:clockAttribute];
    
    if (clockAttribute.week == RWClockWeekOfNone)
    {
        attribteListLine = 3;
        
        week = nil;
    }
    else
    {
        attribteListLine = 4;
        
        week = [deployManager stringClockWeek:clockAttribute.week];
    }
    
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavgationBar];
    
    [self initAttribteList];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [attribteList reloadData];
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
