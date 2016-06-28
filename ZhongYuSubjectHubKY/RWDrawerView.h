//
//  RWDrawerView.h
//  NetworkTest
//
//  Created by RyeWhiskey on 16/2/21.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RWDrawerView;

@protocol RWDrawerViewDelegate <NSObject>

@required

- (NSInteger)numberOfRowsInMenuBar:(RWDrawerView *)bar;

- (NSString *)menuBar:(RWDrawerView *)bar StringForRow:(NSInteger)row;

- (CGFloat)menuBar:(RWDrawerView *)bar heightForRow:(NSInteger)row;

- (void)menuBar:(RWDrawerView *)bar didSelectRow:(NSInteger)row;

@end

@interface RWDrawerView : UIView

@property (nonatomic,assign)id<RWDrawerViewDelegate> delegate;

@property (nonatomic,assign)BOOL addTopView;

@property (nonatomic,strong)UIImage *backgroundImage;

- (void)addViewForTopView:(__kindof UIView *)view;

- (void)reloadData;

@end
