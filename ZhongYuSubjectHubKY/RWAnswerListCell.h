//
//  RWAnswerListCell.h
//  ZhongYuSubjectHubKY
//
//  Created by RyeWhiskey on 16/4/28.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,RWAnswerListType)
{
    
    RWAnswerListTypeSubjuect = 2 << 1,
    RWAnswerListTypeAnswer   = 2 << 2,
    RWAnswerListTypeLabel    = 2 << 3,
    RWAnswerListTypeAnalysis = 2 << 4
    
};

@interface RWAnswerListCell : UITableViewCell

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,assign)RWAnswerListType cellType;

- (void)showCorrectAnswer;

- (void)showAnswerChooseAndRight;

- (void)showAnswerChooseAndWrong;

@end

