//
//  RWSubjectCarouselCell.h
//  ZhongYuSubjectHubKY
//
//  Created by RyeWhiskey on 16/4/27.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RWSubjectCarouselCell;

@protocol RWSubjectCarouselDelegate <NSObject>

@optional

- (void)carousel:(RWSubjectCarouselCell *)carousel DidSelectWithIndex:(NSInteger)index;

@end

@interface RWSubjectCarouselCell : UITableViewCell

@property (nonatomic,assign)id<RWSubjectCarouselDelegate> delegate;

@property (nonatomic,strong)NSArray<UIImage *> * images;

@property (nonatomic,strong)NSArray<NSString *> *titles;

@property (nonatomic,readonly)BOOL isStartCarouse;

- (void)carouseStart;

- (void)carouseStop;

@end
