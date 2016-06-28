//
//  SrcollBlockCell.m
//  HXBusiness
//
//  Created by RyeWhiskey on 16/2/14.
//  Copyright © 2016年 RyeVishkey. All rights reserved.
//

#import "SrcollBlockCell.h"

@interface SrcollBlockCell ()

{
    
    CGRect infoFrame;
    
}

@end

@implementation SrcollBlockCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(infoFrame.size.width/7, 5, infoFrame.size.width, infoFrame.size.height*0.3)];
        [self addSubview:_nameLabel];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        
        _indexLabel = [[UILabel alloc]initWithFrame:CGRectMake(infoFrame.size.width/7, infoFrame.size.height*0.3+5, infoFrame.size.width, infoFrame.size.height*0.3)];
        [self addSubview:_indexLabel];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.font = [UIFont systemFontOfSize:17];
        
        _upDownLabel = [[UILabel alloc]initWithFrame:CGRectMake(infoFrame.size.width/7, infoFrame.size.height*0.6+5, infoFrame.size.width, infoFrame.size.height*0.2)];
        [self addSubview:_upDownLabel];
        _upDownLabel.textColor = [UIColor whiteColor];
        _upDownLabel.font = [UIFont systemFontOfSize:12];
        
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    infoFrame = frame;
}

@end
