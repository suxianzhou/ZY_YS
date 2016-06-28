//
//  RWDataBaseManager.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/4/26.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWDataBaseManager.h"
#import "MagicalRecord.h"
#import <objc/runtime.h>
#import "RWSubjectClass+CoreDataProperties.h"
#import "RWSubjects+CoreDataProperties.h"
#import "RWSubjectHub+CoreDataProperties.h"
#import "RWSubjectHubClass+CoreDataProperties.h"
#import "RWCollectHub+CoreDataProperties.h"
#import "RWCollectClass+CoreDataProperties.h"
#import "RWCollectsubject+CoreDataProperties.h"
#import "RWBanners+CoreDataProperties.h"

@implementation RWDataBaseManager

+ (instancetype)defaultManager {
    
    static RWDataBaseManager *_Only = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _Only = [super allocWithZone:NULL];
    });
    
    return _Only;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    return [RWDataBaseManager defaultManager];
}

#pragma mark - subjectHub

- (BOOL)insertEntity:(id)model {
    
    if ([model isKindOfClass:[RWSubjectsModel class]])
    {
        
        RWSubjects *entity = [RWSubjects MR_createEntity];
        
        entity.subjectclass  = [model valueForKey:@"subjectclass"];
        entity.subject       = [model valueForKey:@"subject"];
        entity.answer        = [model valueForKey:@"answer"];
        entity.analysis      = [model valueForKey:@"analysis"];
        entity.answerstate   = [model valueForKey:@"answerstate"];
        entity.a             = [model valueForKey:@"a"];
        entity.b             = [model valueForKey:@"b"];
        entity.c             = [model valueForKey:@"c"];
        entity.d             = [model valueForKey:@"d"];
        entity.e             = [model valueForKey:@"e"];
        entity.subjectnumber = [model valueForKey:@"subjectnumber"];
        entity.hub           = [model valueForKey:@"hub"];
        entity.choose        = nil;
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
        return YES;
        
    }
    else if ([model isKindOfClass:[RWSubjectClassModel class]])
    {

        RWSubjectClass *entity = [RWSubjectClass MR_createEntity];

        entity.uploaddate      = [model valueForKey:@"uploaddate"];

        entity.subjectclass    = [model valueForKey:@"subjectclass"];

        entity.hub             = [model valueForKey:@"hub"];
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
        return YES;
        
    }
    else if ([model isKindOfClass:[RWSubjectHubModel class]])
    {
        
        RWSubjectHub *entity = [RWSubjectHub MR_createEntity];

        entity.testDBURL     = [model valueForKey:@"testDBURL"];

        entity.testDBSize    = [model valueForKey:@"testDBSize"];

        entity.formalDBURL   = [model valueForKey:@"formalDBURL"];

        entity.formalDBSize  = [model valueForKey:@"formalDBSize"];

        entity.title         = [model valueForKey:@"title"];

        entity.hubClass      = [model valueForKey:@"hubClass"];
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
        return YES;
    }
    else if ([model isKindOfClass:[RWSubjectHubClassModel class]])
    {
        RWSubjectHubClass *entity = [RWSubjectHubClass MR_createEntity];

        entity.title              = [model valueForKey:@"title"];

        entity.uploaddate         = [model valueForKey:@"uploaddate"];
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)updateEntity:(id)model {
    
    if ([model isKindOfClass:[RWSubjectsModel class]])
    {
        
        RWSubjects *entity = [RWSubjects MR_findFirstWithPredicate:
                              [NSPredicate predicateWithFormat:
                               @" subjectclass = %@ && hub = %@ && subject = %@ ",
                               [model valueForKey:@"subjectclass"],
                               [model valueForKey:@"hub"],
                               [model valueForKey:@"subject"]]];
        
        if (entity != nil) {
            
            entity.subjectclass  = [model valueForKey:@"subjectclass"];
            entity.subject       = [model valueForKey:@"subject"];
            entity.answer        = [model valueForKey:@"answer"];
            entity.analysis      = [model valueForKey:@"analysis"];
            entity.answerstate   = [model valueForKey:@"answerstate"];
            entity.a             = [model valueForKey:@"a"];
            entity.b             = [model valueForKey:@"b"];
            entity.c             = [model valueForKey:@"c"];
            entity.d             = [model valueForKey:@"d"];
            entity.e             = [model valueForKey:@"e"];
            entity.subjectnumber = [model valueForKey:@"subjectnumber"];
            entity.hub           = [model valueForKey:@"hub"];
            entity.choose        = [model valueForKey:@"choose"];
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            
            return YES;
        }
        
    }
    else if ([model isKindOfClass:[RWSubjectClassModel class]])
    {
        
        RWSubjectClass *entity = [RWSubjectClass MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@" subjectclass = %@ && hub = %@ ",[model valueForKey:@"subjectclass"],[model valueForKey:@"hub"]]];
        
        if (entity != nil) {
            
            entity.uploaddate = [model valueForKey:@"uploaddate"];

            entity.hub        = [model valueForKey:@"hub"];
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            
            return YES;
        }
        
    }
    else if ([model isKindOfClass:[RWSubjectHubModel class]])
    {
        
        RWSubjectHub *entity = [RWSubjectHub MR_findFirstByAttribute:@"formalDBURL" withValue:[model valueForKey:@"formalDBURL"]];
        
        if (entity != nil) {
            
            entity.testDBURL    = [model valueForKey:@"testDBURL"];

            entity.testDBSize   = [model valueForKey:@"testDBSize"];

            entity.formalDBURL  = [model valueForKey:@"formalDBURL"];

            entity.formalDBSize = [model valueForKey:@"formalDBSize"];

            entity.title        = [model valueForKey:@"title"];

            entity.hubClass     = [model valueForKey:@"hubClass"];
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            
            return YES;
        }
    }
    else if ([model isKindOfClass:[RWSubjectHubClassModel class]])
    {
        RWSubjectHubClass *entity = [RWSubjectHubClass MR_findFirstByAttribute:@"title" withValue:[model valueForKey:@"title"]];
        
        if (entity != nil) {
            
            entity.title      = [model valueForKey:@"title"];

            entity.uploaddate = [model valueForKey:@"uploaddate"];
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            
            return YES;
        }
    }
    
    return [self insertEntity:model];
    
}

