//
//  ADContactsConverter.m
//  ADContactsManager
//
//  Created by Anton Domashnev on 10/10/15.
//  Copyright © 2015 Anton Domashnev. All rights reserved.
//

#import "ADContactsConverter.h"

/*-------View Controllers-------*/

/*-------Frameworks-------*/

/*-------Views-------*/

/*-------Helpers & Managers-------*/
#import "ADContactsManagerMacros.h"

/*-------Models-------*/
#import "ADContact.h"
#import "ADContactPhone.h"
#import "ADContactEmail.h"
#import "ADContactAddress.h"

@implementation ADContactsConverter

#pragma mark - Interface

- (ADContact *)contactFromFrameworkContact:(CNContact *)frameworkContact {
    NSParameterAssert(frameworkContact);
    ADContact *contact = [ADContact new];
    contact.contactID = frameworkContact.identifier;
    contact.firstName = frameworkContact.givenName;
    contact.lastName = frameworkContact.familyName;
    contact.birthday = [self birthdayDateFromFrameworkBirthdayDateComponents:frameworkContact.birthday];
    contact.organization = frameworkContact.organizationName;
    contact.jobTitle = frameworkContact.jobTitle;
    contact.thumbnailPhotoImageData = frameworkContact.thumbnailImageData;
    contact.emails = [self emailsArrayFromFrameworkEmails:frameworkContact.emailAddresses];
    contact.phones = [self phonesArrayFromFrameworkPhones:frameworkContact.phoneNumbers];
    contact.addresses = [self addressesArrayFromFrameworkAddresses:frameworkContact.postalAddresses];
    contact.middleName = frameworkContact.middleName;
    return contact;
}

