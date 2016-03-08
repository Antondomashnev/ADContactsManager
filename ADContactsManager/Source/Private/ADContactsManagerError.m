//
//  ADContactsManagerError.m
//  ADContactsManager
//
//  Created by Anton Domashnev on 2/14/16.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

#import "ADContactsManagerError.h"

/*-------View Controllers-------*/

/*-------Frameworks-------*/

/*-------Views-------*/

/*-------Helpers & Managers-------*/
#import "ADContactsManagerUtilities.h"

/*-------Models-------*/

NSString * const ADContactsManagerErrorDomain = @"com.antondomashnev.ADContactsManager.ADContactsManagerErrorDomain";

@implementation ADContactsManagerError

#pragma mark - Interface

+ (NSError *)validationErrorForParameterName:(NSString *)parameterName value:(nullable id)value {
    return [self errorWithCode:ADContactsManagerErrorCodeValidationError message:[NSString stringWithFormat:NSLocalizedString(@"Invalid value for %@: %@", nil), parameterName, value] underlineError:nil];
}

+ (NSError *)errorWithCode:(ADContactsManagerErrorCode)code message:(nullable NSString *)message underlineError:(nullable NSError *)underlyingError {
    NSMutableDictionary *completedUserInfo = [NSMutableDictionary dictionary];
    [ADContactsManagerUtilities dictionary:completedUserInfo setObject:message forKey:NSLocalizedDescriptionKey];
    [ADContactsManagerUtilities dictionary:completedUserInfo setObject:underlyingError forKey:NSUnderlyingErrorKey];
    NSDictionary *userInfo = [completedUserInfo count] > 0 ? [completedUserInfo copy] : nil;
    return [NSError errorWithDomain:ADContactsManagerErrorDomain code:code userInfo:userInfo];
}

@end