- (BOOL)replaceDatabase {
    
    BOOL sec             = [RWSubjectHubClass MR_truncateAll];
    BOOL hubsec          = [RWSubjectHub MR_truncateAll];
    BOOL subjectClassSec = [RWSubjectClass MR_truncateAll];
    BOOL subjectsSec     = [RWSubjects MR_truncateAll];
    
    if (hubsec&&subjectsSec&&subjectClassSec&&sec)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}

- (BOOL)deleteSubjectClassWithClassName:(NSString *)className {
    
    RWSubjectClass *subjectClass = [RWSubjectClass MR_findFirstByAttribute:@"subjectclass" withValue:className];
    
    if (subjectClass != nil) {
        
        [subjectClass MR_deleteEntity];
        
        return [self deleteEntityWithSubjectClass:className];
    }
    
    return NO;
    
}

- (BOOL)deleteEntityWithSubjectClass:(NSString *)subjectclass {

    return [RWSubjects MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@" subjectclass = %@ ",subjectclass]];
}

- (NSArray *)obtainTasteSubject
{
    NSString *index = @"体验答题";
    
    NSArray *tastes = [RWSubjects MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@" subjectclass = %@ && hub = %@ ",index,index]];
    
    NSMutableArray *mArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < tastes.count; i++)
    {
        RWSubjectsModel *subject = [[RWSubjectsModel alloc] init];
        
        subject.subjectclass  = [tastes[i] valueForKey:@"subjectclass"];
        subject.subject       = [tastes[i] valueForKey:@"subject"];
        subject.answer        = [tastes[i] valueForKey:@"answer"];
        subject.analysis      = [tastes[i] valueForKey:@"analysis"];
        subject.answerstate   = [tastes[i] valueForKey:@"answerstate"];
        subject.a             = [tastes[i] valueForKey:@"a"];
        subject.b             = [tastes[i] valueForKey:@"b"];
        subject.c             = [tastes[i] valueForKey:@"c"];
        subject.d             = [tastes[i] valueForKey:@"d"];
        subject.e             = [tastes[i] valueForKey:@"e"];
        subject.subjectnumber = [tastes[i] valueForKey:@"subjectnumber"];
        subject.hub           = [tastes[i] valueForKey:@"hub"];
        subject.choose        = [tastes[i] valueForKey:@"choose"];
        
        [mArr addObject:subject];
    }
    
    return mArr;
}

