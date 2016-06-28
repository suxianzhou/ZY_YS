//
//  RWBanners+CoreDataProperties.h
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/4.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RWBanners.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWBanners (CoreDataProperties)

@property (nullable, nonatomic, retain) id image;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *imageurl;
@property (nullable, nonatomic, retain) NSString *contenturl;

@end

NS_ASSUME_NONNULL_END
