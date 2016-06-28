//
//  RWAnswerViewCell.m
//  ZhongYuSubjectHubKY
//
//  Created by RyeWhiskey on 16/4/28.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWAnswerViewCell.h"
#import "RWAnswerListCell.h"
#import "RWDataBaseManager.h"

@interface RWAnswerViewCell ()

<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic,strong)RWDataBaseManager *baseManager;

@property (nonatomic,strong)UITableView *subject;

@property (nonatomic,strong)NSMutableArray *cellLength;

@property (nonatomic,assign)BOOL finishAutoLayout;

@property (nonatomic,assign)NSInteger subjectLines;

@property (nonatomic,strong)NSArray *answerNumbers;

@property (nonatomic,strong)NSIndexPath *correctIndex;

@property (nonatomic,strong)NSIndexPath *chooseIndex;

@property (nonatomic,assign)RWAnswerState answerState;

@end

static NSString *const answerList = @"answerList";

@implementation RWAnswerViewCell

@synthesize subject;
@synthesize cellLength;
@synthesize finishAutoLayout;
@synthesize subjectLines;
@synthesize displayType;
@synthesize baseManager;
@synthesize answerNumbers;
@synthesize chooseIndex;
@synthesize correctIndex;
@synthesize answerState;

- (void)chooseResponseWithIndexPath:(NSIndexPath *)indexPath
{
    correctIndex = [NSIndexPath indexPathForRow:[self answerNumber] inSection:0];
    
    RWAnswerListCell *cell = [subject cellForRowAtIndexPath:correctIndex];
    
    [cell showCorrectAnswer];
    
    RWAnswerListCell *select = [subject cellForRowAtIndexPath:indexPath];
    
    chooseIndex = indexPath;
    
    if (indexPath.row == [self answerNumber])
    {
        [select showAnswerChooseAndRight];
        
        if ([_subjectSource isKindOfClass:[RWSubjectsModel class]])
        {
            [_subjectSource setValue:[NSNumber numberWithInteger:RWAnswerStateCorrect] forKey:@"answerstate"];
            
            [_subjectSource setValue:answerNumbers[indexPath.row] forKey:@"choose"];
            
            [baseManager updateEntity:_subjectSource];
            
            answerState = RWAnswerStateCorrect;
        }
        
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        
        [SVProgressHUD setMinimumDismissTimeInterval:0.3];
        
        [SVProgressHUD setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
        
        [SVProgressHUD showSuccessWithStatus:@"正确"];
        
        [self.delegate answerCorrect];
    }
    else
    {
        
        if ([_subjectSource isKindOfClass:[RWSubjectsModel class]])
        {
            [_subjectSource setValue:[NSNumber numberWithInteger:RWAnswerStateWrong] forKey:@"answerstate"];
            
            [_subjectSource setValue:answerNumbers[indexPath.row] forKey:@"choose"];
            
            [baseManager updateEntity:_subjectSource];
        }
        
        if ([_subjectSource isKindOfClass:[RWSubjectsModel class]])
        {
            BOOL sec = [baseManager insertCollect:_subjectSource AndType:RWCollectTypeOnlyWrong];
            
            if (sec)
            {
                NSLog(@"添加错题记录");
            }
        }
        else if ([_subjectSource isKindOfClass:[RWCollectModel class]])
        {
            BOOL sec = [baseManager updateWrongTimesWith:_subjectSource];
            
            if (sec)
            {
                NSLog(@"错题次数+1");
            }
        }
        
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        
        [SVProgressHUD setMinimumDismissTimeInterval:0.3];
        
        [SVProgressHUD setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
        
        [SVProgressHUD showErrorWithStatus:@"错误"];
        
        answerState = RWAnswerStateWrong;
        
        [select showAnswerChooseAndWrong];
        
    }
}

- (void)initListLength
{
    if (!cellLength)
    {
        cellLength = [[NSMutableArray alloc]init];
    }
    else
    {
        [cellLength removeAllObjects];
    }
    
    for (int i = 0; i < 2; i ++)
    {
        NSMutableArray *itemLentght = [[NSMutableArray alloc]init];
        
        for (int j = 0; j < 6; j ++)
        {
            [itemLentght addObject:[NSNumber numberWithFloat:50]];
        }
        
        [cellLength addObject:itemLentght];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [cellLength[indexPath.section][indexPath.row] floatValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (void)setSubjectSource:(id)subjectSource
{
    _subjectSource = subjectSource;
    
    [self initListLength];
    
    finishAutoLayout = NO;
    
    chooseIndex = nil;
    
    correctIndex = nil;
    
    if ([_subjectSource isKindOfClass:[RWSubjectsModel class]] &&
        [_subjectSource valueForKey:@"answerstate"] != RWAnswerStateNone)
    {
        chooseIndex = [NSIndexPath indexPathForRow:
                            [self numberWithAnswer:
                             [_subjectSource valueForKey:@"choose"]] inSection:0];
        
        correctIndex = [NSIndexPath indexPathForRow:
                             [self numberWithAnswer:
                              [_subjectSource valueForKey:@"answer"]] inSection:0];
        
        answerState = [[_subjectSource valueForKey:@"answerstate"] integerValue];
    }
    
    [subject reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        baseManager = [RWDataBaseManager defaultManager];
        
        displayType = RWDisplayTypeNormal;
        
        answerNumbers = @[@"subject",@"A",@"B",@"C",@"D",@"E"];
        
        subjectLines = 1;
        
        subject = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        
        [self addSubview:subject];
        
        [subject mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.mas_top).offset(0);
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(0);
        }];
        
        subject.showsVerticalScrollIndicator = NO;
        subject.showsHorizontalScrollIndicator = NO;
        
        subject.delegate = self;
        subject.dataSource = self;
        
        subject.bounces = NO;
        
        [subject registerClass:[RWAnswerListCell class] forCellReuseIdentifier:answerList];
    }
    
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return subjectLines;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        if ([_subjectSource valueForKey:@"e"] == nil
            || [[_subjectSource valueForKey:@"e"] isEqualToString:@""]
            || [[_subjectSource valueForKey:@"e"] isEqualToString:@"暂无"])
        {
            return 5;
        }
        else
        {
            return 6;
        }
    }
    else if (section == 1)
    {
        return 2;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RWAnswerListCell *cell = [tableView dequeueReusableCellWithIdentifier:answerList forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row)
        {
            case 0:
            {
                switch (displayType)
                {
                    case RWDisplayTypeNormal:
                    {
                        cell.cellType = RWAnswerListTypeSubjuect;
                        cell.titleLabel.text = [NSString stringWithFormat:@"%@.  %@",[_subjectSource valueForKey:@"subjectnumber"],[_subjectSource valueForKey:@"subject"]];
                    }
                        break;
                    case RWDisplayTypeCollect:
                    {
                        cell.cellType = RWAnswerListTypeSubjuect;
                        cell.titleLabel.text = [NSString stringWithFormat:@"%@",[_subjectSource valueForKey:@"subject"]];
                    }
                        break;
                        
                    default:
                    {
                        cell.cellType = RWAnswerListTypeSubjuect;
                        cell.titleLabel.text = [NSString stringWithFormat:
                                                @"答错次数：%@次\n\n\t%@",
                                                [_subjectSource valueForKey:
                                                 @"numberOfTimes"],
                                                [_subjectSource valueForKey:
                                                 @"subject"]];
                    }
                        break;
                }
                break;
            }
            case 1:
            {
                cell.cellType = RWAnswerListTypeAnswer;
                cell.titleLabel.text = [NSString stringWithFormat:@"A.  %@",[_subjectSource valueForKey:@"a"]];
                
                break;
            }
            case 2:
            {
                cell.cellType = RWAnswerListTypeAnswer;
                cell.titleLabel.text = [NSString stringWithFormat:@"B.  %@",[_subjectSource valueForKey:@"b"]];
                
                break;
            }
            case 3:
            {
                cell.cellType = RWAnswerListTypeAnswer;
                cell.titleLabel.text = [NSString stringWithFormat:@"C.  %@",[_subjectSource valueForKey:@"c"]];
                
                break;
            }
            case 4:
            {
                cell.cellType = RWAnswerListTypeAnswer;
                cell.titleLabel.text = [NSString stringWithFormat:@"D.  %@",[_subjectSource valueForKey:@"d"]];
                
                break;
            }
            default:
            {
                cell.cellType = RWAnswerListTypeAnswer;
                cell.titleLabel.text = [NSString stringWithFormat:@"E.  %@",[_subjectSource valueForKey:@"e"]];
                
                break;
            }
        }
        
    }else {
        
        if (indexPath.row == 0)
        {
            cell.cellType = RWAnswerListTypeLabel;
            cell.titleLabel.text = @"问题解析";
            
        }
        else
        {
            cell.cellType = RWAnswerListTypeAnalysis;
            if ([[_subjectSource valueForKey:@"analysis"]
                 isKindOfClass:[NSNull class]]
                ||[[_subjectSource valueForKey:@"analysis"]
                   isEqualToString:@""])
            {
                cell.titleLabel.text = @"略";
            }
            else
            {
                cell.titleLabel.text = [_subjectSource valueForKey:@"analysis"];
            }
        }
    }
    
    [cell.titleLabel sizeToFit];
    
    if (cell.titleLabel.frame.size.height + 30 > 50)
    {
        [cellLength[indexPath.section] removeObjectAtIndex:indexPath.row];
        
        [cellLength[indexPath.section] insertObject:
                                        [NSNumber numberWithFloat:
                            cell.titleLabel.frame.size.height + 20]
                                            atIndex:indexPath.row];
    }
    
    if (indexPath.section == 1 && indexPath.row == 1 && !finishAutoLayout )
    {
        finishAutoLayout = YES;
        
        [tableView reloadData];
    }
    
    if (subjectLines == 2)
    {
        if (indexPath == chooseIndex)
        {
            if (answerState == RWAnswerStateWrong)
            {
                [cell showAnswerChooseAndWrong];
            }
            else
            {
                [cell showAnswerChooseAndRight];
            }
        }
        
        if (indexPath == correctIndex)
        {
            [cell showCorrectAnswer];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (subjectLines == 1)
    {
        if ([_subjectSource valueForKey:@"e"] == nil
            || [[_subjectSource valueForKey:@"e"] isEqualToString:@""]
            || [[_subjectSource valueForKey:@"e"] isEqualToString:@"暂无"])
        {
            if (indexPath.row == 4 && !finishAutoLayout)
            {
                finishAutoLayout = YES;
                
                [tableView reloadData];
            }
        }
        else
        {
            if (indexPath.row == 4 && !finishAutoLayout)
            {
                finishAutoLayout = YES;
                
                [tableView reloadData];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row != 0 && !_isAnswer)
    {
        _isAnswer = YES;
        
        finishAutoLayout = NO;
        
        subjectLines = 2;
        
        RWDeployManager *deployManager = [RWDeployManager defaultManager];
        
        if ([[deployManager deployValueForKey:LOGIN] isEqualToString:NOT_LOGIN])
        {
            NSNumber *times = [deployManager deployValueForKey:EXPERIENCE_TIMES];
            
            if (times)
            {
                [deployManager setDeployValue:@(times.integerValue - 1)
                                       forKey:EXPERIENCE_TIMES];
            }
        }
        
        [self chooseResponseWithIndexPath:indexPath];
        
        [tableView reloadData];
    }
}

- (void)setIsAnswer:(BOOL)isAnswer
{
    _isAnswer = isAnswer;
    
    if (_isAnswer)
    {
        subjectLines = 2;
    }
    else
    {
        subjectLines = 1;
    }
}

- (void)answerDidSelect
{
    if (_isAnswer)
    {
        RWAnswerListCell *cell = [subject cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[self answerNumber]]];
        
        [cell showCorrectAnswer];
        
        RWAnswerListCell *select = [subject cellForRowAtIndexPath:
                                     [NSIndexPath indexPathForRow:
                                           [self numberWithAnswer:
                                      [_subjectSource valueForKey:
                                                        @"choose"]] inSection:0]];
        
        if ([[_subjectSource valueForKey:@"answerstate"] integerValue]
            == RWAnswerStateWrong)
        {
            [select showAnswerChooseAndWrong];
        }
        else
        {
            [select showAnswerChooseAndRight];
        }
    }
}

- (NSInteger)answerNumber
{
    return [self numberWithAnswer:[_subjectSource valueForKey:@"answer"]];
}

- (NSInteger)numberWithAnswer:(NSString *)correct
{
    if ([correct isEqualToString:@"A"])
    {
        return 1;
    }
    else if ([correct isEqualToString:@"B"])
    {
        return 2;
    }
    else if ([correct isEqualToString:@"C"])
    {
        return 3;
    }
    else if ([correct isEqualToString:@"D"])
    {
        return 4;
    }
    else if ([correct isEqualToString:@"E"])
    {
        return 5;
    }

    return 999999;
}

- (void)showCorrectAnswer:(void (^)(void))succeed
{
    if (subjectLines == 1)
    {
        subjectLines = 2;
        
        finishAutoLayout = NO;
        
        chooseIndex = [NSIndexPath indexPathForRow:[self answerNumber] inSection:0];
        
        correctIndex = [NSIndexPath indexPathForRow:[self answerNumber] inSection:0];
        
        answerState = RWAnswerStateCorrect;
        
        [subject reloadData];
        
        NSArray *answerArr = @[@"",@"A",@"B",@"C",@"D",@"E"];
        
        if ([_subjectSource isKindOfClass:[RWSubjectsModel class]])
        {
            [_subjectSource setValue:[NSNumber numberWithInteger:RWAnswerStateShowCorrect] forKey:@"answerstate"];
            
            [_subjectSource setValue:answerArr[chooseIndex.row] forKey:@"choose"];
            
            [baseManager updateEntity:_subjectSource];
        }
        
        succeed();
    }
}

- (void)reloadAutoLayout
{
    finishAutoLayout = YES;
    
    [subject reloadData];
}


@end
