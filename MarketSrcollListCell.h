//
//  MarketSrcollListCell.h
//  HXBusiness
//
//  Created by RyeWhiskey on 16/2/13.
//  Copyright © 2016年 RyeVishkey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketBlockModel.h"

@protocol RWSrcollListCellDelegate <NSObject>
//collectionView  滚动时触发
- (void)cellChainReaction:(CGPoint)contentOffset WithSection:(NSInteger)section;

@end

@interface MarketSrcollListCell : UITableViewCell
//数据源
@property (nonatomic,strong)MarketBlockModel *dataSource;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *codeLabel;
//collectionView 的偏移量
@property (nonatomic,assign) CGPoint rwContentOffset;
//当前分组
@property (nonatomic,assign)NSInteger faceSection;

@property (nonatomic,assign) id<RWSrcollListCellDelegate> delegate;


@end