- (NSArray *)obtainHubClassNames {
    
    NSArray *hubClasses  = [RWSubjectHubClass MR_findAll];

    NSMutableArray *mArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < hubClasses.count ; i++) {
        
        RWSubjectHubClassModel *hubClass = [[RWSubjectHubClassModel alloc] init];
        
        hubClass.uploaddate = [hubClasses[i] valueForKey:@"uploaddate"];
        hubClass.title      = [hubClasses[i] valueForKey:@"title"];
        
        [mArr addObject:hubClass];
    }
    
    return mArr;
}

- (NSArray *)obtainHubNamesWithTitle:(NSString *)title {
    
    NSArray *Hubs = [RWSubjectHub MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@" hubClass = %@ ",title]];
    
    NSMutableArray *mArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < Hubs.count; i++) {

        RWSubjectHubModel *hub = [[RWSubjectHubModel alloc] init];

        hub.testDBURL          = [Hubs[i] valueForKey:@"testDBURL"];

        hub.testDBSize         = [Hubs[i] valueForKey:@"testDBSize"];

        hub.formalDBURL        = [Hubs[i] valueForKey:@"formalDBURL"];

        hub.formalDBSize       = [Hubs[i] valueForKey:@"formalDBSize"];

        hub.title              = [Hubs[i] valueForKey:@"title"];

        hub.hubClass           = [Hubs[i] valueForKey:@"hubClass"];

        [mArr addObject:hub];
    }
    
    return mArr;
}

- (NSArray *)obtainIndexNameWithHub:(NSString *)hub {
    
    NSArray *indexNames = [RWSubjectClass MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@" hub = %@ ",hub]];
    
    NSMutableArray *mArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < indexNames.count; i++) {
        
        RWSubjectClassModel *subjuecClass = [[RWSubjectClassModel alloc] init];

        subjuecClass.hub                  = [indexNames[i] valueForKey:@"hub"];

        subjuecClass.uploaddate           = [indexNames[i] valueForKey:@"uploaddate"];

        subjuecClass.subjectclass       = [indexNames[i] valueForKey:@"subjectclass"];

        [mArr addObject:subjuecClass];
        
    }
    
    return mArr;
}

- (NSArray *)obtainSubjectsWithIndexName:(NSString *)indexName AndHubName:(NSString *)hubName
{
    
    NSArray *subjects = [RWSubjects MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@" subjectclass = %@ && hub = %@",indexName,hubName]];
    
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < subjects.count; i++) {
        
        RWSubjectsModel *subject = [[RWSubjectsModel alloc] init];

        subject.subjectclass  = [subjects[i] valueForKey:@"subjectclass"];
        subject.subject       = [subjects[i] valueForKey:@"subject"];
        subject.answer        = [subjects[i] valueForKey:@"answer"];
        subject.analysis      = [subjects[i] valueForKey:@"analysis"];
        subject.answerstate   = [subjects[i] valueForKey:@"answerstate"];
        subject.a             = [subjects[i] valueForKey:@"a"];
        subject.b             = [subjects[i] valueForKey:@"b"];
        subject.c             = [subjects[i] valueForKey:@"c"];
        subject.d             = [subjects[i] valueForKey:@"d"];
        subject.e             = [subjects[i] valueForKey:@"e"];
        subject.subjectnumber = [subjects[i] valueForKey:@"subjectnumber"];
        subject.hub           = [subjects[i] valueForKey:@"hub"];
        subject.choose        = [subjects[i] valueForKey:@"choose"];
        
        [mArr addObject:subject];
    }
    
    return mArr;
    
}

