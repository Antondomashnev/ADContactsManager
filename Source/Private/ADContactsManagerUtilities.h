//
//  ADContactsManagerUtilities.h
//  ADContactsManager
//
//  Created by Anton Domashnev on 2/14/16.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface ADContactsManagerUtilities : NSObject

/**
 * If an NSError pointer variable isn’t passed in then you can get a crash. This method sets it if it is not nil
 * @param error - the error to set the value for
 * @param errorToSet - the value to set.
 */
+ (void)error:(NSError *__nullable *)error setError:(nullable NSError *)errorToSet;

/**
 *  Compares two given strings. This will return YES when compares two nil. Otherwise it uses isEqualTwoString:
 *
 *  @param string1 first string to be compare with
 *  @param string2 second string to be compare with
 *
 *  @return comparison result - equal or not
 */
+ (BOOL)string:(nullable NSString *)string1 isEqualToString:(nullable NSString *)string2;

/**
 *  Safe way to set object for key in the given dictionary. It checks for nil value both key and object
 *
 *  @param dictionary dictionary to set object for
 *  @param object     object to set
 *  @param key        key for object
 */
+ (void)dictionary:(NSMutableDictionary *)dictionary setObject:(nullable id)object forKey:(nullable id<NSCopying>)key;

@end

NS_ASSUME_NONNULL_END
