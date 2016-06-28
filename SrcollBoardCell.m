//
//  SrcollBoardCell.m
//  HXBusiness
//
//  Created by RyeWhiskey on 16/2/16.
//  Copyright © 2016年 RyeVishkey. All rights reserved.
//

#import "SrcollBoardCell.h"

@interface SrcollBoardCell ()

{
    
    CGRect infoFrame;
    
}

@end

@implementation SrcollBoardCell

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    infoFrame = frame;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _showLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, infoFrame.size.width, infoFrame.size.height)];
        _showLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_showLabel];
        self.backgroundColor = [UIColor whiteColor];
        
    }
    
    return self;
    
}

@end