- (NSIndexPath *)obtainBeginWithBeforeOfLastSubjectWithSubjectSource:(NSArray<RWSubjectsModel *> *)subjectSource
{
    for (int i = 0; i < subjectSource.count; i++)
    {
        if ([[subjectSource[i] valueForKey:@"answerstate"] integerValue] == RWAnswerStateNone)
        {
            return [NSIndexPath indexPathForItem:i inSection:0];
        }
    }
    
    return [NSIndexPath indexPathForItem:subjectSource.count - 1 inSection:0];
}

- (id)toSubjectsWithIndexName:(NSString *)indexName AndHubName:(NSString *)hubName Type:(RWToNumber)type
{
    
    NSArray *subjects = [RWSubjects MR_findAllWithPredicate:
                         [NSPredicate predicateWithFormat:
                          @" subjectclass = %@ && hub = %@",
                          indexName,hubName]];
    
    for (int i = 0; i < subjects.count; i++)
    {
        RWSubjects *subject = subjects[i];
        
        if (subject.answerstate.integerValue == RWAnswerStateNone)
        {
            if (type == RWToNumberForString)
            {
                return [NSString stringWithFormat:@"%d/%d",i,(int)(subjects.count)];
            }
            else
            {
                return [NSNumber numberWithInteger:(NSInteger)(i + 1)];
            }

        }
    }
    
    if (type == RWToNumberForString)
    {
        return [NSString stringWithFormat:@"%d/%d",(int)(subjects.count),(int)(subjects.count)];
    }
    else
    {
        return [NSNumber numberWithInteger:subjects.count];
    }
}

