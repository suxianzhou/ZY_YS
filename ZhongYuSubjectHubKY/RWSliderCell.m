//
//  RWSliderCell.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/6/30.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWSliderCell.h"

@interface RWSliderCell()

@property (nonatomic,strong)UILabel *nameLabel;

@property (nonatomic,strong)UISlider *countSlider;

@property (nonatomic,strong)UILabel *value;

@property (nonatomic,strong)UIImageView *imageLogo;

@end

@implementation RWSliderCell

@synthesize nameLabel;
@synthesize countSlider;
@synthesize value;
@synthesize imageLogo;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self initViews];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self autoLayoutViews];
}

- (void)updateValues:(UISlider *)slider
{
    _counts = slider.value;
    
    [self setSubjectCountsWithValue:_counts];
}

- (void)updateValueEnd:(UISlider *)slider
{
    int remainder = (int)_counts % 10;
    
    if (remainder >= 5)
    {
        _counts = (float)((int)_counts / 10 * 10 + 10);
    }
    else
    {
        _counts = (float)((int)_counts / 10 * 10);
    }
    
    slider.value = _counts;
}

- (void)initViews
{
    nameLabel = [[UILabel alloc] init];
    
    [self addSubview:nameLabel];
    
    countSlider = [[UISlider alloc] init];
    countSlider.layer.cornerRadius = 2;
    countSlider.clipsToBounds = YES;
    countSlider.maximumValue = 100;
    countSlider.minimumValue = 20;
    
    countSlider.thumbTintColor = [UIColor blackColor];
    countSlider.minimumTrackTintColor = MAIN_COLOR;
    
    [countSlider addTarget:self
                    action:@selector(updateValues:)
          forControlEvents:UIControlEventValueChanged];
    
    [countSlider addTarget:self
                    action:@selector(updateValueEnd:)
          forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:countSlider];
    
    value = [[UILabel alloc] init];
    value.font = [UIFont systemFontOfSize:14];
    value.textColor = [UIColor grayColor];
    
    [self addSubview:value];
    
    imageLogo = [[UIImageView alloc] init];
    imageLogo.image = [UIImage imageNamed:@"edit_t"];
    
    [self addSubview:imageLogo];
}

- (void)autoLayoutViews
{
    [imageLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(20));
        make.height.equalTo(@(23));
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.equalTo(self.mas_centerY).offset(0);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(30);
        make.right.equalTo(imageLogo.mas_left).offset(-10);
        make.top.equalTo(self.mas_top).offset(5);
        make.bottom.equalTo(self.mas_bottom).offset(-self.frame.size.height/2);
    }];
    
    [countSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(30);
        make.right.equalTo(imageLogo.mas_left).offset(-80);
        make.height.equalTo(@(30));
        make.centerY.equalTo(nameLabel.mas_centerY).offset(self.frame.size.height/2);
    }];
    
    [value mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(countSlider.mas_right).offset(10);
        make.top.equalTo(nameLabel.mas_bottom).offset(0);
        make.right.equalTo(imageLogo.mas_left).offset(-10);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
}

- (void)setName:(NSString *)name
{
    _name = name;
    
    nameLabel.text = _name;
    
    _counts = 50.0f;
    countSlider.value = _counts;
    
    [self setSubjectCountsWithValue:_counts];
}

- (void)setSubjectCountsWithValue:(float)changeValue
{
    int remainder = (int)changeValue % 10;
    
    int changeCount;
    
    if (remainder >= 5)
    {
        changeCount = (int)changeValue / 10 * 10 + 10;
    }
    else
    {
        changeCount = (int)changeValue / 10 * 10;
    }
    
    value.text = [NSString stringWithFormat:@"%d题",changeCount];
}

@end
