//
//  RWClassListCell.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/9.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWClassListCell.h"

@interface RWClassListCell ()

@property (nonatomic,strong)UIImageView *headerImage;

@property (nonatomic,strong)UILabel *headerLabel;

@property (nonatomic,strong)UILabel *contentLabel;

@property (nonatomic,strong)UILabel *dateLabel;

@property (nonatomic,strong)UIButton *appointment;

@end

@implementation RWClassListCell

@synthesize headerImage;
@synthesize headerLabel;
@synthesize contentLabel;
@synthesize dateLabel;
@synthesize appointment;

- (void)setDidAppointment:(BOOL)didAppointment
{
    _didAppointment = didAppointment;
    
    appointment.selected = _didAppointment;
    
    if (_didAppointment)
    {
        appointment.backgroundColor = [UIColor grayColor];
    }
    else
    {
        appointment.backgroundColor = MAIN_COLOR;
    }
}

- (void)setHeader:(NSString *)header
{
    _header = header;
    
    headerLabel.text = _header;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    headerImage.image = _image;
}

- (void)setContent:(NSString *)content
{
    _content = content;
    
    contentLabel.text = _content;
}

- (void)setDate:(NSString *)date
{
    _date = date;
    
    dateLabel.text = _date;
}

- (void)appointmentState
{
    [appointment setTitle:@"预约" forState:UIControlStateNormal];
    
    [appointment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [appointment setTitle:@"已预约" forState:UIControlStateSelected];
    
    appointment.titleLabel.font = [UIFont systemFontOfSize:14];
    
    appointment.backgroundColor = MAIN_COLOR;
}

- (void)initViews
{
    headerImage = [[UIImageView alloc]init];
    
    [self addSubview:headerImage];
    
    headerLabel = [[UILabel alloc]init];
    
    headerLabel.font = [UIFont systemFontOfSize:16];
    
    [self addSubview:headerLabel];
    
    contentLabel = [[UILabel alloc]init];
    
    contentLabel.font = [UIFont systemFontOfSize:12];
    
    contentLabel.textColor = [UIColor grayColor];
    
    [self addSubview:contentLabel];
    
    dateLabel = [[UILabel alloc]init];
    
    dateLabel.font = [UIFont systemFontOfSize:10];
    
    dateLabel.textColor = [UIColor grayColor];
    
    dateLabel.textAlignment = NSTextAlignmentRight;
    
    [self addSubview:dateLabel];
    
    appointment = [[UIButton alloc]init];
    
    [self appointmentState];
    
    appointment.layer.cornerRadius = 7;
    
    appointment.clipsToBounds = YES;
    
    [appointment addTarget:self action:@selector(appointmentClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:appointment];
}

- (void)appointmentClick
{
    [self.delegate classListCell:self AppointmentClick:appointment yid:_yid];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(15);
        make.width.equalTo([NSNumber numberWithFloat:frame.size.height - 30]);
        make.height.equalTo([NSNumber numberWithFloat:frame.size.height - 30]);
    }];
    
    headerImage.layer.cornerRadius = (frame.size.height - 30) / 2;
    headerImage.clipsToBounds = YES;
    
    [appointment mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.mas_right).offset(-20);
        make.width.equalTo(@(50));
        make.height.equalTo(@(25));
        make.centerY.equalTo(self.mas_centerY).offset(0);
    }];
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.mas_right).offset(-20);
        make.left.equalTo(headerImage.mas_right).offset(20);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.height.equalTo(@(20));
    }];
    
    [headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(headerImage.mas_right).offset(20);
        make.right.equalTo(appointment.mas_left).offset(-10);
        make.top.equalTo(self.mas_top).offset(10);
        make.height.equalTo(@(30));
    }];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(headerLabel.mas_left).offset(20);
        make.right.equalTo(headerLabel.mas_right).offset(0);
        make.top.equalTo(headerLabel.mas_bottom).offset(0);
        make.bottom.equalTo(dateLabel.mas_top).offset(0);
    }];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self initViews];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
