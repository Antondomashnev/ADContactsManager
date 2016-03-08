//
//  ADContactsTypes.h
//  ADContactsManager
//
//  Created by Anton Domashnev on 10/7/15.
//  Copyright © 2015 Anton Domashnev. All rights reserved.
//

@import Foundation;

@class ADContact;

typedef NS_ENUM (NSUInteger, ADContactsManagerAccessStatus) {
    ADContactsManagerAccessStatusNotDetermined = 0,
    ADContactsManagerAccessStatusRestricted,
    ADContactsManagerAccessStatusDenied,
    ADContactsManagerAccessStatusAuthorized
};

typedef NS_ENUM (NSUInteger, ADContactsManagerSystemFramework) {
    ADContactsManagerSystemFrameworkAddressBook,
    ADContactsManagerSystemFrameworkContacts
};

typedef NS_OPTIONS (NSUInteger, ADContactField)
{
    ADContactFieldFirstName = 1 << 0,
        ADContactFieldLastName = 1 << 1,
        ADContactFieldMiddleName = 1 << 2,
        ADContactFieldJobTitle = 1 << 3,
        ADContactFieldThumbnail = 1 << 4,
        ADContactFieldPhones = 1 << 5,
        ADContactFieldEmails = 1 << 6,
        ADContactFieldAddresses = 1 << 7,
        ADContactFieldSocialProfiles = 1 << 8,
        ADContactFieldBirthday = 1 << 9,
        ADContactFieldWebsites = 1 << 10,
        ADContactFieldNote = 1 << 11,
        ADContactFieldRelatedPersons = 1 << 12,
        ADContactFieldSource = 1 << 13,
        ADContactFieldRecordDate = 1 << 14,
        ADContactFieldOrganization = 1 << 15,
        ADContactFieldImage = 1 << 16,
        ADContactFieldAll = 0xFFFFFFFF
};

typedef void (^ADContactsManagerAccessBlock)(ADContactsManagerAccessStatus status, NSError *__nullable error);
typedef void (^ADContactsManagerAddBlock)(ADContact *__nullable contact, NSError *__nullable error);
typedef void (^ADContactsManagerUpdateBlock)(ADContact *__nullable contact, NSError *__nullable error);
typedef void (^ADContactsManagerDeleteBlock)(BOOL result, NSError *__nullable error);
typedef void (^ADContactsManagerGetBlock)(NSArray<ADContact *> *__nullable contactsArray, NSError *__nullable error);
typedef void (^ADContactsManagerCountBlock)(NSUInteger contactsCount, NSError *__nullable error);
typedef void (^ADContactsManagerBooleanErrorBlock)(BOOL result, NSError *__nullable error);
