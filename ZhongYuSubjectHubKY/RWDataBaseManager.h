//
//  RWDataBaseManager.h
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/4/26.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWSubjectsModel.h"
#import "RWSubjectClassModel.h"
#import "RWSubjectHubModel.h"
#import "RWSubjectHubClassModel.h"
#import "RWCollectModel.h"
#import "RWBannersModel.h"

typedef NS_OPTIONS(NSInteger, RWCollectType) {
    
    RWCollectTypeOnlyCollect     = 1 << 2,
    RWCollectTypeOnlyWrong       = 2 << 2,
    RWCollectTypeCollectAndWrong = 3 << 2
    
};

typedef NS_OPTIONS(NSInteger, RWAnswerState) {
    
    RWAnswerStateNone            = 0,
    RWAnswerStateCorrect         = 1 << 1,
    RWAnswerStateWrong           = 2 << 1,
    RWAnswerStateShowCorrect     = 1 << 3
    
};

typedef NS_OPTIONS(NSInteger, RWToNumber) {
    
    RWToNumberForString         = 1 << 1,
    RWToNumberForInteger        = 1 << 2
    
};

typedef NS_OPTIONS(NSInteger, RWBannersOf) {
    
    RWBannersOfTitles      = 0,
    RWBannersOfImages      = 1,
    RWBannersOfContentUrls = 2,
    RWBannersOfImageUrls   = 3
};

@interface RWDataBaseManager : NSObject
/**
 *  获取数据库单例
 *
 *  @return
 */
+ (instancetype)defaultManager;
/**
 *  插入表
 *
 *  @param model
 *
 *  @return
 */
- (BOOL)insertEntity:(id)model;
/**
 *  更新表
 *
 *  @param model
 *
 *  @return
 */
- (BOOL)updateEntity:(id)model;
/**
 *  重置数据库（不包括收藏和错题记录）
 *
 *  @return
 */
- (BOOL)replaceDatabase;
/**
 *  删除某科目的数据
 *
 *  @param subjectclass
 *
 *  @return
 */
- (BOOL)deleteEntityWithSubjectClass:(NSString *)subjectclass;
/**
 *  删除某科目的全部题目
 *
 *  @param className
 *
 *  @return
 */
- (BOOL)deleteSubjectClassWithClassName:(NSString *)className;
/**
 *  获取体验答题
 *
 *  @return
 */
- (NSArray *)obtainTasteSubject;
/**
 *  获取专业和url
 *
 *  @return
 */
- (NSArray *)obtainHubClassNames;
/**
 *  获取某科目专业目录
 *
 *  @param title
 *
 *  @return
 */
- (NSArray *)obtainHubNamesWithTitle:(NSString *)title;
/**
 *  获取专业目录
 *
 *  @param hub
 *
 *  @return
 */
- (NSArray *)obtainIndexNameWithHub:(NSString *)hub;
/**
 *  获取专业全部题目
 *
 *  @param indexName
 *
 *  @return
 */
- (NSArray *)obtainSubjectsWithIndexName:(NSString *)indexName AndHubName:(NSString *)hubName;
/**
 *  某专业数据库是否已经存在
 *
 *  @param name
 *
 *  @return 
 */
- (BOOL)isExistHubWithHubName:(NSString *)name;
/**
 *  获取上次结束的indexPath
 *
 *  @param subjectSource
 *
 *  @return 
 */
- (NSIndexPath *)obtainBeginWithBeforeOfLastSubjectWithSubjectSource:(NSArray<RWSubjectsModel *> *)subjectSource;
/**
 *  获取上次做到第几题
 *
 *  @param indexName
 *  @param hubName
 *  @param type      
 *
 *  @return
 */
- (id)toSubjectsWithIndexName:(NSString *)indexName AndHubName:(NSString *)hubName Type:(RWToNumber)type;
/**
 *  插入一条收藏或错题记录
 *
 *  @param model
 *
 *  @return
 */
- (BOOL)insertCollect:(RWSubjectsModel *)model AndType:(RWCollectType)type;
/**
 *  更新一条收藏或错误记录(更新状态)
 *
 *  @param model
 *
 *  @return
 */
- (BOOL)updateCollect:(RWSubjectsModel *)model AndType:(RWCollectType)type;
/**
 *  更新一条收藏或错误记录（更新数据）
 *
 *  @param model
 *
 *  @return 
 */
- (BOOL)updateCollect:(RWCollectModel *)model;
/**
 *  删除一条收藏或错误记录
 *
 *  @param model
 *  @param state
 *
 *  @return
 */
- (BOOL)removeCollect:(RWCollectModel *)model State:(RWCollectType)type;
/**
 *  错题次数+1
 *
 *  @param model
 *
 *  @return 
 */
- (BOOL)updateWrongTimesWith:(RWCollectModel *)model;
/**
 *  获取全部收藏或错误记录
 *
 *  @param type
 *
 *  @return
 */
- (NSDictionary *)obtainCollectSubjectsWithType:(RWCollectType)type;
/**
 *  某条收藏记录是否存在
 *
 *  @param model
 *
 *  @return 
 */
- (BOOL)isExistCollectRecordWithModel:(RWSubjectsModel *)model;
/**
 *  插入一条轮播图数据
 *
 *  @param
 *
 *  @return
 */
- (BOOL)insertBanners:(RWBannersModel *)banners;
/**
 *  更新一条轮播图数据
 *
 *  @param
 *
 *  @return
 */
- (BOOL)updateBanners:(RWBannersModel *)banners;
/**
 *  删除一条轮播图数据
 *
 *  @param
 *
 *  @return
 */
- (BOOL)removeBanners;
/**
 *  获取轮播图数据
 *
 *  @param
 *
 *  @return
 */
- (NSArray *)obtainBanners;

#pragma mark - runtime

- (NSArray *)obtainAllKeysWithModel:(Class)model;

- (NSString *)clearMark:(NSString *)string;



@end
