//
//  RWSubjectHubListCell.m
//  ZhongYuSubjectHubKY
//
//  Created by RyeWhiskey on 16/4/27.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWSubjectHubListCell.h"

@interface RWSubjectHubListCell ()

@property (nonatomic,strong)UILabel *state;

@property (nonatomic,strong)UILabel *titleLabel;

@end

@implementation RWSubjectHubListCell

@synthesize state;
@synthesize titleLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        state = [[UILabel alloc]init];
        
        state.textColor = [UIColor grayColor];
        
        state.textAlignment = NSTextAlignmentRight;
        
        state.font = [UIFont systemFontOfSize:14];
        
        [self addSubview:state];
        
        
        titleLabel = [[UILabel alloc]init];
        
        titleLabel.font = [UIFont systemFontOfSize:16];
        
        [self addSubview:titleLabel];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [state mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.left.equalTo(self.mas_right).offset(-90);
        make.right.equalTo(self.mas_right).offset(-40);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.right.equalTo(self.mas_right).offset(-95);
        make.left.equalTo(self.mas_left).offset(15);
    }];
}

- (void)setDownLoadState:(NSString *)downLoadState
{
    _downLoadState = downLoadState;
    
    state.text = _downLoadState;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    titleLabel.text = _title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
