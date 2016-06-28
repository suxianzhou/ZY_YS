//
//  RWAnswerListCell.m
//  ZhongYuSubjectHubKY
//
//  Created by RyeWhiskey on 16/4/28.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWAnswerListCell.h"

@interface RWAnswerListCell ()

@property (nonatomic,strong)UIImageView *choseImage;

@property (nonatomic,strong)UIImageView *correctAnswer;

@property (nonatomic,strong)UIImageView *rightOrWrong;

@end

@implementation RWAnswerListCell

@synthesize choseImage;
@synthesize titleLabel;
@synthesize correctAnswer;
@synthesize rightOrWrong;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initViewsAndDatas];
        
    }
    
    return self;
}

- (void)initViewsAndDatas {
    
    choseImage = [[UIImageView alloc]init];
    
    choseImage.image = [UIImage imageNamed:@"UnSelect"];
    
    [self addSubview:choseImage];
    
    correctAnswer = [[UIImageView alloc]init];
    
    [self addSubview:correctAnswer];
    
    rightOrWrong = [[UIImageView alloc]init];
    
    [self addSubview:rightOrWrong];
    
    titleLabel = [[UILabel alloc]init];
    
    titleLabel.font = [UIFont systemFontOfSize:14];
    
    titleLabel.numberOfLines = 0;
    
    [self addSubview:titleLabel];
    
}

- (void)autoLayoutWithSubjuect {
    
    [choseImage removeFromSuperview];
    [correctAnswer removeFromSuperview];
    [rightOrWrong removeFromSuperview];
    
    titleLabel.frame = CGRectMake(0, 0, self.frame.size.width - 20, self.frame.size.height - 30);
    
    titleLabel.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
}

- (void)autoLayoutWithAnswer {
    
    [self addSubview:choseImage];
    [self addSubview:correctAnswer];
    [self addSubview:rightOrWrong];
    
    [choseImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.mas_top).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
        make.width.equalTo(@(50));
        make.height.equalTo(@(50));
    }];
    
    [correctAnswer mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(choseImage.mas_top).offset(0);
        make.left.equalTo(choseImage.mas_left).offset(0);
        make.width.equalTo(@(10));
        make.height.equalTo(@(50));
    }];
    
    [rightOrWrong mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.width.equalTo(@(30));
        make.height.equalTo(@(30));
    }];
    
    CGFloat titleW = self.frame.size.width - 20 - rightOrWrong.frame.size.width - choseImage.frame.size.width;
    
    CGFloat titleH = self.frame.size.height - 30;
    
    titleLabel.frame = CGRectMake(0, 0, titleW, titleH);
    titleLabel.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    
}

- (void)setCellType:(RWAnswerListType)cellType {
    
    _cellType = cellType;
    
    [self replaceViews];
    
    if (_cellType == RWAnswerListTypeSubjuect)
    {
        [self autoLayoutWithSubjuect];
    }
    else if (_cellType == RWAnswerListTypeAnswer)
    {
        self.backgroundColor = [UIColor clearColor];
        
        [self autoLayoutWithAnswer];
    }
    else if (_cellType == RWAnswerListTypeLabel)
    {
        self.backgroundColor = [UIColor clearColor];
        
        [self autoLayoutWithSubjuect];
    }
    else if (_cellType == RWAnswerListTypeAnalysis)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        choseImage.image = nil;
        
        [self autoLayoutWithAnswer];
    }
}

- (void)replaceViews
{
    
    correctAnswer.image = nil;
    rightOrWrong.image = nil;
    choseImage.image = [UIImage imageNamed:@"UnSelect"];
    
}

- (void)showCorrectAnswer
{
    correctAnswer.image = [UIImage imageNamed:@"corr"];
}

- (void)showAnswerChooseAndRight
{
    choseImage.image = [UIImage imageNamed:@"Select"];
    rightOrWrong.image = [UIImage imageNamed:@"right"];
}

- (void)showAnswerChooseAndWrong
{
    choseImage.image = [UIImage imageNamed:@"Select"];
    rightOrWrong.image = [UIImage imageNamed:@"wrong"];
}

@end
