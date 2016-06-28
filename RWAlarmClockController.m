//
//  RWAlarmClockController.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/11.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWAlarmClockController.h"
#import "RWClockSwitchCell.h"
#import "RWClockAttributeCell.h"
#import "RWClockAttributeController.h"

@interface RWAlarmClockController ()

<
    UITableViewDelegate,
    UITableViewDataSource,
    RWClockSwitchDelegate
>

@property (nonatomic,strong)UITableView *clockList;

@property (nonatomic,strong)NSMutableArray *clockNames;

@property (nonatomic,strong)NSMutableArray *clockSource;

@property (nonatomic,strong)RWDeployManager *deployManager;

@property (nonatomic,strong)UIBarButtonItem *addClockBtn;

@end

static NSString *const switchCell = @"switchCell";

static NSString *const attributeCell  = @"AttributeCell";

@implementation RWAlarmClockController

@synthesize clockList;
@synthesize clockNames;
@synthesize clockSource;
@synthesize deployManager;
@synthesize addClockBtn;

- (void)initNavgationBar
{
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"定时提醒";
    
    addClockBtn = [[UIBarButtonItem alloc]initWithTitle:@"添加提醒" style:UIBarButtonItemStyleDone target:self action:@selector(addClock)];
}

- (void)addClock
{
    RWClockAttributeController *attrbuteController =
                                            [[RWClockAttributeController alloc ] init];
    
    BOOL findNewsName = NO;
    
    for (int i = 1; i <= clockNames.count + 1; i++)
    {
        @autoreleasepool
        {
            NSString *newName = [NSString stringWithFormat:@"提醒%d",i];
            
            for (int j = 0; j < clockNames.count; j++)
            {
                if ([newName isEqualToString:clockNames[j]])
                {
                    break;
                }
                
                if (![newName isEqualToString:clockNames[j]] && j == clockNames.count-1)
                {
                    attrbuteController.name = newName;
                    
                    findNewsName = YES;
                    
                    break;
                }
            }
        }
        
        if (findNewsName)
        {
            break;
        }
    }
    
    NSString *attribute = [deployManager stringClockAttribute:
                RWClockAttributeMake(RWClockCycleEveryDay, RWClockWeekOfNone, 8, 0)];
    
    attrbuteController.attribute = attribute;
    
    [self.navigationController pushViewController:attrbuteController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)initClockList
{
    clockList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    
    [self.view addSubview:clockList];
    
    [clockList mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
    }];
    
    clockList.showsVerticalScrollIndicator = NO;
    clockList.showsHorizontalScrollIndicator = NO;
    
    clockList.delegate = self;
    clockList.dataSource = self;
    
    [clockList registerClass:[RWClockSwitchCell class]
      forCellReuseIdentifier:switchCell];
    
    [clockList registerClass:[RWClockAttributeCell class]
      forCellReuseIdentifier:attributeCell];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return clockNames.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        RWClockSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:switchCell
                                                                forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.text = @"提醒开关";
        
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold"size:18];
        
        cell.clockSwitch.on = clockSource != nil && clockSource.count > 0 ? YES : NO;
        
        cell.delegate = self;
        
        return cell;
    }
    
    RWClockAttributeCell *cell = [tableView dequeueReusableCellWithIdentifier:attributeCell forIndexPath:indexPath];
    
    cell.name = clockNames[indexPath.row - 1];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    RWClockAttribute attribute =
                [deployManager clockAttributeWithString:
                                            clockSource[indexPath.row - 1]];
    
    if (attribute.cycleType == RWClockCycleEveryDay)
    {
        cell.week = [deployManager stringClockCycle:attribute.cycleType];
    }
    else if (attribute.cycleType == RWClockCycleEveryWeek)
    {
        cell.cycle = [deployManager stringClockCycle:attribute.cycleType];
        
        cell.week = [deployManager stringClockWeek:attribute.week];
    }
    else
    {
        cell.week = [deployManager stringClockWeek:attribute.week];
    }
    
    cell.time = [deployManager stringTimeWithClockAttribute:attribute];
    
    return cell;
}

- (void)clockSwitch:(UISwitch *)clockSwitch ClickWithEvents:(UIControlEvents)events
{
    if ([[deployManager deployValueForKey:CLOCK] isEqualToString:CLOCK_ON])
    {
        [deployManager setDeployValue:CLOCK_OFF forKey:CLOCK];
        
        clockSource = nil;
        
        clockNames  = nil;
        
        self.navigationItem.rightBarButtonItem = nil;
    }
    else
    {
        [deployManager setDeployValue:CLOCK_ON forKey:CLOCK];
        
        if ([[deployManager deployValueForKey:CLOCK_TIMES] count] > 0)
        {
            clockSource = [[deployManager deployValueForKey:CLOCK_TIMES] mutableCopy];
            
            clockNames = [[deployManager deployValueForKey:CLOCK_NAMES] mutableCopy];
        }
        else
        {
            [deployManager setDeployValue:@[DEFAULT_CLOCK] forKey:CLOCK_TIMES];
            
            [deployManager setDeployValue:@[@"提醒1"] forKey:CLOCK_NAMES];
            
            clockSource = [[deployManager deployValueForKey:CLOCK_TIMES] mutableCopy];
            
            clockNames = [[deployManager deployValueForKey:CLOCK_NAMES] mutableCopy];
        }
        
        self.navigationItem.rightBarButtonItem = addClockBtn;
        
    }
    
    [clockList reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0)
    {
        RWClockAttributeController *attrbuteController =
                                            [[RWClockAttributeController alloc ] init];
        
        attrbuteController.name = clockNames[indexPath.row - 1];
        
        attrbuteController.attribute = clockSource[indexPath.row - 1];
        
        attrbuteController.faceIndexPath = indexPath;
        
        [self.navigationController pushViewController:attrbuteController animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0)
    {
        return @"删除提醒";
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0)
    {
        NSMutableArray *clocks =
                        [[deployManager deployValueForKey:CLOCK_TIMES] mutableCopy];
        
        NSMutableArray *names =
                        [[deployManager deployValueForKey:CLOCK_NAMES] mutableCopy];
        
        [clocks removeObjectAtIndex:indexPath.row - 1];
        
        [names removeObjectAtIndex:indexPath.row - 1];
        
        [deployManager setDeployValue:clocks forKey:CLOCK_TIMES];
        
        [deployManager setDeployValue:names forKey:CLOCK_NAMES];
        
        [clockSource removeObjectAtIndex:indexPath.row - 1];
        
        [clockNames removeObjectAtIndex:indexPath.row - 1];
        
        if (clockNames.count == 0 && clockSource.count == 0)
        {
            [deployManager setDeployValue:CLOCK_OFF forKey:CLOCK];
            
            self.navigationItem.rightBarButtonItem = nil;
        }
        
        [tableView reloadData];
    }
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    HIDDEN_TABBAR
    
    deployManager = [RWDeployManager defaultManager];
    
    [self initNavgationBar];
    
    [self initClockList];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([[deployManager deployValueForKey:CLOCK] isEqualToString:CLOCK_ON])
    {
        if ([[deployManager deployValueForKey:CLOCK_TIMES] count] > 0)
        {
            clockSource = [[deployManager deployValueForKey:CLOCK_TIMES] mutableCopy];
            
            clockNames  = [[deployManager deployValueForKey:CLOCK_NAMES] mutableCopy];
        }
        else
        {
            clockSource = nil;
        }
        
        self.navigationItem.rightBarButtonItem = addClockBtn;
    }
    else
    {
        clockSource = nil;
        
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [clockList reloadData];
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
