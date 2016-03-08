//
//  ADAddressBookConverter.h
//  ADContactsManager
//
//  Created by Anton Domashnev on 10/10/15.
//  Copyright © 2015 Anton Domashnev. All rights reserved.
//

@import Foundation;
@import AddressBook;

@class ADAddressBookFieldMask;
@class ADContact;

NS_ASSUME_NONNULL_BEGIN

@interface ADAddressBookConverter : NSObject

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
- (ADContact *)contactFromAddressBookFrameworkContact:(ABRecordRef)contact fieldMask:(ADAddressBookFieldMask *)fieldMask;
- (ABRecordRef)newAddressBookFrameworkContactFromContact:(ADContact *)contact fieldMask:(ADAddressBookFieldMask *)fieldMask;
- (ABRecordRef)updatedAddressBookFrameworkContact:(ABRecordRef)addressBookContact fromContact:(ADContact *)contact fieldMask:(ADAddressBookFieldMask *)fieldMask;
#pragma GCC diagnostic pop

@end

NS_ASSUME_NONNULL_END