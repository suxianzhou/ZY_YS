//
//  RWAnimations.h
//  Animation
//
//  Created by zhongyu on 16/6/15.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const fireworksAnimation;

typedef NS_ENUM(NSInteger,RWAnimationLevel)
{
    RWAnimationLv1  = 0,
    RWAnimationLv2  = 1,
    RWAnimationLv3  = 2,
    RWAnimationLv4  = 3,
    RWAnimationLv5  = 4,
    RWAnimationLv6  = 5,
    RWAnimationLv7  = 6,
    RWAnimationLv8  = 7,
    RWAnimationLv9  = 8,
    RWAnimationLv10 = 9
};

@interface RWAnimations : UIView

+ (instancetype)animation:(NSString *)animation Level:(RWAnimationLevel)level Frame:(CGRect)frame;

@end
