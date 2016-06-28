//
//  RWRequsetManager+UserLogin.h
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/10.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWRequsetManager.h"

/**
 *  回调 RWRequsetDelegate
 */

@interface RWRequsetManager (UserLogin)
/**
 *  新用户注册
 *
 *  @param username 用户名
 *  @param password 密码
 */
- (void)registerWithUsername:(NSString *)username AndPassword:(NSString *)password;
/**
 *  用户登录
 *
 *  @param username 用户名
 *  @param password 密码
 */
- (void)userinfoWithUsername:(NSString *)username AndPassword:(NSString *)password;
/**
 *  重置密码
 *
 *  @param username 用户名
 *  @param password 密码
 */
- (void)replacePasswordWithUsername:(NSString *)username AndPassword:(NSString *)password;
/**
 *  获取验证码
 *
 *  @param phoneNumber 手机号
 *  @param complate    是否获取成功
 */
- (void)obtainVerificationCodeWithPhoneNumber:(NSString *)phoneNumber Complate:(void(^)(BOOL isSuccessed))complate;
/**
 *  验证手机号
 *
 *  @param verificationCode 验证码
 *  @param phoneNumber      手机号
 *  @param complate         是否验证成功
 */
- (void)verificationWithVerificationCode:(NSString *)verificationCode PhoneNumber:(NSString *)phoneNumber Complate:(void(^)(BOOL isSuccessed))complate;
/**
 *  验证手机号是否符合
 *
 *  @param phoneNumber 手机号
 *
 *  @return
 */
- (BOOL)verificationPhoneNumber:(NSString *)phoneNumber;
/**
 *  验证密码是否符合标准
 *
 *  @param password 密码
 *
 *  @return
 */
- (BOOL)verificationPassword:(NSString *)password;
/**
 *  验证邮箱是否符合标准
 *
 *  @param Email 邮箱
 *
 *  @return 
 */
- (BOOL)verificationEmail:(NSString *)Email;

@end

