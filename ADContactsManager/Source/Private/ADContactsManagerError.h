//
//  ADContactsManagerError.h
//  ADContactsManager
//
//  Created by Anton Domashnev on 2/14/16.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Error codes specific for ADContactsManager framework and ADContactsManagerErrorDomain
 */
typedef NS_ENUM(NSInteger, ADContactsManagerErrorCode) {
    /**
     *  Code for validation error
     */
    ADContactsManagerErrorCodeValidationError = 300,
    /**
     *  Code for address book framework error
     */
    ADContactsManagerErrorCodeAddressBookFrameworkError = 301,
    /**
     *  Code for contacts framework error
     */
    ADContactsManagerErrorCodeContactsFrameworkError = 302,
};

extern NSString * const ADContactsManagerErrorDomain;

/**
 *  Class `ADContactsManagerError` defines the methods to create NSError in ADContactsManagerErrorDomain
 */
@interface ADContactsManagerError : NSObject

/**
 *  Creates the error in ADContactsManagerErrorDomain
 *
 *  @param code            given error code
 *  @param message         given error message (will be used for localized description)
 *  @param underlyingError underlying error object
 *
 *  @return newly create error
 */
+ (NSError *)errorWithCode:(ADContactsManagerErrorCode)code message:(nullable NSString *)message underlineError:(nullable NSError *)underlyingError;

/**
 *  Creates the error in ADContactsManagerErrorDomain
 *
 *  @param parameterName invalid parameter name
 *  @param value         value of the invalid parameter
 *
 *  @return newly create error
 */
+ (NSError *)validationErrorForParameterName:(NSString *)parameterName value:(nullable id)value;

@end

NS_ASSUME_NONNULL_END