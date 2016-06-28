//
//  RWCollectsubject+CoreDataProperties.h
//  ZhongYuSubjectHubKY
//
//  Created by RyeWhiskey on 16/4/30.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RWCollectsubject.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWCollectsubject (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *a;
@property (nullable, nonatomic, retain) NSString *b;
@property (nullable, nonatomic, retain) NSString *c;
@property (nullable, nonatomic, retain) NSString *d;
@property (nullable, nonatomic, retain) NSString *e;
@property (nullable, nonatomic, retain) NSString *answer;
@property (nullable, nonatomic, retain) NSString *subject;
@property (nullable, nonatomic, retain) NSString *analysis;
@property (nullable, nonatomic, retain) NSString *hub;
@property (nullable, nonatomic, retain) NSString *subjectclass;
@property (nullable, nonatomic, retain) NSNumber *numberOfTimes;
@property (nullable, nonatomic, retain) NSNumber *collectState;
@property (nullable, nonatomic, retain) NSString *choose;

@end

NS_ASSUME_NONNULL_END