- (BOOL)isExistHubWithHubName:(NSString *)name
{
    NSArray *indexNames = [RWSubjectClass MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@" hub = %@ ",name]];
    
    if (indexNames.count > 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - collect

- (BOOL)insertCollect:(RWSubjectsModel *)model AndType:(RWCollectType)type
{
    RWCollectHub *hub = [RWCollectHub MR_findFirstByAttribute:@"hubtitle" withValue:model.hub];
    
    if (!hub)
    {
        hub = [RWCollectHub MR_createEntity];

        hub.hubtitle      = model.hub;
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    
    RWCollectClass *collectClass = [RWCollectClass MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@" hubtitle = %@ && subjectclass = %@",model.hub,model.subjectclass]];
    
    if (!collectClass)
    {
        collectClass = [RWCollectClass MR_createEntity];
        
        collectClass.hubtitle     = model.hub;
        collectClass.subjectclass = model.subjectclass;
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    
    RWCollectsubject *subject = [RWCollectsubject MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@" hub = %@ && subjectclass = %@ && subject = %@ ",model.hub,model.subjectclass,model.subject]];
    
    if (!subject)
    {
        subject = [RWCollectsubject MR_createEntity];
        
        subject.a             = model.a;
        subject.b             = model.b;
        subject.c             = model.c;
        subject.d             = model.d;
        subject.e             = model.e;
        subject.answer        = model.answer;
        subject.analysis      = model.analysis;
        subject.subject       = model.subject;
        subject.hub           = model.hub;
        subject.subjectclass  = model.subjectclass;
        subject.numberOfTimes = [NSNumber numberWithInteger:1];
        subject.collectState  = [NSNumber numberWithInteger:type];
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
        return YES;
    }
    else
    {
        return [self updateCollect:model AndType:type];
    }
    
    return NO;
}

- (BOOL)updateWrongTimesWith:(RWCollectModel *)model
{
    RWCollectsubject *subject = [RWCollectsubject MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@" hub = %@ && subjectclass = %@ && subject = %@ ",model.hub,model.subjectclass,model.subject]];
    
    if (subject)
    {
        subject.numberOfTimes = [NSNumber numberWithInteger:subject.numberOfTimes.integerValue + 1];
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)updateCollect:(RWSubjectsModel *)model AndType:(RWCollectType)type
{
    
    RWCollectsubject *subject = [RWCollectsubject MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@" hub = %@ && subjectclass = %@ && subject = %@ ",model.hub,model.subjectclass,model.subject]];
    
    if (subject)
    {
        subject.a             = model.a;
        subject.b             = model.b;
        subject.c             = model.c;
        subject.d             = model.d;
        subject.e             = model.e;
        subject.answer        = model.answer;
        subject.analysis      = model.analysis;
        subject.subject       = model.subject;
        subject.hub           = model.hub;
        subject.subjectclass  = model.subjectclass;
        
        if ((type == RWCollectTypeOnlyCollect &&
            subject.collectState.integerValue == RWCollectTypeOnlyWrong)
            ||(type == RWAnswerStateWrong &&
               subject.collectState.integerValue == RWCollectTypeOnlyCollect))
        {
            subject.collectState  = [NSNumber numberWithInteger:
                                     RWCollectTypeCollectAndWrong];
        }
        else
        {
            subject.numberOfTimes = [NSNumber numberWithInteger:subject.numberOfTimes.integerValue + 1];
        }
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
        return YES;
    }

    return NO;
}

- (BOOL)updateCollect:(RWCollectModel *)model
{
    RWCollectsubject *subject = [RWCollectsubject MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@" hub = %@ && subjectclass = %@ && subject = %@ ",model.hub,model.subjectclass,model.subject]];
    
    if (subject)
    {
        subject.a             = model.a;
        subject.b             = model.b;
        subject.c             = model.c;
        subject.d             = model.d;
        subject.e             = model.e;
        subject.answer        = model.answer;
        subject.analysis      = model.analysis;
        subject.subject       = model.subject;
        subject.hub           = model.hub;
        subject.subjectclass  = model.subjectclass;
        subject.numberOfTimes = model.numberOfTimes;
        subject.collectState  = model.collectState;
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)removeCollect:(RWSubjectsModel *)model State:(RWCollectType)type
{
    RWCollectsubject *subject = [RWCollectsubject MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@" hub = %@ && subjectclass = %@ && subject = %@ ",model.hub,model.subjectclass,model.subject]];
    
    if (subject.collectState.integerValue == RWCollectTypeOnlyCollect
        ||subject.collectState.integerValue == RWCollectTypeOnlyWrong
        ||type == RWCollectTypeCollectAndWrong)
    {
        RWCollectModel *clModel = [[RWCollectModel alloc] init];
        
        clModel.a             = subject.a;
        clModel.b             = subject.b;
        clModel.c             = subject.c;
        clModel.d             = subject.d;
        clModel.e             = subject.e;
        clModel.answer        = subject.answer;
        clModel.analysis      = subject.analysis;
        clModel.subject       = subject.subject;
        clModel.hub           = subject.hub;
        clModel.subjectclass  = subject.subjectclass;
        clModel.numberOfTimes = subject.numberOfTimes;
        clModel.collectState  = subject.collectState;
        
        return [self deleteCollectEntity:clModel];
    }
    else
    {
        if (type == RWCollectTypeOnlyCollect)
        {
            subject.collectState = [NSNumber numberWithInteger:RWCollectTypeOnlyWrong];
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
        }
        else if (type == RWCollectTypeOnlyWrong)
        {
            subject.collectState = [NSNumber numberWithInteger:RWCollectTypeOnlyCollect];
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
        }
        
        return YES;
    }

    return NO;
}