- (CNContact *)frameworkContactFromContact:(ADContact *)contact {
    NSParameterAssert(contact);
    CNMutableContact *frameworkContact = [[CNMutableContact alloc] init];
    if (contact.firstName) {
        NSString *firstName = contact.firstName;
        frameworkContact.givenName = firstName;
    }
    if (contact.lastName) {
        NSString *lastName = contact.lastName;
        frameworkContact.familyName = lastName;
    }
    if (contact.middleName) {
        NSString *middleName = contact.middleName;
        frameworkContact.middleName = middleName;
    }
    if (contact.birthday) {
        NSDate *birthday = contact.birthday;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [calendar components:(NSCalendarUnit)(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:birthday];
        frameworkContact.birthday = comps;
    }
    if (contact.organization) {
        NSString *organizationName = contact.organization;
        frameworkContact.organizationName = organizationName;
    }
    if (contact.jobTitle) {
        NSString *jobTitle = contact.jobTitle;
        frameworkContact.jobTitle = jobTitle;
    }
    if (contact.fullSizePhotoImageData) {
        frameworkContact.imageData = contact.fullSizePhotoImageData;
    }
    if (contact.addresses) {
        NSArray<ADContactAddress *> *addresses = contact.addresses;
        frameworkContact.postalAddresses = [self postalAddressesFromContactAddresses:addresses];
    }
    if (contact.emails) {
        NSArray<ADContactEmail *> *emails = contact.emails;
        frameworkContact.emailAddresses = [self emailAddressesFromContactEmails:emails];
    }
    if (contact.phones) {
        NSArray<ADContactPhone *> *phones = contact.phones;
        frameworkContact.phoneNumbers = [self phoneNumbersFromContactPhones:phones];
    }
    return frameworkContact;
}

- (CNMutableContact *)updatedFrameworkContact:(CNContact *)frameworkContact fromContact:(ADContact *)contact {
    NSParameterAssert(contact);
    NSParameterAssert(frameworkContact);
    CNMutableContact *mutableFrameworkContact = [frameworkContact mutableCopy];
    if (contact.firstName) {
        mutableFrameworkContact.givenName = ADNonnull(contact.firstName);
    } else {
        mutableFrameworkContact.givenName = @"";
    }

    if (contact.lastName) {
        mutableFrameworkContact.familyName = ADNonnull(contact.lastName);
    } else {
        mutableFrameworkContact.familyName = @"";
    }

    if (contact.middleName) {
        mutableFrameworkContact.middleName = ADNonnull(contact.middleName);
    } else {
        mutableFrameworkContact.middleName = @"";
    }

    if (contact.organization) {
        mutableFrameworkContact.organizationName = ADNonnull(contact.organization);
    } else {
        mutableFrameworkContact.organizationName = @"";
    }

    if (contact.jobTitle) {
        mutableFrameworkContact.jobTitle = ADNonnull(contact.jobTitle);
    } else {
        mutableFrameworkContact.jobTitle = @"";
    }

    if (contact.addresses) {
        mutableFrameworkContact.postalAddresses = [self postalAddressesFromContactAddresses:ADNonnull(contact.addresses)];
    } else {
        mutableFrameworkContact.postalAddresses = @[];
    }

    if (contact.emails) {
        mutableFrameworkContact.emailAddresses = [self emailAddressesFromContactEmails:ADNonnull(contact.emails)];
    } else {
        mutableFrameworkContact.emailAddresses = @[];
    }

    if (contact.phones) {
        mutableFrameworkContact.phoneNumbers = contact.phones ? [self phoneNumbersFromContactPhones:ADNonnull(contact.phones)] : @[];
    } else {
        mutableFrameworkContact.phoneNumbers = @[];
    }

    if (contact.birthday) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [calendar components:(NSCalendarUnit)(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:ADNonnull(contact.birthday)];
        mutableFrameworkContact.birthday = comps;
    } else {
        mutableFrameworkContact.birthday = nil;
    }

    if (contact.fullSizePhotoImageData) {
        mutableFrameworkContact.imageData = contact.fullSizePhotoImageData;
    } else {
        mutableFrameworkContact.imageData = nil;
    }

    return mutableFrameworkContact;
}

#pragma mark - Helpers

- (NSArray<CNLabeledValue<CNPostalAddress *> *> *)postalAddressesFromContactAddresses:(NSArray<ADContactAddress *> *)addresses {
    NSMutableArray *result = [NSMutableArray array];
    for (ADContactAddress *address in addresses) {
        CNMutablePostalAddress *postalAddress = [[CNMutablePostalAddress alloc] init];
        if (address.street) {
            NSString *street = address.street;
            postalAddress.street = street;
        }
        if (address.country) {
            NSString *country = address.country;
            postalAddress.country = country;
        }
        if (address.city) {
            NSString *city = address.city;
            postalAddress.city = city;
        }
        if (address.state) {
            NSString *state = address.state;
            postalAddress.state = state;
        }
        if (address.zip) {
            NSString *zip = address.zip;
            postalAddress.postalCode = zip;
        }
        CNLabeledValue<CNPostalAddress *> *labeledValue = [CNLabeledValue labeledValueWithLabel:address.label value:postalAddress];
        [result addObject:labeledValue];
    }
    return [result copy];
}

- (NSArray<CNLabeledValue<NSString *> *> *)emailAddressesFromContactEmails:(NSArray<ADContactEmail *> *)emails {
    NSMutableArray *result = [NSMutableArray array];
    for (ADContactEmail *email in emails) {
        NSString *emailValue = email.value;
        CNLabeledValue *labeledValue = [CNLabeledValue labeledValueWithLabel:email.label value:emailValue];
        [result addObject:labeledValue];
    }
    return [result copy];
}

- (NSArray<CNLabeledValue<CNPhoneNumber *> *> *)phoneNumbersFromContactPhones:(NSArray<ADContactPhone *> *)phones {
    NSMutableArray<CNLabeledValue<CNPhoneNumber *> *> *result = [NSMutableArray array];
    for (ADContactPhone *phone in phones) {
        CNPhoneNumber *phoneNumber = [CNPhoneNumber phoneNumberWithStringValue:phone.value];
        if (!phoneNumber) {
            continue;
        }
        CNLabeledValue *labeledValue = [CNLabeledValue labeledValueWithLabel:phone.label value:phoneNumber];
        [result addObject:labeledValue];
    }
    return [result copy];
}

- (nullable NSDate *)birthdayDateFromFrameworkBirthdayDateComponents:(nullable NSDateComponents *)dateComponents {
    if (!dateComponents) {
        return nil;
    }
    NSDateComponents *components = dateComponents;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    return [calendar dateFromComponents:components];
}

- (nullable NSArray<ADContactPhone *> *)phonesArrayFromFrameworkPhones:(NSArray<CNLabeledValue<CNPhoneNumber *> *> *)phones {
    NSMutableArray<ADContactPhone *> *result = [NSMutableArray array];
    for (CNLabeledValue<CNPhoneNumber *> *labeledValue in phones) {
        ADContactPhone *phone = [[ADContactPhone alloc] init];
        phone.value = labeledValue.value.stringValue;
        phone.label = [CNLabeledValue localizedStringForLabel:labeledValue.label];;
        [result addObject:phone];
    }
    return [result copy];
}

- (nullable NSArray<ADContactEmail *> *)emailsArrayFromFrameworkEmails:(NSArray<CNLabeledValue<NSString *> *> *)emails {
    NSMutableArray<ADContactEmail *> *result = [NSMutableArray array];
    for (CNLabeledValue<NSString *> *labelesValue in emails) {
        ADContactEmail *email = [[ADContactEmail alloc] init];
        email.value = labelesValue.value;
        email.label = [CNLabeledValue localizedStringForLabel:labelesValue.label];
        [result addObject:email];
    }
    return [result copy];
}

- (nullable NSArray<ADContactAddress *> *)addressesArrayFromFrameworkAddresses:(NSArray<CNLabeledValue<CNPostalAddress *> *> *)addresses {
    NSMutableArray<ADContactAddress *> *result = [NSMutableArray array];
    for (CNLabeledValue<CNPostalAddress *> *labeledValue in addresses) {
        ADContactAddress *address = [[ADContactAddress alloc] init];
        CNPostalAddress *frameworkAddress = labeledValue.value;
        address.state = frameworkAddress.state;
        address.street = frameworkAddress.street;
        address.country = frameworkAddress.country;
        address.zip = frameworkAddress.postalCode;
        address.city = frameworkAddress.city;
        address.label = [CNLabeledValue localizedStringForLabel:labeledValue.label];;
        [result addObject:address];
    }
    return [result copy];
}

@end
