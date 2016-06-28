//
//  RWAnswerViewController.h
//  ZhongYuSubjectHubKY
//
//  Created by RyeWhiskey on 16/4/28.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RWAnswerViewCell.h"

@interface RWAnswerViewController : UIViewController

@property (nonatomic,strong)NSMutableArray *subjectSource;

@property (nonatomic,strong)NSString *headerTitle;

@property (nonatomic,strong)NSIndexPath *beginIndexPath;

@property (nonatomic,assign)RWDisplayType displayType;

@end
