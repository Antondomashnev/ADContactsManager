//
//  ADContactsManagerUtilities.m
//  ADContactsManager
//
//  Created by Anton Domashnev on 2/14/16.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

#import "ADContactsManagerUtilities.h"

@implementation ADContactsManagerUtilities

#pragma mark - Interface

+ (void)error:(NSError *__nullable *)error setError:(nullable NSError *)errorToSet {
    if (error && errorToSet) {
        *error = errorToSet;
    }
}

+ (BOOL)string:(nullable NSString *)string1 isEqualToString:(nullable NSString *)string2 {
    if((!string1 && string2) || (string1 && !string2)){
        return NO;
    }
    NSString *updatedString1 = string1 ? string1 : @"";
    NSString *updatedString2 = string2 ? string2 : @"";
    return [updatedString1 isEqualToString:updatedString2];
}

+ (void)dictionary:(NSMutableDictionary *)dictionary setObject:(nullable id)object forKey:(nullable id<NSCopying>)key {
    if (!object || !key) {
        return;
    }
    id<NSCopying> notNilKey = key;
    id notNilObject = object;
    dictionary[notNilKey] = notNilObject;
}

@end
