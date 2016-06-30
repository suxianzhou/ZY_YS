//
//  RWSubjectManagerController.h
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/6/30.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,RWSegmented)
{
    RWSegmentedOfRandom     = 0,
    RWSegmentedOfSubject    = 1,
    RWSegmentedOfErrorCount = 2
};

@interface RWSubjectManagerController : UIViewController

- (void)initSegmentedControlWithIndex:(NSInteger)index;

- (void)releaseSegmentedControl;

@end
