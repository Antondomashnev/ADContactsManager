//
//  ADAddressBookConverter.m
//  ADContactsManager
//
//  Created by Anton Domashnev on 10/10/15.
//  Copyright © 2015 Anton Domashnev. All rights reserved.
//

#import "ADAddressBookConverter.h"

/*-------View Controllers-------*/

/*-------Frameworks-------*/

/*-------Views-------*/

/*-------Helpers & Managers-------*/

/*-------Models-------*/
#import "ADAddressBookFieldMask.h"
#import "ADContact.h"
#import "ADContactEmail.h"
#import "ADContactPhone.h"
#import "ADContactAddress.h"

@implementation ADAddressBookConverter

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

- (ADContact *)contactFromAddressBookFrameworkContact:(ABRecordRef)frameworkContact fieldMask:(ADAddressBookFieldMask *)fieldMask {
    ADContact *contact = [ADContact new];
    contact.contactID = [NSString stringWithFormat:@"%d", ABRecordGetRecordID(frameworkContact)];

    ADContactField mask = fieldMask.fieldMask;
    if (mask & ADContactFieldFirstName) {
        [self readValueFromRecord:frameworkContact property:kABPersonFirstNameProperty toContact:contact propertyName:@"firstName"];
    }
    if (mask & ADContactFieldLastName) {
        [self readValueFromRecord:frameworkContact property:kABPersonLastNameProperty toContact:contact propertyName:@"lastName"];
    }
    if (mask & ADContactFieldMiddleName) {
        [self readValueFromRecord:frameworkContact property:kABPersonMiddleNameProperty toContact:contact propertyName:@"middleName"];
    }
    if (mask & ADContactFieldJobTitle) {
        [self readValueFromRecord:frameworkContact property:kABPersonJobTitleProperty toContact:contact propertyName:@"jobTitle"];
    }
    if (mask & ADContactFieldOrganization) {
        [self readValueFromRecord:frameworkContact property:kABPersonOrganizationProperty toContact:contact propertyName:@"organization"];
    }
    if (mask & ADContactFieldBirthday) {
        [self readValueFromRecord:frameworkContact property:kABPersonBirthdayProperty toContact:contact propertyName:@"birthday"];
    }
    if (mask & ADContactFieldPhones) {
        contact.phones = [self phonesFromAddressbookPersonRecord:frameworkContact];
    }
    if (mask & ADContactFieldEmails) {
        contact.emails = [self emailsFromAddressbookPersonRecord:frameworkContact];
    }
    if (mask & ADContactFieldAddresses) {
        contact.addresses = [self addressesFromAddressbookPersonRecord:frameworkContact];
    }
    if (mask & ADContactFieldThumbnail) {
        CFTypeRef thumbnailImageDataRef = (ABPersonCopyImageDataWithFormat(frameworkContact, kABPersonImageFormatThumbnail));
        NSData *imageData = (__bridge NSData *)thumbnailImageDataRef;
        if (imageData) {
            contact.thumbnailPhotoImageData = imageData;
            CFRelease(thumbnailImageDataRef);
        }
    }
    if (mask & ADContactFieldImage) {
        CFTypeRef imageDataRef = (ABPersonCopyImageDataWithFormat(frameworkContact, kABPersonImageFormatOriginalSize));
        NSData *imageData = (__bridge NSData *)imageDataRef;
        if (imageData) {
            contact.fullSizePhotoImageData = imageData;
            CFRelease(imageDataRef);
        }
    }
    return contact;
}

- (ABRecordRef)newAddressBookFrameworkContactFromContact:(ADContact *)contact fieldMask:(ADAddressBookFieldMask *)fieldMask {
    ABRecordRef newPerson = ABPersonCreate();
    ADContactField mask = fieldMask.fieldMask;
    if (mask & ADContactFieldFirstName) {
        [self record:newPerson setValue:(__bridge CFTypeRef _Nullable)(contact.firstName) forProperty:kABPersonFirstNameProperty error:nil];
    }
    if (mask & ADContactFieldLastName) {
        [self record:newPerson setValue:(__bridge CFTypeRef _Nullable)(contact.lastName) forProperty:kABPersonLastNameProperty error:nil];
    }
    if (mask & ADContactFieldLastName) {
        [self record:newPerson setValue:(__bridge CFTypeRef _Nullable)(contact.lastName) forProperty:kABPersonLastNameProperty error:nil];
    }
    if (mask & ADContactFieldMiddleName) {
        [self record:newPerson setValue:(__bridge CFTypeRef _Nullable)(contact.middleName) forProperty:kABPersonMiddleNameProperty error:nil];
    }
    if (mask & ADContactFieldOrganization) {
        [self record:newPerson setValue:(__bridge CFTypeRef _Nullable)(contact.organization) forProperty:kABPersonOrganizationProperty error:nil];
    }
    if (mask & ADContactFieldJobTitle) {
        [self record:newPerson setValue:(__bridge CFTypeRef _Nullable)(contact.jobTitle) forProperty:kABPersonJobTitleProperty error:nil];
    }
    if (mask & ADContactFieldBirthday) {
        [self record:newPerson setValue:(__bridge CFTypeRef _Nullable)(contact.birthday) forProperty:kABPersonBirthdayProperty error:nil];
    }
    if (mask & ADContactFieldPhones) {
        [self record:newPerson setPhones:contact.phones error:nil];
    }
    if (mask & ADContactFieldEmails) {
        [self record:newPerson setEmails:contact.emails error:nil];
    }
    if (mask & ADContactFieldAddresses) {
        [self record:newPerson setAddresses:contact.addresses error:nil];
    }
    if (mask & ADContactFieldImage){
        [self record:newPerson setImageData:contact.fullSizePhotoImageData error:nil];
    }
    return newPerson;
}

