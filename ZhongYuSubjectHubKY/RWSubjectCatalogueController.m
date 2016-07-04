//
//  RWSubjectCatalogueController.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/6/8.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWSubjectCatalogueController.h"

@interface RWSubjectCatalogueController ()

@end

@implementation RWSubjectCatalogueController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *title = [self.subjectSource[indexPath.section][indexPath.row]
                                                                valueForKey:@"title"];
    
    if ([self.baseManager isExistHubWithHubName:title])
    {
        RWProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:progressCell forIndexPath:indexPath];
        
        cell.name = title;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.fraction = [self fractionWithRow:indexPath.row
                                      Section:indexPath.section];
        
        return cell;
    }
    else
    {
        RWSubjectHubListCell *cell = [tableView dequeueReusableCellWithIdentifier:hubList forIndexPath:indexPath];
        
        cell.title = title;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.downLoadState = @"未下载";
        
        return cell;
    }
}

- (NSString *)fractionWithRow:(NSInteger)row Section:(NSInteger)section
{
    NSString *name = [self.subjectSource[section][row] valueForKey:@"title"];
    
    NSArray *items = [self.baseManager obtainIndexNameWithHub:name];
    
    unsigned int makes = 0,counts = 0;
    
    for (int i = 0; i < items.count; i++)
    {
        RWSubjectClassModel *item = items[i];
        
        NSString *itemfra = [self.baseManager toSubjectsWithIndexName:item.subjectclass
                                                           AndHubName:item.hub
                                                                 Type:
                                                                RWToNumberForString];
        
        NSArray *arr = [itemfra componentsSeparatedByString:@"/"];
        
        if (arr.count != 2)
        {
            return nil;
        }
        
        makes += [arr[0] intValue];
        counts += [arr[1] intValue];
    }
    
    return [NSString stringWithFormat:@"%d/%d",makes,counts];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    NSArray *classSource = [self.baseManager obtainIndexNameWithHub:self.selectTitle];
    
    if (classSource.count != 0)
    {
        RWChooseSubViewController *choose = [[RWChooseSubViewController alloc] init];
        
        choose.headerTitle = self.selectTitle;
        
        choose.classSource = [self.baseManager obtainIndexNameWithHub:self.selectTitle];
        
        [self.managerController releaseSegmentedControl];
        
        [self.navigationController pushViewController:choose animated:YES];
        
        [SVProgressHUD dismiss];

    }
}

- (void)subjectBaseDeployDidFinish:(NSArray *)subjectHubs
{
    RWChooseSubViewController *choose = [[RWChooseSubViewController alloc] init];
    
    choose.headerTitle = self.selectTitle;
    
    choose.classSource = subjectHubs;
    
    [SVProgressHUD dismiss];
    
    [self.managerController releaseSegmentedControl];
    
    [self.navigationController pushViewController:choose animated:YES];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.managerController initSegmentedControlWithIndex:RWSegmentedOfSubject];
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
