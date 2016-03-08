//
//  ADContactsManager.h
//  ADContactsManager
//
//  Created by Anton Domashnev on 10/6/15.
//  Copyright © 2015 Anton Domashnev. All rights reserved.
//

@import Foundation;

@class ADContact;

#import "ADContactsTypes.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ADContactsManager <NSObject>

/**
 *  Returns access status to the contacts manager
 *  Basically is says if the client can perform operation in underlined system's contacts store or not
 *
 *  @return access status value
 */
- (ADContactsManagerAccessStatus)accessStatus;

/**
 *  Requests access to the underlined system's contacts store
 *  iOS will show alert view with permissions question to the user
 *
 *  @param callback callback with result access status
 */
- (void)requestAccessWithCallback:(ADContactsManagerAccessBlock)callback;

/**
 *  Updates contact in underlined system's contacts store with new information from the given contact
 *
 *  @param contact  contact with updated information
 *  @param callback operation's result callback
 */
- (void)updateContact:(ADContact *)contact withCallback:(ADContactsManagerUpdateBlock)callback;

/**
 *  Adds given contact to the underlined system's contacts store
 *
 *  @param contact  contact to add
 *  @param callback operation's result callback
 */
- (void)addContact:(ADContact *)contact withCallback:(ADContactsManagerAddBlock)callback;

/**
 *  Deletes contact from the underlines contacts store
 *
 *  @param contact  contacts to delete
 *  @param callback operation's result callback
 */
- (void)deleteContact:(ADContact *)contact withCallback:(ADContactsManagerDeleteBlock)callback;

/**
 *  Gets all contacts from the underlined system's contacts store
 *
 *  @param callback operation's result callback
 */
- (void)getContactsWithCallback:(ADContactsManagerGetBlock)callback;

/**
 *  Gets contacts count from the underlined system's contacts store
 *
 *  @param callback operation's result callback
 */
- (void)getContactsCountWithCallback:(ADContactsManagerCountBlock)callback;

@end

@interface ADContactsManager : NSObject

/**
 *  Returns array of available ADContactsManagerSystemFramework types
 *  It returns only ADContactsManagerSystemFrameworkAddressBook proior to iOS 9.0
 *  It returns both ADContactsManagerSystemFrameworkAddressBook and ADContactsManagerSystemFrameworkContacts since iOS 9.0 and higher
 *
 *  @return array of NSNumber objects that wrap up ADContactsManagerSystemFramework type
 */
+ (NSArray<NSNumber *> *)availableContactsManagerSystemFrameworks;

/**
 *  Sets preferred system framework to use
 *  If passed system framework type is not supported it will set available framework
 
 *  @param framework preferred system framework to use
 */
+ (void)setPreferredContactsManagerSystemFramework:(ADContactsManagerSystemFramework)framework;

/**
 *  Returns preferred contacts manager system framework
 *  If not has been set, default is ADContactsManagerSystemFrameworkAddressBook
 *
 *  @return preferred contacts manager system framework
 */
+ (ADContactsManagerSystemFramework)preferredContactsManagerSystemFramework;

/**
 *  Returns contacts manager instance based on preferred contacts manager system framework settings
 *  This is singleton under the hood
 *
 *  @return instance of contacts manager
 */
+ (id<ADContactsManager>)contactsManager;

@end

NS_ASSUME_NONNULL_END