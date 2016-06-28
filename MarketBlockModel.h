//
//  MarketBlockModel.h
//  HXBusiness
//
//  Created by RyeWhiskey on 16/2/13.
//  Copyright © 2016年 RyeVishkey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarketBlockModel : NSObject

/*
 "code": "600515",
 "Name": "海航基础",
 "Price": "12.84",
 "UpDownRate": "+10.03%",
 "UpDown": "+1.17",
 "excode": "SSE",
 "upOrDownFlag": "+",
 "id": "1598"
 */

@property (nonatomic,copy)NSString *code;

@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *price;

@property (nonatomic,copy)NSString *upDownRate;

@property (nonatomic,copy)NSString *upDown;

@property (nonatomic,copy)NSString *excode;

@property (nonatomic,copy)NSString *upOrDownFlag;

@property (nonatomic,copy)NSString *marketID;

@end
