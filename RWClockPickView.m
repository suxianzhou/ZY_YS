//
//  RWClockPickView.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/12.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWClockPickView.h"

@interface RWClockPickView ()

<
    UIPickerViewDataSource,
    UIPickerViewDelegate
>

@property (nonatomic,strong)UIButton *certain;

@property (nonatomic,strong)UIButton *cancel;

@property (nonatomic,strong)UIPickerView *pickerView;

@property (nonatomic,strong)NSArray *dataSource;

@end

@implementation RWClockPickView

@synthesize pickerView;
@synthesize dataSource;
@synthesize certain;
@synthesize cancel;

+ (instancetype)pickerViewWithFrame:(CGRect)frame PickerViewType:(RWClockPickerType)type Delegate:(id)anyObject Context:(NSDictionary *)context
{
    RWClockPickView *mySelf = [[RWClockPickView alloc]init];
    
    mySelf.frame = frame;
    
    mySelf.type = type;
    
    mySelf.delegate = anyObject;
    
    mySelf.contexts = [context mutableCopy];
    
    return mySelf;
}

- (void)setAddTopButton:(BOOL)addTopButton
{
    _addTopButton = addTopButton;
    
    if (!_addTopButton)
    {
        [pickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.top.equalTo(self.mas_top).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(0);
        }];
        
        [certain removeFromSuperview];
        
        [cancel removeFromSuperview];
    }
}

- (void)setContexts:(NSMutableDictionary *)contexts
{
    _contexts = contexts;
    
    if (_contexts.count <= dataSource.count)
    {
        for (int i = 0; i < _contexts.count; i++)
        {
            NSString *key = [NSString stringWithFormat:@"%d",i];
            
            NSString *context = contexts[key];
            
            for (int j = 0; i < [dataSource[i] count]; j++)
            {
                if ([dataSource[i][j] isEqualToString:context])
                {
                    [pickerView selectRow:j inComponent:i animated:NO];
                    
                    break;
                }
            }
        }
    }
}

- (void)addTimeSymbol
{
    UILabel *Symbol = [[UILabel alloc]init];
    
    [pickerView addSubview:Symbol];
    
    Symbol.text = @":";
    
    Symbol.font = [UIFont systemFontOfSize:27];
    
    Symbol.textAlignment = NSTextAlignmentCenter;
    
    [Symbol mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(20));
        make.height.equalTo(@(40));
        make.centerX.equalTo(pickerView.mas_centerX).offset(0);
        make.centerY.equalTo(pickerView.mas_centerY).offset(-3);
    }];
}

- (void)setType:(RWClockPickerType)type
{
    _type = type;
    
    switch (_type) {
            
        case RWClockPickerTypeOfTime:
        {
            dataSource = [self timeSource];
            
            [self addTimeSymbol];
        }
            break;
        case RWClockPickerTypeOfWeek:
        {
            dataSource = [self weekSource];
        }
            break;
        case RWClockPickerTypeOfCycle:
        {
            dataSource = [self cycleSource];
        }
            break;
        case RWClockPickerTypeOfDate:
        {
            dataSource = [self dateSource];
        }
            break;
            
        default:
            break;
    }
    
    [pickerView reloadAllComponents];
}

- (void)initPickerView
{
    self.backgroundColor = MAIN_COLOR;
    
    certain = [[UIButton alloc]init];
    
    [self addSubview:certain];
    
    [certain setTitle:@"确定" forState:UIControlStateNormal];
    
    [certain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [certain addTarget:self action:@selector(certainBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    cancel  = [[UIButton alloc]init];
    
    [self addSubview:cancel];
    
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    
    [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [cancel addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    pickerView = [[UIPickerView alloc]init];
    
    pickerView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:pickerView];
    
    pickerView.delegate = self;
    pickerView.dataSource = self;
}

- (void)certainBtnClick
{
    if (_type == RWClockPickerTypeOfTime)
    {
        [self.delegate pickerView:self
            CertainClickOfContext:[NSString stringWithFormat:@"%@:%@",
                                                _contexts[@"0"],_contexts[@"1"]]];
    }
    else
    {
        [self.delegate pickerView:self CertainClickOfContext:_contexts[@"0"]];
    }
}

- (void)cancelBtnClick
{
    [self.delegate pickerView:self CancelClickOfType:_type];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (_type == RWClockPickerTypeOfDate)
    {
        return 3;
    }
    
    return dataSource.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [dataSource[component] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return dataSource[component][row];
}

- (NSArray *)dateSource
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy"];
    
    int faceYear = [dateFormatter stringFromDate:[NSDate date]].intValue;
    
    NSMutableArray *years = [[NSMutableArray alloc] init];
    
    for (int i = faceYear; i < faceYear+20; i++)
    {
        [years addObject:[NSString stringWithFormat:@"%d年",i]];
    }
    
    NSMutableArray *months = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= 12; i++)
    {
        [months addObject:[NSString stringWithFormat:@"%.2d月",i]];
    }
    
    NSMutableArray *days31 = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= 31; i++)
    {
        [days31 addObject:[NSString stringWithFormat:@"%.2d日",i]];
    }
    
    NSMutableArray *days30 = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= 30; i++)
    {
        [days30 addObject:[NSString stringWithFormat:@"%.2d日",i]];
    }
    
    NSMutableArray *days28 = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= 28; i++)
    {
        [days28 addObject:[NSString stringWithFormat:@"%.2d日",i]];
    }
    
    NSMutableArray *days29 = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= 29; i++)
    {
        [days29 addObject:[NSString stringWithFormat:@"%.2d日",i]];
    }
    
    return @[years,months,days31,days30,days28,days29];
}

