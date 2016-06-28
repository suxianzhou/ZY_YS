//
//  RWSubjectHub+CoreDataProperties.h
//  ZhongYuSubjectHubKY
//
//  Created by RyeWhiskey on 16/4/28.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RWSubjectHub.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWSubjectHub (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *formalDBSize;
@property (nullable, nonatomic, retain) NSString *formalDBURL;
@property (nullable, nonatomic, retain) NSString *testDBSize;
@property (nullable, nonatomic, retain) NSString *testDBURL;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *hubClass;

@end

NS_ASSUME_NONNULL_END
