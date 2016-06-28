//
//  RWAnswerViewCell.h
//  ZhongYuSubjectHubKY
//
//  Created by RyeWhiskey on 16/4/28.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RWSubjectsModel.h"
#import "RWCollectModel.h"

@protocol RWAnswerViewCellDelegate <NSObject>
@optional

- (void)answerCorrect;

@end

typedef NS_OPTIONS(NSInteger, RWDisplayType) {
    
    RWDisplayTypeNormal       = 1 << 1,
    RWDisplayTypeCollect      = 2 << 1,
    RWDisplayTypeWrongSubject = 3 << 1
};

@interface RWAnswerViewCell : UICollectionViewCell

@property (nonatomic,strong)id<RWAnswerViewCellDelegate> delegate;

@property (nonatomic,strong)id subjectSource;

@property (nonatomic,assign)RWDisplayType displayType;

@property (nonatomic,assign)BOOL isAnswer;

- (void)showCorrectAnswer:(void(^)(void))succeed;

- (void)reloadAutoLayout;

- (void)answerDidSelect;

@end
