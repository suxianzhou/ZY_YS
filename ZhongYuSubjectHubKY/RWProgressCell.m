//
//  RWProgressCell.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/6/13.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWProgressCell.h"

@interface RWProgressCell()

@property (nonatomic,strong)UILabel *nameLabel;

@property (nonatomic,strong)UIProgressView *progressView;

@property (nonatomic,strong)UILabel *value;

@property (nonatomic,strong)UIImageView *imageLogo;

@end

@implementation RWProgressCell

@synthesize nameLabel;
@synthesize progressView;
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

- (void)initViews
{
    nameLabel = [[UILabel alloc] init];
    
    [self addSubview:nameLabel];
    
    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    
    progressView.layer.cornerRadius = 2;
    
    progressView.clipsToBounds = YES;
    
    [self addSubview:progressView];
    
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
    
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(30);
        make.right.equalTo(imageLogo.mas_left).offset(-80);
        make.height.equalTo(@(4));
        make.centerY.equalTo(nameLabel.mas_centerY).offset(self.frame.size.height/2);
    }];
    
    [value mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(progressView.mas_right).offset(10);
        make.top.equalTo(nameLabel.mas_bottom).offset(0);
        make.right.equalTo(imageLogo.mas_left).offset(-10);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
}

- (void)setName:(NSString *)name
{
    _name = name;
    
    nameLabel.text = _name;
}

- (void)setFraction:(NSString *)fraction
{
    _fraction = fraction;
    
    value.text = _fraction;
    
    [progressView setProgress:[self percentageWithString:_fraction] animated:YES];
    
    progressView.progressTintColor = [UIColor colorWithRed:84.0f/255.0f
                                                     green:139.0f/255.0f
                                                      blue:84.0f/255.0f
                                                     alpha:1.0];}

- (float)percentageWithString:(NSString *)string
{
    NSArray *arr = [string componentsSeparatedByString:@"/"];
    
    if (arr.count != 2)
    {
        return 0;
    }
    
    return [arr[0] floatValue] / [arr[1] floatValue];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
