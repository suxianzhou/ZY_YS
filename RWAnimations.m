
//
//  RWAnimations.m
//  Animation
//
//  Created by zhongyu on 16/6/15.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWAnimations.h"
#import <WebKit/WebKit.h>

#define GOLD_COLOR [UIColor colorWithRed:247.0/255.0 green:198.0/255.0 blue:102.0/255.0 alpha:1.0]

@interface RWAnimations ()

@property (nonatomic,strong)UIImageView *centerImage;

@property (nonatomic,strong)CAEmitterLayer *emitterLayer;

@property (nonatomic,strong)WKWebView *animationView;

@property (nonatomic,strong)UIImageView *cancelView;

@property (nonatomic,strong)NSArray *animationLevels;

@property (nonatomic,strong)NSArray *contextLevels;

@property (nonatomic,strong)UILabel *textLabel;

@property (nonatomic,weak)NSTimer *cycle;

@end

NSString *const fireworksAnimation = @"fireworks";

@implementation RWAnimations

@synthesize centerImage;

+ (instancetype)animation:(NSString *)animation Level:(RWAnimationLevel)level Frame:(CGRect)frame
{
    RWAnimations *_animation = [[RWAnimations alloc] init];
    
    _animation.frame = frame;
    
    [_animation startAnimation:animation Level:level];
    
    return _animation;
}

- (void)startAnimation:(NSString *)animation Level:(RWAnimationLevel)level
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
       
        while (YES)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self initAnimationViewWithAnimationName:animation];
                
            });
            
            [NSThread sleepForTimeInterval:10];
        }
    });
    
    centerImage.image = [UIImage imageNamed:_animationLevels[level]];
    
    _textLabel.text = _contextLevels[level];
}

- (void)initDatas
{
    NSMutableArray *levels = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= 10; i++)
    {
        [levels addObject:[NSString stringWithFormat:@"Lv%d",i]];
    }
    
    _animationLevels = [levels copy];
    
    _contextLevels = @[@"答对10道题",
                       @"答对20道题",
                       @"答对30道题",
                       @"答对40道题",
                       @"答对50道题",
                       @"答对60道题",
                       @"答对70道题",
                       @"答对80道题",
                       @"答对90道题",
                       @"答对100道题"];
}

- (void)initViews
{
    _animationView = [[WKWebView alloc] init];
    
    [self addSubview:_animationView];
    
    centerImage = [[UIImageView alloc] init];
    centerImage.layer.shadowColor = [[UIColor whiteColor] CGColor];
    centerImage.layer.shadowOffset = CGSizeMake(10, 10);
    centerImage.layer.shadowRadius = 5;
    centerImage.layer.shadowOpacity = 1;
    
    [self addSubview:centerImage];
    
    _cancelView = [[UIImageView alloc] init];
    _cancelView.image = [UIImage imageNamed:@"exitButton2"];
    _cancelView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromSuperview)];
    
    tap.numberOfTapsRequired = 1;
    
    [_cancelView addGestureRecognizer:tap];
    
    [self addSubview:_cancelView];
    
    _textLabel = [[UILabel alloc] init];
    
    _textLabel.textColor = GOLD_COLOR;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.font = [UIFont systemFontOfSize:20];
    
    _textLabel.shadowOffset = CGSizeMake(1, 1);
    _textLabel.shadowColor =
        [UIColor colorWithRed:252.0/255.0 green:238.0/255.0 blue:123.0/255.0 alpha:1.0];
    
    _textLabel.backgroundColor = [UIColor whiteColor];
    
    _textLabel.layer.borderColor = [GOLD_COLOR CGColor];
    _textLabel.layer.borderWidth = 4;
    
    _textLabel.layer.shadowColor = [[UIColor whiteColor] CGColor];
    _textLabel.layer.shadowOffset = CGSizeMake(10, 10);
    _textLabel.layer.shadowRadius = 5;
    _textLabel.layer.shadowOpacity = 1;
    
    [self addSubview:_textLabel];
}

- (void)initAnimationViewWithAnimationName:(NSString *)name
{
    _animationView.userInteractionEnabled = NO;
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:name
                                                          ofType:@"html"];
    
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    
    [_animationView loadHTMLString:htmlCont
                           baseURL:baseURL];
}

- (void)autoLayoutViews
{
    [_animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
    
    [centerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(180));
        make.height.equalTo(@(290));
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.centerY.equalTo(self.mas_centerY).offset(-30);
    }];
    
    [_cancelView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(60));
        make.height.equalTo(@(60));
        make.right.equalTo(self.mas_right).offset(-20);
        make.top.equalTo(self.mas_top).offset(20);
    }];
    
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@(200));
        make.height.equalTo(@(40));
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.top.equalTo(centerImage.mas_bottom).offset(30);
    }];
    
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self autoLayoutViews];
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self initDatas];
        [self initViews];
    }
    
    return self;
}


@end
