//
//  RWClassListModel.h
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/9.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 "title": "【临床】妇产科",
 "teacher": "张远方",
 "pic": "http://www.zhongyuedu.com/app/images/yy_jz.png",
 "videoid": "2FD815DA18613F809C33DC5901307461",
 "num": 7733,
 "yid": 160528
 */

@interface RWClassListModel : NSObject

@property (nonatomic,strong)NSString *title;

@property (nonatomic,strong)NSString *teacher;

@property (nonatomic,strong)NSString *pic;

@property (nonatomic,strong)NSNumber *num;

@property (nonatomic,strong)NSNumber *yid;

@property (nonatomic,strong)NSString *videoid;

@end
