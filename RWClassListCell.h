//
//  RWClassListCell.h
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/9.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RWClassListCell;

@protocol RWClassListDelegate <NSObject>

- (void)classListCell:(RWClassListCell *)classListCell AppointmentClick:(UIButton *)button yid:(NSNumber *)yid;

@end

@interface RWClassListCell : UITableViewCell

@property (nonatomic,strong)id<RWClassListDelegate> delegate;

@property (nonatomic,strong)UIImage *image;

@property (nonatomic,strong)NSString *header;

@property (nonatomic,strong)NSString *content;

@property (nonatomic,strong)NSString *date;

@property (nonatomic,strong)NSNumber *yid;

@property (nonatomic,assign)BOOL didAppointment;

@property (nonatomic,weak)NSDictionary *userInfo;

@end
