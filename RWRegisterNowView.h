//
//  RWRegisterNowView.h
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/17.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RWRegisterNowView;

@protocol RWRegisterNowViewDelegate <NSObject>

- (NSString *)titleWithRegisterView;

- (void)registerView:(RWRegisterNowView *)registerView Click:(UIButton *)click;

@end

@interface RWRegisterNowView : UITableView

+ (instancetype)registerViewWithFrame:(CGRect)frame Delegate:(id)anyObject;

@end
