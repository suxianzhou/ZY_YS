//
//  RWCatalogueBaseController.h
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/6/30.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RWRequsetManager.h"
#import "RWDataBaseManager.h"
#import "RWSubjectHubListCell.h"
#import "RWChooseSubViewController.h"
#import "RWProgressCell.h"
#import "RWSliderCell.h"
#import "RWSubjectManagerController.h"

static NSString *const hubList = @"hunList";

static NSString *const progressCell = @"ProgressCell";

static NSString *const sliderCell = @"sliderCell";

@interface RWCatalogueBaseController : UIViewController

<

    UITableViewDelegate,
    UITableViewDataSource,
    RWRequsetDelegate

>

@property (nonatomic,weak)RWSubjectManagerController *managerController;

@property (nonatomic,strong)RWRequsetManager *requestManager;

@property (nonatomic,strong,readonly)UITableView *subjectHubList;

@property (nonatomic,strong,readonly)RWDataBaseManager *baseManager;

@property (nonatomic,strong)NSString *selectTitle;

@property (nonatomic,strong)NSArray *subjectClassSource;

@property (nonatomic,strong)NSMutableArray *subjectSource;

- (void)warningForNull;

@end