- (ABRecordRef)updatedAddressBookFrameworkContact:(ABRecordRef)addressBookContact fromContact:(ADContact *)contact fieldMask:(ADAddressBookFieldMask *)fieldMask {
    ADContactField mask = fieldMask.fieldMask;
    if (mask & ADContactFieldFirstName) {
        [self record:addressBookContact setValue:(__bridge CFTypeRef _Nullable)(contact.firstName ? contact.firstName : @"") forProperty:kABPersonFirstNameProperty error:nil];
    }
    if (mask & ADContactFieldLastName) {
        [self record:addressBookContact setValue:(__bridge CFTypeRef _Nullable)(contact.lastName ? contact.lastName : @"") forProperty:kABPersonLastNameProperty error:nil];
    }
    if (mask & ADContactFieldMiddleName) {
        [self record:addressBookContact setValue:(__bridge CFTypeRef _Nullable)(contact.middleName ? contact.middleName : @"") forProperty:kABPersonMiddleNameProperty error:nil];
    }
    if (mask & ADContactFieldOrganization) {
        [self record:addressBookContact setValue:(__bridge CFTypeRef _Nullable)(contact.organization ? contact.organization : @"") forProperty:kABPersonOrganizationProperty error:nil];
    }
    if (mask & ADContactFieldJobTitle) {
        [self record:addressBookContact setValue:(__bridge CFTypeRef _Nullable)(contact.jobTitle ? contact.jobTitle : @"") forProperty:kABPersonJobTitleProperty error:nil];
    }
    if (mask & ADContactFieldBirthday) {
        [self record:addressBookContact setValue:(__bridge CFTypeRef _Nullable)(contact.birthday ? contact.birthday : nil) forProperty:kABPersonBirthdayProperty error:nil];
    }
    if (mask & ADContactFieldPhones) {
        [self record:addressBookContact setPhones:contact.phones error:nil];
    }
    if (mask & ADContactFieldEmails) {
        [self record:addressBookContact setEmails:contact.emails error:nil];
    }
    if (mask & ADContactFieldAddresses) {
        [self record:addressBookContact setAddresses:contact.addresses error:nil];
    }
    if (mask & ADContactFieldImage){
        [self record:addressBookContact setImageData:contact.fullSizePhotoImageData error:nil];
    }
    return addressBookContact;
}

#pragma mark - Helpers

- (void)readValueFromRecord:(ABRecordRef)recordRef property:(ABPropertyID)propertyID toContact:(ADContact *)contact propertyName:(NSString *)propertyName {
    CFTypeRef value = ABRecordCopyValue(recordRef, propertyID);
    [contact setValue:(__bridge id _Nullable)(value) forKey:propertyName];
    if (value) {
        CFRelease(value);
    }
}

- (NSMutableArray<ADContactEmail *> *)emailsFromAddressbookPersonRecord:(ABRecordRef)person {
    NSMutableArray *arrayOfEmails = @[].mutableCopy;
    ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
    CFIndex emailsCount = ABMultiValueGetCount(emails);
    if (!emailsCount) {
        if (emails) {
            CFRelease(emails);
        }
        return arrayOfEmails;
    }
    for (int p = 0; p < emailsCount; p++) {
        NSString *email = (__bridge NSString *)ABMultiValueCopyValueAtIndex(emails, p);
        NSString *group = (__bridge NSString *)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(emails, p));
        ADContactEmail *emailModel = [ADContactEmail new];
        emailModel.value = email;
        emailModel.label = group;
        [arrayOfEmails addObject:emailModel];
    }
    CFRelease(emails);
    return arrayOfEmails;
}

