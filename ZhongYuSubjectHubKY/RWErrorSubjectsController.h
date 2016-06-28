//
//  RWErrorSubjectsController.h
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/4/26.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RWAnswerViewController.h"

@protocol RWCollectSubjectDelegate <NSObject>

- (RWDisplayType)CollectSubject;

@end

@interface RWErrorSubjectsController : UIViewController

@property (nonatomic,assign)id<RWCollectSubjectDelegate> delegate;

@end