- (BOOL)deleteCollectEntity:(RWCollectModel *)model
{
    RWCollectsubject *subject = [RWCollectsubject MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@" hub = %@ && subjectclass = %@ && subject = %@ ",model.hub,model.subjectclass,model.subject]];
    
    if (subject)
    {
        [subject MR_deleteEntity];
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    
    NSArray *subjects = [RWCollectsubject MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@" subjectclass = %@",model.subjectclass]];
    
    if (subjects.count == 0) {
        
        RWCollectClass *collectClass = [RWCollectClass MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@" hubtitle = %@ && subjectclass = %@",model.hub,model.subjectclass]];
        
        if (collectClass)
        {
            [collectClass MR_deleteEntity];
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }
        
        NSArray *collectClasses = [RWCollectClass MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@" hubtitle = %@ ",model.hub]];
        
        if (collectClasses.count == 0)
        {
            RWCollectHub *hub = [RWCollectHub MR_findFirstByAttribute:@"hubtitle" withValue:model.hub];
            
            if (hub)
            {
                [hub MR_deleteEntity];
                
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            }
        }
    }
    
    return YES;
}

- (NSDictionary *)obtainCollectSubjectsWithType:(RWCollectType)type
{
    NSArray *hubs = [RWCollectHub MR_findAll];
    
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc]init];
    
    for (int i = 0; i < hubs.count; i++)
    {
        RWCollectHub *hub = hubs[i];
        
        NSString *hubTitle = [NSString stringWithFormat:@"%@",hub.hubtitle];
        
        NSDictionary *subjectClass = [self obtainCollectClassesWithHubTitle:hubTitle Type:type];
        
        if (subjectClass.count > 0)
        {
            [mDic setObject:subjectClass forKey:hubTitle];
        }
    }
    
    return mDic;
}

- (NSDictionary *)obtainCollectClassesWithHubTitle:(NSString *)title Type:(RWCollectType)type
{
    NSArray *collectClasses = [RWCollectClass MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@" hubtitle = %@ ",title]];
    
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc]init];
    
    for (int i = 0; i < collectClasses.count; i++)
    {
        RWCollectClass *collectClass = collectClasses[i];
        
        NSString *classTitle = [NSString stringWithFormat:@"%@",collectClass.subjectclass];
        
        NSArray *subjects = [self obtainCollectSubjectsWithHubTitle:title ClassTitle:classTitle Type:type];
        
        if (subjects.count > 0)
        {
            [mDic setObject:subjects forKey:classTitle];
        }
    }
    
    return mDic;
}

- (NSArray *)obtainCollectSubjectsWithHubTitle:(NSString *)hubTitle ClassTitle:(NSString *)title Type:(RWCollectType)type
{
    RWCollectType unType = type == RWCollectTypeOnlyWrong
                            ?RWCollectTypeOnlyCollect
                            :RWCollectTypeOnlyWrong;
    
    NSArray *collectSubjects = [RWCollectsubject MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@" hub = %@ && subjectclass = %@ && collectState != %@",hubTitle,title,[NSNumber numberWithInteger:unType]]];
    
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < collectSubjects.count; i++)
    {
        RWCollectsubject *subjectEntity = collectSubjects[i];
        
        RWCollectModel *model = [[RWCollectModel alloc] init];
        
        model.a             = subjectEntity.a;
        model.b             = subjectEntity.b;
        model.c             = subjectEntity.c;
        model.d             = subjectEntity.d;
        model.e             = subjectEntity.e;
        model.answer        = subjectEntity.answer;
        model.analysis      = subjectEntity.analysis;
        model.subject       = subjectEntity.subject;
        model.hub           = subjectEntity.hub;
        model.subjectclass  = subjectEntity.subjectclass;
        model.numberOfTimes = subjectEntity.numberOfTimes;
        model.collectState  = subjectEntity.collectState;
        
        [mArr addObject:model];
    }
    
    return mArr;
}

