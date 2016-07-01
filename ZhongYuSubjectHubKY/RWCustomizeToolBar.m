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

@interface RWCustomizeWebToolBar ()

@property (nonatomic,strong)UIImageView *goPrevious;

@property (nonatomic,strong)UIImageView *index;

@property (nonatomic,strong)UIImageView *shared;

@property (nonatomic,assign)CGRect infoFrame;

@end

@implementation RWCustomizeWebToolBar

+ (instancetype)webBarWithFrame:(CGRect)frame
{
    RWCustomizeWebToolBar *webBar = [[RWCustomizeWebToolBar alloc] initWithFrame:frame];
    
    return webBar;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        [self initViews];
        [self autoLayoutFrame];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _infoFrame = frame;
    [self autoLayoutFrame];
}

- (void)initViews
{
    if (_shared && _index && _goPrevious)
    {
        return;
    }
    
    _goPrevious = [[UIImageView alloc] init];
    _goPrevious.image = [UIImage imageNamed:@"Previos_un"];
    _goPrevious.tag = 11111;
    _goPrevious.userInteractionEnabled = YES;
    
    [self addSubview:_goPrevious];
    
    _index = [[UIImageView alloc] init];
    _index.image = [UIImage imageNamed:@"goindex"];
    _index.tag = 22222;
    _index.userInteractionEnabled = YES;
    
    [self addSubview:_index];
    
    _shared = [[UIImageView alloc] init];
    _shared.image = [UIImage imageNamed:@"UnShare"];
    _shared.tag = 33333;
    _shared.userInteractionEnabled = YES;
    
    [self addSubview:_shared];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(barButtonClickWithTap:)];
    
    tap.numberOfTapsRequired = 1;
    
    [_goPrevious addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tapIndex = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(barButtonClickWithTap:)];
    
    tapIndex.numberOfTapsRequired = 1;
    
    [_index addGestureRecognizer:tapIndex];
    
    UITapGestureRecognizer *tapShared = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(barButtonClickWithTap:)];
    
    tapShared.numberOfTapsRequired = 1;
    
    [_shared addGestureRecognizer:tapShared];
}

- (void)autoLayoutFrame
{
    if ((_infoFrame.size.height == 0 && _infoFrame.size.width == 0) || !_goPrevious)
    {
        return;
    }
    
    CGFloat w = _infoFrame.size.width;
    CGFloat h = _infoFrame.size.height;
    
    CGRect frame = CGRectMake(0, 0, h - 10, h - 10);
    
    _goPrevious.frame = frame;
    _index.frame = frame;
    _shared.frame = frame;
    
    CGFloat itemCenter = w / 6;
    
    _goPrevious.center = CGPointMake(itemCenter, h / 2);
    _index.center = CGPointMake(itemCenter * 3, h / 2);
    _shared.center = CGPointMake(w - itemCenter, h / 2);
}

- (void)barButtonClickWithTap:(UITapGestureRecognizer *)tap
{
    if (_delegate)
    {
        [_delegate webToolBar:self didClickWithType:tap.view.tag];
    }
}

@end
