//
//  RWCollectClass+CoreDataProperties.h
//  ZhongYuSubjectHubKY
//
//  Created by RyeWhiskey on 16/4/30.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RWCollectClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWCollectClass (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *hubtitle;
@property (nullable, nonatomic, retain) NSString *subjectclass;

@end

NS_ASSUME_NONNULL_END
