//
//  RWSetPasswordController.h
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/10.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,RWVerificationType){
    
    RWVerificationTypeRegister       = 1,
    RWVerificationTypeForgetPassword = 2
};

@interface RWSetPasswordController : UIViewController

@property (nonatomic ,strong)NSString *phoneNumber;

@property (nonatomic ,assign)RWVerificationType type;

@end
