//
//  ADContactsFieldMask.m
//  ADContactsManager
//
//  Created by Anton Domashnev on 10/7/15.
//  Copyright © 2015 Anton Domashnev. All rights reserved.
//

#import "ADContactsFieldMask.h"

/*-------View Controllers-------*/

/*-------Frameworks-------*/
@import Contacts;

/*-------Views-------*/

/*-------Helpers & Managers-------*/

/*-------Models-------*/

@interface ADContactsFieldMask ()

@property (nonatomic, strong, readwrite) NSArray<NSString *> *fieldsArray;

@end

@implementation ADContactsFieldMask

- (instancetype)initWithFields:(ADContactField)fieldsMask {
    self = [super init];
    if (self) {
        self.fieldsArray = [self createFieldsArrayWithFieldsMask:fieldsMask];
    }
    return self;
}

#pragma mark - Helpers

- (NSArray *)createFieldsArrayWithFieldsMask:(ADContactField)fieldsMask {
    NSMutableArray *array = [NSMutableArray array];
    if (fieldsMask & ADContactFieldFirstName) {
        [array addObject:CNContactGivenNameKey];
    }
    if (fieldsMask & ADContactFieldLastName) {
        [array addObject:CNContactFamilyNameKey];
    }
    if (fieldsMask & ADContactFieldMiddleName) {
        [array addObject:CNContactMiddleNameKey];
    }
    if (fieldsMask & ADContactFieldOrganization) {
        [array addObject:CNContactOrganizationNameKey];
    }
    if (fieldsMask & ADContactFieldJobTitle) {
        [array addObject:CNContactJobTitleKey];
    }
    if (fieldsMask & ADContactFieldThumbnail) {
        [array addObject:CNContactThumbnailImageDataKey];
    }
    if (fieldsMask & ADContactFieldPhones) {
        [array addObject:CNContactPhoneNumbersKey];
    }
    if (fieldsMask & ADContactFieldEmails) {
        [array addObject:CNContactEmailAddressesKey];
    }
    if (fieldsMask & ADContactFieldAddresses) {
        [array addObject:CNContactPostalAddressesKey];
    }
    if (fieldsMask & ADContactFieldSocialProfiles) {
        [array addObject:CNContactSocialProfilesKey];
    }
    if (fieldsMask & ADContactFieldBirthday) {
        [array addObject:CNContactBirthdayKey];
    }
    if (fieldsMask & ADContactFieldWebsites) {
        [array addObject:CNContactUrlAddressesKey];
    }
    if (fieldsMask & ADContactFieldNote) {
        [array addObject:CNContactNoteKey];
    }
    if (fieldsMask & ADContactFieldRelatedPersons) {
        [array addObject:CNContactRelationsKey];
    }
    if (fieldsMask & ADContactFieldRecordDate) {
        [array addObject:CNContactDatesKey];
    }
    if (fieldsMask & ADContactFieldImage) {
        [array addObject:CNContactImageDataKey];
    }
    return [array copy];
}

@end
