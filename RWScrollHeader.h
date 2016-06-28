//
//  RWScrollHeader.h
//  RealTime
//
//  Created by RyeWhiskey on 16/2/28.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RWSrcollHeaderDelegate <NSObject>


//- (void)headerChainReaction:(CGPoint)contentOffset;

@end

@interface RWScrollHeader : UIView

@property (nonatomic,strong)NSArray *dataSource;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,assign) CGPoint rwContentOffset;

@property (nonatomic,assign)id<RWSrcollHeaderDelegate> delegate;


@end
