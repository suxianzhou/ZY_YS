//
//  UMengAnalyticsManager.h
//  ZYTK
//
//  Created by 王辰 on 16/4/14.
//  Copyright © 2016年 WCX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMengAnalyticsManager : NSObject

+(instancetype)defaultManager;


-(void)profileSignInWithUsername:(NSString *) username;

@end
