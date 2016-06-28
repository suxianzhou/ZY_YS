//
//  RWVerificationController.h
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/10.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RWSetPasswordController.h"

@interface RWVerificationController : UIViewController

@property (nonatomic ,strong) NSString *phoneNumber;

@property (nonatomic ,assign) RWVerificationType type;

@end
