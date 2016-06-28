//
//  RWWelcomeImageCell.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/14.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWWelcomeImageCell.h"

@interface RWWelcomeImageCell ()

@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation RWWelcomeImageCell

@synthesize imageView;

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    imageView.image = _image;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        imageView = [[UIImageView alloc]init];
        
        [self addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.top.equalTo(self.mas_top).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(0);
        }];
    }
    
    return self;
}



@end