- (BOOL)isExistCollectRecordWithModel:(RWSubjectsModel *)model
{
    
    NSArray *subjects = [RWCollectsubject MR_findAllWithPredicate:
                                 
                                 [NSPredicate predicateWithFormat:@" hub = %@ && subjectclass = %@ && subject = %@ && collectState != %@",model.hub,model.subjectclass,model.subject,[NSNumber numberWithInteger:RWCollectTypeOnlyWrong]]];
    
    if (subjects.count != 0)
    {
        return YES;
    }
    
    return NO;
}

#pragma mark - banners

- (BOOL)insertBanners:(RWBannersModel *)banners
{
    
    RWBanners *entity = [RWBanners MR_createEntity];
    
    entity.imageurl = banners.imageurl;
    
    entity.image = banners.image;
    
    entity.title = banners.title;
    
    entity.contenturl = banners.contenturl;
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    return YES;
}

- (BOOL)updateBanners:(RWBannersModel *)banners
{
    
    RWBanners *entity = [RWBanners MR_findFirstByAttribute:@"contenturl" withValue:banners.contenturl];
    
    if (entity)
    {
        entity.imageurl = banners.imageurl;
        
        entity.image = banners.image;
        
        entity.title = banners.title;
        
        entity.contenturl = banners.contenturl;
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];

        return YES;
    }
    
    return NO;
}

- (BOOL)removeBanners
{
    return [RWBanners MR_truncateAll];
}

- (NSArray *)obtainBanners
{
    NSArray *arr = [RWBanners MR_findAll];
    
    NSMutableArray *banners = [[NSMutableArray alloc]init];
    
    NSMutableArray<UIImage *> *images = [[NSMutableArray alloc]init];
    
    NSMutableArray<NSString *> *titles = [[NSMutableArray alloc]init];
    
    NSMutableArray<NSString *> *urls = [[NSMutableArray alloc]init];
    
    NSMutableArray<NSString *> *imageUrls = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < arr.count; i++)
    {
        [images addObject:[UIImage imageWithData:[arr[i] valueForKey:@"image"]]];
        
        [titles addObject:[NSString stringWithString:[arr[i] valueForKey:@"title"]]];
         
        [urls addObject:[NSString stringWithString:[arr[i] valueForKey:@"contenturl"]]];
        
        [imageUrls addObject:[NSString stringWithString:[arr[i] valueForKey:@"imageurl"]]];
    }
    
    [banners addObject:titles];
    
    [banners addObject:images];
    
    [banners addObject:urls];
    
    [banners addObject:imageUrls];
    
    return banners;
}

#pragma mark - runtime

- (NSArray *)obtainAllKeysWithModel:(Class)model {
    
    unsigned int ivarCut = 0;
    
    Ivar *ivars = class_copyIvarList(model, &ivarCut);
    
    NSMutableArray *nameArr = [[NSMutableArray alloc]init];
    
    for (const Ivar *p = ivars; p < ivars + ivarCut; p++) {
        
        Ivar const ivar = *p;
        
        NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
        
        [nameArr addObject:name];
    }
    
    return [self clearFirstString:nameArr];
}

- (NSArray *)clearFirstString:(NSArray *)arr {
    
    NSMutableArray *mArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < arr.count; i++) {
        NSMutableString *str = [[NSMutableString alloc]initWithString:arr[i]];
        
        [str deleteCharactersInRange:NSMakeRange(0, 1)];
        
        [mArr addObject:str];
    }
    
    return mArr;
}

- (NSString *)clearMark:(NSString *)string {
    
    NSMutableString *mStr = [[NSMutableString alloc]initWithString:string];
    [mStr deleteCharactersInRange:NSMakeRange(0, 5)];
    
    return mStr;
}


@end
