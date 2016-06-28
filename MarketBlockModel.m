//
//  MarketBlockModel.m
//  HXBusiness
//
//  Created by RyeWhiskey on 16/2/13.
//  Copyright © 2016年 RyeVishkey. All rights reserved.
//

#import "MarketBlockModel.h"

@implementation MarketBlockModel

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@<%@<%@<%@<%@<%@<%@<%@", _code,_name,_price,_upDown,_upDownRate,_upOrDownFlag,_excode,_marketID];
}

@end
