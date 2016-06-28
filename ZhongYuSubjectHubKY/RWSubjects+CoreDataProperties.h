//
//  RWSubjects+CoreDataProperties.h
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/4/27.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RWSubjects.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWSubjects (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *hub;
@property (nullable, nonatomic, retain) NSString *subjectclass;
@property (nullable, nonatomic, retain) NSString *answer;
@property (nullable, nonatomic, retain) NSString *subject;
@property (nullable, nonatomic, retain) NSString *e;
@property (nullable, nonatomic, retain) NSString *d;
@property (nullable, nonatomic, retain) NSString *c;
@property (nullable, nonatomic, retain) NSString *b;
@property (nullable, nonatomic, retain) NSString *a;
@property (nullable, nonatomic, retain) NSString *analysis;
@property (nullable, nonatomic, retain) NSNumber *answerstate;
@property (nullable, nonatomic, retain) NSNumber *subjectnumber;
@property (nullable, nonatomic, retain) NSString *choose;

@end

NS_ASSUME_NONNULL_END
