
//
//  RWCarouselImageCell.m
//  ZhongYuSubjectHubKY
//
//  Created by RyeWhiskey on 16/4/27.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWCarouselImageCell.h"

@interface RWCarouselImageCell ()

@property (nonatomic,strong)UIImageView *imageView;

@end

@implementation RWCarouselImageCell

@synthesize imageView;

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        imageView = [[UIImageView alloc] init];
        
        [self addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.mas_top).offset(0);
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            
        }];
    }
    
    return self;
}

- (void)setImage:(UIImage *)image {
    
    _image = image;
    
    imageView.image = _image;
}

@end