- (NSArray *)weekSource
{
    return @[@[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"]];
}

- (NSArray *)cycleSource
{
    return @[@[@"每天",@"每周",@"无"]];
}

- (NSArray *)timeSource
{
    NSMutableArray *hours = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 24; i++)
    {
        [hours addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    NSMutableArray *minute = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 60; i++)
    {
        [minute addObject:[NSString stringWithFormat:@"%.2d",i]];
    }
    
    return @[hours,minute];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (_type == RWClockPickerTypeOfTime)
    {
        return 60;
    }
    
    return 100;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_type == RWClockPickerTypeOfDate)
    {
        if (component == 1)
        {
            [self reloadDataWithMonth:dataSource[component][row]];
        }
        else if (component == 0)
        {
            [self reloadDataWithYear:dataSource[component][row]];
        }
    }
    
    NSString *componentString = [NSString stringWithFormat:@"%d",(int)component];
    
    [_contexts setValue:dataSource[component][row] forKey:componentString];
}

- (void)reloadDataWithMonth:(NSString *)monthString
{
    NSInteger month = monthString.integerValue;
    
    NSMutableArray *copyDataSource = [dataSource mutableCopy];
    
    if (month == 2)
    {
        NSInteger year = [[dataSource[0] objectAtIndex:
                                [pickerView selectedRowInComponent:0]] integerValue];
        
        if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0)
        {
            if ([dataSource[2] count] == 28)
            {
                [copyDataSource exchangeObjectAtIndex:RWClockDaysCountOf31
                                    withObjectAtIndex:RWClockDaysCountOf28];
                
                [copyDataSource exchangeObjectAtIndex:RWClockDaysCountOf31
                                    withObjectAtIndex:RWClockDaysCountOf29];
            }
            else if ([dataSource[2] count] == 30)
            {
                [copyDataSource exchangeObjectAtIndex:RWClockDaysCountOf31
                                    withObjectAtIndex:RWClockDaysCountOf30];
                
                [copyDataSource exchangeObjectAtIndex:RWClockDaysCountOf31
                                    withObjectAtIndex:RWClockDaysCountOf29];
            }
            else if ([dataSource[2] count] == 31)
            {
                [copyDataSource exchangeObjectAtIndex:RWClockDaysCountOf31
                                    withObjectAtIndex:RWClockDaysCountOf29];
            }
        }
        else
        {
            if ([dataSource[2] count] == 29)
            {
                [copyDataSource exchangeObjectAtIndex:RWClockDaysCountOf31
                                    withObjectAtIndex:RWClockDaysCountOf29];
                
                [copyDataSource exchangeObjectAtIndex:RWClockDaysCountOf31
                                    withObjectAtIndex:RWClockDaysCountOf28];
            }
            else if ([dataSource[2] count] == 30)
            {
                [copyDataSource exchangeObjectAtIndex:RWClockDaysCountOf31
                                    withObjectAtIndex:RWClockDaysCountOf30];
                
                [copyDataSource exchangeObjectAtIndex:RWClockDaysCountOf31
                                    withObjectAtIndex:RWClockDaysCountOf28];
            }
            else if ([dataSource[2] count] == 31)
            {
                [copyDataSource exchangeObjectAtIndex:RWClockDaysCountOf31
                                    withObjectAtIndex:RWClockDaysCountOf28];
            }
        }
    }
    else if (month == 4 || month == 6 || month == 9 || month == 11)
    {
        if ([dataSource[2] count] == 29)
        {
            [copyDataSource exchangeObjectAtIndex:RWClockDaysCountOf31
                                withObjectAtIndex:RWClockDaysCountOf29];
            
            [copyDataSource exchangeObjectAtIndex:RWClockDaysCountOf31
                                withObjectAtIndex:RWClockDaysCountOf30];
        }
        else if ([dataSource[2] count] == 28)
        {
            [copyDataSource exchangeObjectAtIndex:RWClockDaysCountOf31
                                withObjectAtIndex:RWClockDaysCountOf28];
            
            [copyDataSource exchangeObjectAtIndex:RWClockDaysCountOf31
                                withObjectAtIndex:RWClockDaysCountOf30];
        }
        else if ([dataSource[2] count] == 31)
        {
            [copyDataSource exchangeObjectAtIndex:RWClockDaysCountOf31
                                withObjectAtIndex:RWClockDaysCountOf30];
        }
    }
    else
    {
        if ([dataSource[2] count] == 29)
        {
            [copyDataSource exchangeObjectAtIndex:RWClockDaysCountOf31
                                withObjectAtIndex:RWClockDaysCountOf29];
        }
        else if ([dataSource[2] count] == 28)
        {
            [copyDataSource exchangeObjectAtIndex:RWClockDaysCountOf31
                                withObjectAtIndex:RWClockDaysCountOf28];
        }
        else if ([dataSource[2] count] == 30)
        {
            [copyDataSource exchangeObjectAtIndex:RWClockDaysCountOf31
                                withObjectAtIndex:RWClockDaysCountOf30];
        }
    }
    
    dataSource = copyDataSource;
    
    [pickerView reloadComponent:RWClockDaysCountOf31];
}

