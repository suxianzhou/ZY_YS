//
//  RWSetAttributeCell.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/12.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWSetAttributeCell.h"

@implementation RWSetAttributeCell

@synthesize attributeField;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        attributeField = [[UITextField alloc]init];
        
        [self addSubview:attributeField];
        
        attributeField.font = [UIFont systemFontOfSize:14];
        
        attributeField.textAlignment = NSTextAlignmentRight;
        
        attributeField.textColor = [UIColor grayColor];
        
        attributeField.userInteractionEnabled = NO;
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [attributeField mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.mas_right).offset(-40);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.equalTo(@(80));
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
