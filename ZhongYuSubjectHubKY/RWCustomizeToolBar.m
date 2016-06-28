//
//  RWCustomizeToolBar.m
//  ZhongYuSubjectHubKY
//
//  Created by RyeWhiskey on 16/4/29.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWCustomizeToolBar.h"

@interface RWCustomizeToolBar ()

@property (nonatomic,strong)UIImageView *previous;

@property (nonatomic,strong)UIImageView *next;

@property (nonatomic,strong)UIImageView *collect;

@property (nonatomic,strong)UIImageView *correct;

@property (nonatomic,strong)UIImageView *share;

@property (nonatomic,strong)NSArray *images;

@end

@implementation RWCustomizeToolBar

@synthesize previous;
@synthesize next;
@synthesize collect;
@synthesize correct;
@synthesize share;
@synthesize images;

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        [self initViews];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        images = @[[UIImage imageNamed:@"Previos_un"],[UIImage imageNamed:@"UnShare"],[UIImage imageNamed:@"UnCollect"],[UIImage imageNamed:@"Unshow"],[UIImage imageNamed:@"Next_un"]];
        
        [self initViews];
        
        [self autoLayoutViews];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self autoLayoutViews];
}

- (void)initViews
{
    [self initPrevious];
    
    [self initShare];
    
    [self initCollect];
    
    [self initCorrect];
    
    [self initNext];
    
    [self replaceBottonState];
}

- (void)initPrevious
{
    previous = [[UIImageView alloc]init];
    
    previous.userInteractionEnabled = YES;
    
    previous.tag = 1;
    
    [self addSubview:previous];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonClick:)];
    
    tap.numberOfTapsRequired = 1;
    
    [previous addGestureRecognizer:tap];
}

- (void)initNext
{
    next = [[UIImageView alloc]init];
    
    next.userInteractionEnabled = YES;
    
    next.tag = 5;
    
    [self addSubview:next];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonClick:)];
    
    tap.numberOfTapsRequired = 1;
    
    [next addGestureRecognizer:tap];
}

- (void)initCollect
{
    collect = [[UIImageView alloc]init];
    
    collect.userInteractionEnabled = YES;
    
    collect.tag = 3;
    
    [self addSubview:collect];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonClick:)];
    
    tap.numberOfTapsRequired = 1;
    
    [collect addGestureRecognizer:tap];
}

- (void)initCorrect
{
    correct = [[UIImageView alloc]init];
    
    correct.userInteractionEnabled = YES;
    
    correct.tag = 4;
    
    [self addSubview:correct];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonClick:)];
    
    tap.numberOfTapsRequired = 1;
    
    [correct addGestureRecognizer:tap];
}

- (void)initShare
{
    share = [[UIImageView alloc]init];
    
    share.userInteractionEnabled = YES;
    
    share.tag = 2;
    
    [self addSubview:share];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonClick:)];
    
    tap.numberOfTapsRequired = 1;
    
    [share addGestureRecognizer:tap];
}

- (void)autoLayoutViews
{
    CGFloat average = self.frame.size.width / 5;
    
    [previous mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.equalTo([NSNumber numberWithFloat:self.frame.size.height - 20]);
        make.centerX.equalTo(self.mas_centerX).offset(-average * 2);
    }];
    
    [share mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.equalTo([NSNumber numberWithFloat:self.frame.size.height - 20]);
        make.centerX.equalTo(self.mas_centerX).offset(-average);
    }];
    
    [collect mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.equalTo([NSNumber numberWithFloat:self.frame.size.height - 20]);
        make.centerX.equalTo(self.mas_centerX).offset(0);
    }];
    
    [correct mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.equalTo([NSNumber numberWithFloat:self.frame.size.height - 20]);
        make.centerX.equalTo(self.mas_centerX).offset(average);
    }];
    
    [next mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.equalTo([NSNumber numberWithFloat:self.frame.size.height - 20]);
        make.centerX.equalTo(self.mas_centerX).offset(average * 2);
    }];
}

- (void)buttonClick:(UITapGestureRecognizer *)tap
{
    [self.delegate toolBar:self ClickWithBotton:tap.view.tag];
}

- (void)didCollect
{
    collect.image = [UIImage imageNamed:@"Collect"];
    
    _isCollect = YES;
}

- (void)didShowCorrectAnswer
{
    correct.image = [UIImage imageNamed:@"Show"];
    
    _isShowCorrectAnswer = YES;
}

- (void)cancelWithBotton:(RWToolsBarClick)botton
{
    UIImageView *imageview = [self viewWithTag:botton];
    
    imageview.image = images[botton - 1];
    
    if (botton == RWToolsBarClickCollect )
    {
        _isCollect = NO;
    }
    else if (botton == RWToolsBarClickCorrect)
    {
        _isShowCorrectAnswer = NO;
    }
}

- (void)replaceBottonState
{
    previous.image = [UIImage imageNamed:@"Previos_un"];
    
    share.image    = [UIImage imageNamed:@"UnShare"];
    
    collect.image  = [UIImage imageNamed:@"UnCollect"];
    
    correct.image  = [UIImage imageNamed:@"Unshow"];
    
    next.image     = [UIImage imageNamed:@"Next_un"];
    
    _isShowCorrectAnswer = NO;
    
    _isCollect = NO;
}

@end
