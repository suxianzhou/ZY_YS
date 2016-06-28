//
//  RWCountDownView.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/26.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWCountDownView.h"

@interface RWCountDownView ()

<
    UIPickerViewDataSource,
    UIPickerViewDelegate
>

@property (nonatomic,strong)UIImageView *backgroundimage;

@property (nonatomic,strong)UIImageView *exitButton;

@property (nonatomic,strong)UIPickerView *pickView;

@property (nonatomic,strong)UILabel *distanceLabel;

@property (nonatomic,strong)UIPickerView *titlePicker;

@property (nonatomic,strong)UILabel *joinLabel;

@property (nonatomic,strong)UILabel *fighting;

@property (nonatomic,assign)CGRect intoFrame;

@property (nonatomic,strong)NSArray *daysSource;

@property (nonatomic,strong)NSArray *titleSource;

@property (nonatomic,strong)CAEmitterLayer *emitterLayer;

@end

@implementation RWCountDownView

@synthesize backgroundimage;
@synthesize exitButton;
@synthesize pickView;
@synthesize distanceLabel;
@synthesize titlePicker;
@synthesize joinLabel;
@synthesize intoFrame;
@synthesize fighting;
@synthesize daysSource;
@synthesize titleSource;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        [self initViews];
        
        [self initViewsAutoLayout];
        
        [self deployViews];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    intoFrame = frame;
    
    if (backgroundimage)
    {
        [self initViewsAutoLayout];
    }
}

- (void)setBackground:(UIImage *)background
{
    _background = background;
    
    backgroundimage.image = _background;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 30; i++)
    {
        [arr addObject:[NSString stringWithFormat:@"%@ 考试",title]];
    }
    
    titleSource = arr;
    
    [titlePicker reloadAllComponents];
}

- (void)setDistanceDays:(NSInteger)distanceDays
{
    _distanceDays = distanceDays;
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _distanceDays + 10; i++)
    {
        [arr addObject:[NSString stringWithFormat:@"%d天",i]];
    }
    
    daysSource = arr;
    
    [pickView reloadAllComponents];
}

- (void)rollTestNameAndDays
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [titlePicker selectRow:28 inComponent:0 animated:YES];
        
        [pickView selectRow:_distanceDays inComponent:0 animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
             [self launchEmitterLayer];
        });
    });
}

- (void)initViewsAutoLayout
{
    [backgroundimage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@(240));
        make.height.equalTo(@(360));
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.centerY.equalTo(self.mas_centerY).offset(0);
    }];
    
    [exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@(60));
        make.height.equalTo(@(60));
        make.bottom.equalTo(backgroundimage.mas_top).offset(0);
        make.right.equalTo(backgroundimage.mas_right).offset(0);
    }];
    
    [distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(backgroundimage.mas_top).offset(20);
        make.left.equalTo(backgroundimage.mas_left).offset(10);
        make.right.equalTo(backgroundimage.mas_right).offset(-10);
        make.height.equalTo(@(35));
    }];
    
    [titlePicker mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(distanceLabel.mas_bottom).offset(0);
        make.left.equalTo(backgroundimage.mas_left).offset(10);
        make.right.equalTo(backgroundimage.mas_right).offset(-10);
        make.height.equalTo(@(88));
    }];
    
    [joinLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(titlePicker.mas_bottom).offset(0);
        make.left.equalTo(backgroundimage.mas_left).offset(10);
        make.right.equalTo(backgroundimage.mas_right).offset(-10);
        make.height.equalTo(@(35));
    }];
    
    [fighting mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(backgroundimage.mas_left).offset(10);
        make.right.equalTo(backgroundimage.mas_right).offset(-10);
        make.bottom.equalTo(backgroundimage.mas_bottom).offset(-10);
        make.height.equalTo(@(40));
    }];
    
    [pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(joinLabel.mas_bottom).offset(0);
        make.left.equalTo(backgroundimage.mas_left).offset(10);
        make.right.equalTo(backgroundimage.mas_right).offset(-10);
        make.bottom.equalTo(fighting.mas_top).offset(0);
    }];
}

- (void)initViews
{
    backgroundimage = [[UIImageView alloc]init];
    
    [self addSubview:backgroundimage];
    
    exitButton = [[UIImageView alloc] init];
    
    [self addSubview:exitButton];
    
    distanceLabel = [[UILabel alloc] init];
    
    distanceLabel.backgroundColor = [UIColor clearColor];
    
    [backgroundimage addSubview:distanceLabel];
    
    titlePicker = [[UIPickerView alloc]init];
    
    titlePicker.backgroundColor = [UIColor clearColor];
    
    [backgroundimage addSubview:titlePicker];
    
    joinLabel = [[UILabel alloc]init];
    
    joinLabel.backgroundColor = [UIColor clearColor];
    
    [backgroundimage addSubview:joinLabel];
    
    pickView = [[UIPickerView alloc] init];
    
    pickView.backgroundColor = [UIColor clearColor];
    
    [backgroundimage addSubview:pickView];
    
    fighting = [[UILabel alloc] init];
    
    fighting.backgroundColor = [UIColor clearColor];
    
    [backgroundimage addSubview:fighting];
}