- (NSMutableArray *)phonesFromAddressbookPersonRecord:(ABRecordRef)person {
    NSMutableArray *arrayOfPhones = @[].mutableCopy;
    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex phonesCount = ABMultiValueGetCount(phones);
    if (!phonesCount) {
        CFRelease(phones);
        return arrayOfPhones;
    }
    for (int p = 0; p < phonesCount; p++) {
        NSString *phoneNumber = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phones, p);
        NSString *group = (__bridge NSString *)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phones, p));
        ADContactPhone *phone = [ADContactPhone new];
        phone.value = phoneNumber;
        phone.label = group;
        [arrayOfPhones addObject:phone];
    }
    CFRelease(phones);
    return arrayOfPhones;
}

- (NSMutableArray *)addressesFromAddressbookPersonRecord:(ABRecordRef)person {
    NSMutableArray *arrayOfAddresses = @[].mutableCopy;
    ABMultiValueRef addresses = ABRecordCopyValue(person, kABPersonAddressProperty);
    CFIndex addressesCount = ABMultiValueGetCount(addresses);
    if (!addressesCount) {
        CFRelease(addresses);
        return arrayOfAddresses;
    }
    for (int p = 0; p < addressesCount; p++) {
        CFDictionaryRef dict = ABMultiValueCopyValueAtIndex(addresses, p);
        ADContactAddress *address = [ADContactAddress new];
        address.country = (__bridge NSString *)CFDictionaryGetValue(dict, kABPersonAddressCountryKey);
        address.city = (__bridge NSString *)CFDictionaryGetValue(dict, kABPersonAddressCityKey);
        address.state = (__bridge NSString *)CFDictionaryGetValue(dict, kABPersonAddressStateKey);
        address.zip = (__bridge NSString *)CFDictionaryGetValue(dict, kABPersonAddressZIPKey);
        address.street = (__bridge NSString *)CFDictionaryGetValue(dict, kABPersonAddressStreetKey);
        address.label = (__bridge NSString *)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(addresses, p));
        [arrayOfAddresses addObject:address];
        CFRelease(dict);
    }
    return arrayOfAddresses;
}

- (void)record:(ABRecordRef)record setValue:(nullable CFTypeRef)value forProperty:(ABRecordID)property error:(CFErrorRef *)error {
    if (value) {
        ABRecordSetValue(record, property, value, error);
    }
}

- (void)record:(ABRecordRef)record setImageData:(NSData *)imageData error:(CFErrorRef *)error {
    if (imageData) {
        ABPersonSetImageData(record, (__bridge CFDataRef)(imageData), error);
    }
}

- (void)record:(ABRecordRef)record setEmails:(nullable NSArray *)emails error:(CFErrorRef *)error {
    ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    for (ADContactEmail *email in emails) {
        ABMultiValueAddValueAndLabel(multiEmail, (__bridge CFTypeRef)(email.value), (__bridge CFStringRef)(email.label), NULL);
    }
    [self record:record setValue:multiEmail forProperty:kABPersonEmailProperty error:error];
    CFRelease(multiEmail);
}

- (void)record:(ABRecordRef)record setPhones:(nullable NSArray *)phones error:(CFErrorRef *)error {
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    for (ADContactPhone *phone in phones) {
        ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(phone.value), (__bridge CFStringRef)(phone.label), NULL);
    }
    [self record:record setValue:multiPhone forProperty:kABPersonPhoneProperty error:error];
    CFRelease(multiPhone);
}

- (void)record:(ABRecordRef)record setAddresses:(nullable NSArray *)addresses error:(CFErrorRef *)error {
    ABMultiValueRef multiAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    for (ADContactAddress *address in addresses) {
        NSMutableDictionary *values = [NSMutableDictionary dictionary];
        if (address.country) {
            values[(__bridge NSString *)kABPersonAddressCountryKey] = address.country;
        }
        if (address.city) {
            values[(__bridge NSString *)kABPersonAddressCityKey] = address.city;
        }
        if (address.state) {
            values[(__bridge NSString *)kABPersonAddressStateKey] = address.state;
        }
        if (address.zip) {
            values[(__bridge NSString *)kABPersonAddressZIPKey] = address.zip;
        }
        if (address.street) {
            values[(__bridge NSString *)kABPersonAddressStreetKey] = address.street;
        }
        ABMultiValueAddValueAndLabel(multiAddress, (__bridge CFDictionaryRef)values, (__bridge CFStringRef)address.label, NULL);
    }
    [self record:record setValue:multiAddress forProperty:kABPersonAddressProperty error:error];
    CFRelease(multiAddress);
}

#pragma GCC diagnostic pop

@end
