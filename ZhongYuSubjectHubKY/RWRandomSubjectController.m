//
//  RWRandomSubjectController.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/6/30.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWRandomSubjectController.h"
#import "RWSliderCell.h"
#import "RWAnswerViewController.h"

@interface RWRandomSubjectController ()

@property (nonatomic,strong)NSIndexPath *selected;

@end

@implementation RWRandomSubjectController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *title = [self.subjectSource[indexPath.section][indexPath.row]
                       valueForKey:@"title"];
    
    if (_selected&&_selected.section==indexPath.section&&_selected.row==indexPath.row)
    {
        RWSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:sliderCell
                                                             forIndexPath:indexPath];
        
        cell.name = title;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    RWSubjectHubListCell *cell = [tableView dequeueReusableCellWithIdentifier:hubList forIndexPath:indexPath];
    
    cell.title = title;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.downLoadState = @"";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selected&&_selected.section==indexPath.section&&_selected.row==indexPath.row)
    {
        return 80;
    }
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!_selected||_selected.section!=indexPath.section||_selected.row!=indexPath.row)
    {
        _selected = indexPath;
        
        [self.subjectHubList reloadData];
        
        return;
    }
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    NSArray *classSource = [self.baseManager obtainIndexNameWithHub:self.selectTitle];
    
    if (classSource.count != 0)
    {
        RWSliderCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        NSInteger counts = (NSInteger)cell.counts;
        
        RWAnswerViewController *answerView = [[RWAnswerViewController alloc]init];
        
        NSString *title = [self.subjectSource[indexPath.section][indexPath.row]
                                                                valueForKey:@"title"];
        
        answerView.headerTitle = [NSString stringWithFormat:@"%@随机模式",title];
        
        NSArray *subjectSource = [self randomSubjectWithSubjectHubs:classSource
                                                             Counts:counts];
        
        answerView.subjectSource = [subjectSource mutableCopy];
        
        answerView.displayType = RWDisplayTypeCollect;
        
        answerView.beginIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        
        [self.managerController releaseSegmentedControl];
        
        [SVProgressHUD dismiss];
        
        [self.navigationController pushViewController:answerView animated:YES];
        
        answerView.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)subjectBaseDeployDidFinish:(NSArray *)subjectHubs
{
    RWSliderCell *cell = [self.subjectHubList cellForRowAtIndexPath:_selected];
    
    NSInteger counts = (NSInteger)cell.counts;
    
    RWAnswerViewController *answerView = [[RWAnswerViewController alloc]init];
    
    NSString *title = [self.subjectSource[_selected.section][_selected.row]
                                                                valueForKey:@"title"];
    
    answerView.headerTitle = [NSString stringWithFormat:@"%@随机模式",title];
    
    NSArray *subjectSource = [self randomSubjectWithSubjectHubs:subjectHubs
                                                         Counts:counts];
    
    answerView.subjectSource = [subjectSource mutableCopy];
    
    answerView.displayType = RWDisplayTypeCollect;
    
    answerView.beginIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    [self.managerController releaseSegmentedControl];
    
    [SVProgressHUD dismiss];
    
    [self.navigationController pushViewController:answerView animated:YES];
}

- (NSArray *)randomSubjectWithSubjectHubs:(NSArray *)hubs Counts:(NSInteger)counts
{
    NSMutableArray *allSubjects = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < hubs.count; i++)
    {
        @autoreleasepool
        {
            NSString *indexName = [hubs[i] valueForKey:@"subjectclass"];
            
            NSString *hubName = [hubs [i] valueForKey:@"hub"];
            
            NSArray *temps = [self.baseManager obtainSubjectsWithIndexName:indexName
                                                                AndHubName:hubName];
            
            for (int j = 0; j < temps.count; j++)
            {
                [allSubjects addObject:temps[j]];
            }
        }
    }
    
    NSMutableArray *randoms = [[NSMutableArray alloc] init];
    
    int probability = 1.0f / ((float)allSubjects.count / (float)counts) * 100;
    
    for (int i = 0; i < allSubjects.count; i++)
    {
        if (arc4random() % 100 <= probability)
        {
            [randoms addObject:[self exchangModel:allSubjects[i]]];
        }
        
        if (randoms.count >= counts)
        {
            break;
        }
    }
    
    if (randoms.count < counts)
    {
        NSInteger residue = counts - randoms.count;
        
        NSInteger location = arc4random() % allSubjects.count;
        
        if (location > allSubjects.count / 2)
        {
            location -= residue;
        }
        
        for (int i = location; i < location+residue; i++)
        {
            [randoms addObject:[self exchangModel:allSubjects[i]]];
        }
    }
    NSLog(@"%d",(int)randoms.count);
    return randoms;
}

- (RWCollectModel *)exchangModel:(RWSubjectsModel *)subjectModel
{
    RWCollectModel *tempModel = [[RWCollectModel alloc] init];
    
    tempModel.a             = subjectModel.a;
    tempModel.b             = subjectModel.b;
    tempModel.c             = subjectModel.c;
    tempModel.d             = subjectModel.d;
    tempModel.e             = subjectModel.e;
    tempModel.answer        = subjectModel.answer;
    tempModel.analysis      = subjectModel.analysis;
    tempModel.subject       = subjectModel.subject;
    tempModel.hub           = subjectModel.hub;
    tempModel.subjectclass  = subjectModel.subjectclass;
    tempModel.numberOfTimes = [NSNumber numberWithInteger:1];
    tempModel.collectState  = [NSNumber numberWithInteger:RWCollectTypeOnlyCollect];
    
    return tempModel;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.managerController initSegmentedControlWithIndex:RWSegmentedOfRandom];
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