- (void)deployViews
{
    backgroundimage.layer.cornerRadius = 10;
    
    backgroundimage.clipsToBounds = YES;
    
    backgroundimage.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    backgroundimage.layer.borderWidth = 0.7;
    
    
    exitButton.image = [UIImage imageNamed:@"exitButton"];
    
    exitButton.userInteractionEnabled = YES;
    
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
    
    tap.numberOfTapsRequired = 1;
    
    [exitButton addGestureRecognizer:tap];
    
    
    distanceLabel.text = @"距  离";
    
    distanceLabel.font = [UIFont fontWithName:@"Helvetica-Bold"size:35];
    
    distanceLabel.textColor = [UIColor whiteColor];
    
    distanceLabel.textAlignment = NSTextAlignmentCenter;
    
    distanceLabel.shadowOffset = CGSizeMake(2, 2);
    
    distanceLabel.shadowColor = [UIColor blackColor];
    
    
    titlePicker.delegate = self;
    
    titlePicker.dataSource = self;
    
    titlePicker.tag = 1111;
    
    
    joinLabel.text = @"还  有";
    
    joinLabel.font = [UIFont fontWithName:@"Helvetica-Bold"size:35];
    
    joinLabel.textAlignment = NSTextAlignmentCenter;
    
    joinLabel.textColor = [UIColor whiteColor];
    
    joinLabel.shadowOffset = CGSizeMake(2, 2);
    
    joinLabel.shadowColor = [UIColor blackColor];
    
    
    fighting.text = @"高峰只对攀登它而不是仰望它的人来说才有真正好处。";
    
    fighting.font = [UIFont systemFontOfSize:16];
    
    fighting.textAlignment = NSTextAlignmentCenter;
    
    fighting.textColor = [UIColor whiteColor];
    
    fighting.numberOfLines = 3;
    
    
    pickView.dataSource = self;
    
    pickView.delegate = self;
}

- (void)closeClick
{
    [self.delegate countDownView:self DidClickCloseButton:exitButton];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 1111)
    {
        return titleSource.count;
    }
    else
    {
        return daysSource.count;
    }
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerLabel = (UILabel* )view;
    
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        
        pickerLabel.textColor = [UIColor whiteColor];

        pickerLabel.adjustsFontSizeToFitWidth = YES;
        
        pickerLabel.backgroundColor = [UIColor clearColor];
    }
    
    if (pickerView.tag == 1111)
    {
        pickerLabel.font = [UIFont boldSystemFontOfSize:25];
        
        pickerLabel.text = titleSource[row];
    }
    else
    {
        pickerLabel.font = [UIFont boldSystemFontOfSize:40];
        
        pickerLabel.text = daysSource[row];
    }
    
    return pickerLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (pickerView.tag == 1111)
    {
        return 180;
    }
    
    return 200;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    if (pickerView.tag == 1111)
    {
        return 30;
    }
    
    return 50;
}

- (CAEmitterLayer *)emitterLayer
{
    if (_emitterLayer)
    {
        return _emitterLayer;
    }
    _emitterLayer = [[CAEmitterLayer alloc]init];
    
    _emitterLayer.backgroundColor = [[UIColor clearColor] CGColor];
    
    [self.layer addSublayer:_emitterLayer];
    
    return _emitterLayer;
    
}

- (void)launchEmitterLayer
{
    CGPoint centerSelf = self.center;
    
    centerSelf.y = self.frame.size.height + 40;
    
    self.emitterLayer.emitterPosition = centerSelf;
    
    self.emitterLayer.birthRate = 2;

    self.emitterLayer.renderMode = kCAEmitterLayerAdditive;
    
    [self addEmitterCells];
}

- (void)addEmitterCells
{
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    
    cell.contents = (id)[UIImage imageNamed:@"Star2"].CGImage;
    cell.birthRate = 2;
    cell.lifetime = 9;
    cell.lifetimeRange = 2;
    cell.velocity = 80;
    cell.velocityRange = 30;
    cell.emissionLatitude = 45*M_PI/180;
    cell.yAcceleration = -50;
    cell.emissionRange = 180*M_PI/180;
    
    CAEmitterCell *cell2 = [CAEmitterCell emitterCell];
    
    cell2.contents = (id)[UIImage imageNamed:@"Star1"].CGImage;
    cell2.birthRate = 4;
    cell2.lifetime = 9;
    cell2.lifetimeRange = 2;
    cell2.velocity = 80;
    cell2.velocityRange = 50;
    cell2.emissionLatitude = 45*M_PI/180;
    cell2.yAcceleration = -50;
    cell2.emissionRange = 180*M_PI/180;
    
    self.emitterLayer.emitterCells = @[cell,cell2];
}
@end

/*
 
 self.emitterLayer.emitterPosition = self.center;
 
 //先设置粒子发送器的属性
 //设置粒子发送器每秒钟发送粒子数量
 self.emitterLayer.birthRate = 2;
 //设置粒子发送器的样式
 self.emitterLayer.renderMode = kCAEmitterLayerAdditive;
 
 
 //初始化要发射的cell
 CAEmitterCell *cell = [CAEmitterCell emitterCell];
 //contents:粒子的内容
 cell.contents = (id)[UIImage imageNamed:@"Star2"].CGImage;//他所需要对象类型的和图层类似
 //接着设置cell的属性
 //    粒子的出生量
 cell.birthRate = 2;
 //    存活时间
 cell.lifetime = 3;
 cell.lifetimeRange = 1;
 //    设置粒子发送速度
 cell.velocity = 50;
 cell.velocityRange = 30;
 //    粒子发送的方向
 cell.emissionLatitude = 90*M_PI/180;
 //    发送粒子的加速度
 cell.yAcceleration = -100;
 
 //    散发粒子的范围  ->  弧度
 cell.emissionRange = 180*M_PI/180;
 
 //最后把粒子的cell添加到粒子发送器  数组内可以添加多个cell对象
 
 */
