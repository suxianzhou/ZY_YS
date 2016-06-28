//
//  RWSubjectHubClass+CoreDataProperties.h
//  ZhongYuSubjectHubKY
//
//  Created by RyeWhiskey on 16/4/28.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RWSubjectHubClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWSubjectHubClass (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSDate *uploaddate;

@end

NS_ASSUME_NONNULL_END
