//
//  RWCountDownView.h
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/26.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RWCountDownView;

@protocol RWCountDownViewDelegate <NSObject>

- (void)countDownView:(RWCountDownView *)countDown DidClickCloseButton:(UIImageView *)closeButton;

@end

@interface RWCountDownView : UIView

@property (nonatomic,assign)id<RWCountDownViewDelegate> delegate;

@property (nonatomic,strong)UIImage *background;

@property (nonatomic,strong)NSString *title;

@property (nonatomic,assign)NSInteger distanceDays;

- (void)rollTestNameAndDays;

@end