- (void)reloadDataWithYear:(NSString *)yearString
{
    NSInteger month = [[dataSource[1] objectAtIndex:
                                [pickerView selectedRowInComponent:1]] integerValue];
    
    if (month != 2)
    {
        return;
    }
    
    NSInteger year = yearString.integerValue;
    
    NSMutableArray *copyDataSource = [dataSource mutableCopy];
    
    if ((year % 4 == 0 && year % 100 != 0)||year % 400 == 0)
    {
        if ([dataSource[2] count] == 28)
        {
            [copyDataSource exchangeObjectAtIndex:RWClockDaysCountOf31
                                withObjectAtIndex:RWClockDaysCountOf28];
            
            [copyDataSource exchangeObjectAtIndex:RWClockDaysCountOf31
                                withObjectAtIndex:RWClockDaysCountOf29];
        }
        else if ([dataSource[2] count] == 30)
        {
            [copyDataSource exchangeObjectAtIndex:RWClockDaysCountOf31
                                withObjectAtIndex:RWClockDaysCountOf30];
            
            [copyDataSource exchangeObjectAtIndex:RWClockDaysCountOf31
                                withObjectAtIndex:RWClockDaysCountOf29];
        }
        else if ([dataSource[2] count] == 31)
        {
            [copyDataSource exchangeObjectAtIndex:RWClockDaysCountOf31
                                withObjectAtIndex:RWClockDaysCountOf29];
        }
    }
    else
    {
        if ([dataSource[2] count] == 29)
        {
            [copyDataSource exchangeObjectAtIndex:RWClockDaysCountOf31
                                withObjectAtIndex:RWClockDaysCountOf29];
            
            [copyDataSource exchangeObjectAtIndex:RWClockDaysCountOf31
                                withObjectAtIndex:RWClockDaysCountOf28];
        }
        else if ([dataSource[2] count] == 30)
        {
            [copyDataSource exchangeObjectAtIndex:RWClockDaysCountOf31
                                withObjectAtIndex:RWClockDaysCountOf30];
            
            [copyDataSource exchangeObjectAtIndex:RWClockDaysCountOf31
                                withObjectAtIndex:RWClockDaysCountOf28];
        }
        else if ([dataSource[2] count] == 31)
        {
            [copyDataSource exchangeObjectAtIndex:RWClockDaysCountOf31
                                withObjectAtIndex:RWClockDaysCountOf28];
        }
    }
    
    dataSource = copyDataSource;
    
    [pickerView reloadComponent:RWClockDaysCountOf31];
}

#pragma mark - init

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _contexts = [[NSMutableDictionary alloc]init];
        
        [self initPickerView];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self.mas_top).offset(30);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
    
    [certain mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(pickerView.mas_top).offset(0);
        make.width.equalTo(@(60));
    }];
    
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(pickerView.mas_top).offset(0);
        make.width.equalTo(@(60));
    }];
}

@end
