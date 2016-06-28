//
//  RWRequsetManager+UserLogin.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/10.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWRequsetManager+UserLogin.h"
#import <SMS_SDK/SMSSDK.h>
#import "UMComPushRequest.h"
#import "UMComUserAccount.h"

@implementation RWRequsetManager (UserLogin)

- (void)registerWithUsername:(NSString *)username AndPassword:(NSString *)password
{
    
    UMComUserAccount *userAccount = [[UMComUserAccount alloc] init];
    
    userAccount.usid = username;
    userAccount.name = username;
    
    ////登录之前先设置登录前的viewController，方便登录逻辑完成之后，跳转回来
    [UMComPushRequest loginWithCustomAccountForUser:userAccount completion:^(id responseObject, NSError *error) {
        
        if(!error)
        {
            NSDictionary *body = @{@"username":username,@"password":password};
            
            [self.manager POST:REGISTER_URL parameters:body progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                
                if ([[Json objectForKey:@"resultCode"] integerValue] == 0)
                {
                    [[RWDeployManager defaultManager]
                                        changeLoginStatusWithStatus:DID_LOGIN
                                                           Username:username
                                                           Password:password
                                                   termOfEndearment:username];
                    
                    [self.delegate registerResponds:YES
                                        ErrorReason:nil];
                }
                else
                {
                    [self.delegate registerResponds:NO
                                        ErrorReason:[Json objectForKey:@"result"]];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self.delegate requestError:error
                                       Task:task];
            }];
        }
        else
        {
            
            [self.delegate registerResponds:NO
                                ErrorReason:error.description];
        }
    }];
}

- (void)userinfoWithUsername:(NSString *)username AndPassword:(NSString *)password
{
    RWDeployManager *deploy = [RWDeployManager defaultManager];
    
    UMComUserAccount *userAccount = [[UMComUserAccount alloc] init];
    
    userAccount.usid = username;
    userAccount.name = username;
    
    ////登录之前先设置登录前的viewController，方便登录逻辑完成之后，跳转回来
    [UMComPushRequest loginWithCustomAccountForUser:userAccount completion:^(id responseObject, NSError *error) {
        
        NSLog(@"res = %@",responseObject);
        
        if(!error)
        {
            NSDictionary *body = @{@"username":username,@"password":password};
            
            [self.manager POST:LOGIN_URL parameters:body progress:^(NSProgress * _Nonnull uploadProgress) {
                nil;
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                
                if ([[Json objectForKey:@"resultCode"] integerValue] == 0)
                {
                    
                    
                    [deploy changeLoginStatusWithStatus:DID_LOGIN
                                               Username:username
                                               Password:password
                                       termOfEndearment:userAccount.name];
                    
                    [self.delegate userLoginResponds:YES ErrorReason:nil];
                }
                else
                {
                    [self.delegate userLoginResponds:NO
                                         ErrorReason:[Json objectForKey:@"result"]];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
             {
                
                [self.delegate requestError:error Task:task];
            }];
        }
        else
        {
            [self.delegate userLoginResponds:NO
                                 ErrorReason:error.description];
        }
    }];
}

- (void)replacePasswordWithUsername:(NSString *)username AndPassword:(NSString *)password
{
    NSDictionary *body = @{@"username":username,@"password":password};
    
    [self.manager POST:REPLACE_PASSWORD_URL parameters:body progress:^(NSProgress * _Nonnull uploadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[Json objectForKey:@"resultCode"] integerValue] == 0)
        {
            [self.delegate replacePasswordResponds:YES ErrorReason:nil];
        }
        else
        {
            [self.delegate replacePasswordResponds:NO ErrorReason:
                                                        [Json objectForKey:@"result"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.delegate requestError:error Task:task];
    }];
}

- (void)obtainVerificationCodeWithPhoneNumber:(NSString *)phoneNumber Complate:(void(^)(BOOL isSuccessed))complate
{
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
                            phoneNumber:phoneNumber
                                   zone:@"86"
                       customIdentifier:nil
                                 result:^(NSError *error){
                                     
                                     if (!error)
                                     {
                                         complate(YES);
                                     }
                                     else
                                     {
                                         complate(NO);
                                     }
                                 }];
}

- (void)verificationWithVerificationCode:(NSString *)verificationCode PhoneNumber:(NSString *)phoneNumber Complate:(void(^)(BOOL isSuccessed))complate
{
    [SMSSDK commitVerificationCode:verificationCode
                       phoneNumber:phoneNumber
                              zone:@"86"
                            result:^(NSError *error) {
        
        if (!error)
        {
            complate(YES);
        }
        else
        {
            complate(NO);
            NSLog(@"错误信息:%@",error);
        }
    }];
}

- (BOOL)verificationPhoneNumber:(NSString *)phoneNumber
{
    NSString *mobile = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    
    NSPredicate *regexTestMobile =
                        [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobile];
    
    return [regexTestMobile evaluateWithObject:phoneNumber];
}

- (BOOL)verificationPassword:(NSString *)password
{
    return password.length >= 6 && password.length <= 18 ? YES : NO;
}

- (BOOL)verificationEmail:(NSString *)Email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:Email];
}

@end
