//
//  RWSubjectClass+CoreDataProperties.h
//  ZhongYuSubjectHubKY
//
//  Created by RyeWhiskey on 16/4/28.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RWSubjectClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWSubjectClass (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *subjectclass;
@property (nullable, nonatomic, retain) NSString *hub;
@property (nullable, nonatomic, retain) NSDate *uploaddate;

@end

NS_ASSUME_NONNULL_END
