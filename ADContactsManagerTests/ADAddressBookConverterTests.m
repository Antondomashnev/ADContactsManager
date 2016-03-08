//
//  ADAddressBookConverterTests.m
//  Tactup
//
//  Created by Anton Domashnev on 10/11/15.
//  Copyright © 2015 Pieoneers. All rights reserved.
//

@import XCTest;
@import AddressBook;

#import <OCMock/OCMock.h>

#import "ADAddressBookFieldMask.h"
#import "ADAddressBookConverter.h"
#import "ADContact.h"
#import "ADContactPhone.h"
#import "ADContactEmail.h"
#import "ADContactAddress.h"

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

@interface ADAddressBookConverterTests : XCTestCase

@end

@implementation ADAddressBookConverterTests

- (void)testThatItShouldConvertContactToFrameworkContact {
    ADContact *contact = [ADContact new];
    contact.firstName = @"Petr";
    contact.lastName = @"Ivanov";
    contact.jobTitle = @"iOS Developer";
    contact.organization = @"Pieoneers";
    contact.birthday = [NSDate dateWithTimeIntervalSince1970:0];
    
    ADContactPhone *phone1 = [[ADContactPhone alloc] init];
    phone1.label = @"Home";
    phone1.value = @"79036437373";
    ADContactPhone *phone2 = [[ADContactPhone alloc] init];
    phone2.label = @"Work";
    phone2.value = @"79036437390";
    contact.phones = @[phone1, phone2];
    
    ADContactEmail *email1 = [[ADContactEmail alloc] init];
    email1.label = @"Home";
    email1.value = @"petr.ivanov@gmail.com";
    ADContactEmail *email2 = [[ADContactEmail alloc] init];
    email2.label = @"Work";
    email2.value = @"petr.ivanov@pieoneers.com";
    contact.emails = @[email1, email2];
    
    ADContactAddress *address = [[ADContactAddress alloc] init];
    address.label = @"Home";
    address.country = @"Germany";
    address.city = @"Berlin";
    address.zip = @"12345";
    address.street = @"Ilsenhof 123";
    address.state = @"Berlin";
    contact.addresses = @[address];
    
    ADAddressBookConverter *converter = [[ADAddressBookConverter alloc] init];
    ADAddressBookFieldMask *fieldMask = [[ADAddressBookFieldMask alloc] initWithFieldMask:ADContactFieldAll];
    ABRecordRef person = [converter newAddressBookFrameworkContactFromContact:contact fieldMask:fieldMask];
    
    XCTAssertTrue([(__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty) isEqualToString:@"Petr"]);
    XCTAssertTrue([(__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty) isEqualToString:@"Ivanov"]);
    XCTAssertTrue([(__bridge NSString *)ABRecordCopyValue(person, kABPersonOrganizationProperty) isEqualToString:@"Pieoneers"]);
    XCTAssertTrue([(__bridge NSString *)ABRecordCopyValue(person, kABPersonJobTitleProperty) isEqualToString:@"iOS Developer"]);
    XCTAssertTrue([(__bridge NSDate *)ABRecordCopyValue(person, kABPersonBirthdayProperty) isEqualToDate:[NSDate dateWithTimeIntervalSince1970:0]]);
    
    ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
    CFIndex emailsCount = ABMultiValueGetCount(emails);
    for (int p = 0; p < emailsCount; p++) {
        XCTAssertTrue([(__bridge NSString *)ABMultiValueCopyValueAtIndex(emails, p) isEqualToString:contact.emails[p].value]);
        XCTAssertTrue([(__bridge NSString *)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(emails, p)) isEqualToString:contact.emails[p].label]);
    }
    CFRelease(emails);
    
    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex phonesCount = ABMultiValueGetCount(phones);
    for (int p = 0; p < phonesCount; p++) {
        XCTAssertTrue([(__bridge NSString *)ABMultiValueCopyValueAtIndex(phones, p) isEqualToString:contact.phones[p].value]);
        XCTAssertTrue([(__bridge NSString *)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phones, p)) isEqualToString:contact.phones[p].label]);
    }
    CFRelease(phones);
    
    ABMultiValueRef addresses = ABRecordCopyValue(person, kABPersonAddressProperty);
    CFIndex addressesCount = ABMultiValueGetCount(addresses);
    for (int p = 0; p < addressesCount; p++) {
        CFDictionaryRef dict = ABMultiValueCopyValueAtIndex(addresses, p);
        XCTAssertTrue([(__bridge NSString *)CFDictionaryGetValue(dict, kABPersonAddressCountryKey) isEqualToString:contact.addresses[p].country]);
        XCTAssertTrue([(__bridge NSString *)CFDictionaryGetValue(dict, kABPersonAddressCityKey) isEqualToString:contact.addresses[p].city]);
        XCTAssertTrue([(__bridge NSString *)CFDictionaryGetValue(dict, kABPersonAddressStateKey) isEqualToString:contact.addresses[p].state]);
        XCTAssertTrue([(__bridge NSString *)CFDictionaryGetValue(dict, kABPersonAddressZIPKey) isEqualToString:contact.addresses[p].zip]);
        XCTAssertTrue([(__bridge NSString *)CFDictionaryGetValue(dict, kABPersonAddressStreetKey) isEqualToString:contact.addresses[p].street]);
        XCTAssertTrue([(__bridge NSString *)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(addresses, p)) isEqualToString:contact.addresses[p].label]);
    }
    CFRelease(addresses);
}

- (void)testThatItShouldConvertFrameworkContactToContact {
    ABRecordRef newPerson = ABPersonCreate();
    ABRecordSetValue(newPerson, kABPersonFirstNameProperty, (__bridge CFTypeRef _Nullable)@"Ivan", nil);
    ABRecordSetValue(newPerson, kABPersonLastNameProperty, (__bridge CFTypeRef _Nullable)@"Petrov", nil);
    ABPersonSetImageData(newPerson, (__bridge CFDataRef)([@"photo" dataUsingEncoding:NSUTF8StringEncoding]), nil);
    ABRecordSetValue(newPerson, kABPersonOrganizationProperty, (__bridge CFTypeRef _Nullable)@"Pieoneers", nil);
    ABRecordSetValue(newPerson, kABPersonJobTitleProperty, (__bridge CFTypeRef _Nullable)@"iOS Developer", nil);
    ABRecordSetValue(newPerson, kABPersonBirthdayProperty, (__bridge CFTypeRef)([NSDate dateWithTimeIntervalSince1970:0]), nil);
    
    ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiEmail, (__bridge CFTypeRef)@"ivan.petrov@gmail.com", (__bridge CFTypeRef)@"Home", NULL);
    ABMultiValueAddValueAndLabel(multiEmail, (__bridge CFTypeRef)@"ivan.petrov@pieoners.com", (__bridge CFTypeRef)@"Work", NULL);
    ABRecordSetValue(newPerson, kABPersonEmailProperty, multiEmail, nil);
    
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)@"79036437373", (__bridge CFStringRef)@"Home", NULL);
    ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)@"79036437370", (__bridge CFStringRef)@"Work", NULL);
    ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone, nil);
    
    ABMultiValueRef multiAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    NSDictionary *values = @{(NSString *)kABPersonAddressStreetKey: (NSString *)@"Lenina street",
                             (NSString *)kABPersonAddressZIPKey: (NSString *)@"123456",
                             (NSString *)kABPersonAddressCityKey: (NSString *)@"New York",
                             (NSString *)kABPersonAddressStateKey: (NSString *)@"NY",
                             (NSString *)kABPersonAddressCountryKey: (NSString *)@"USA",
                            };
    ABMultiValueAddValueAndLabel(multiAddress, (__bridge CFDictionaryRef)values, (__bridge CFStringRef)@"Home", NULL);
    ABRecordSetValue(newPerson, kABPersonAddressProperty, multiAddress, NULL);
    CFRelease(multiAddress);
    
    ADAddressBookConverter *converter = [[ADAddressBookConverter alloc] init];
    ADAddressBookFieldMask *fieldMask = [[ADAddressBookFieldMask alloc] initWithFieldMask:ADContactFieldAll];
    ADContact *contact = [converter contactFromAddressBookFrameworkContact:newPerson fieldMask:fieldMask];
    
    XCTAssertTrue([contact.firstName isEqualToString:@"Ivan"]);
    XCTAssertTrue([contact.lastName isEqualToString:@"Petrov"]);
    XCTAssertTrue([contact.birthday isEqualToDate:[NSDate dateWithTimeIntervalSince1970:0]]);
    XCTAssertTrue([contact.organization isEqualToString:@"Pieoneers"]);
    XCTAssertTrue([contact.jobTitle isEqualToString:@"iOS Developer"]);
    XCTAssertTrue([contact.emails[0].value isEqualToString:@"ivan.petrov@gmail.com"]);
    XCTAssertTrue([contact.emails[0].label isEqualToString:@"Home"]);
    XCTAssertTrue([contact.emails[1].value isEqualToString:@"ivan.petrov@pieoners.com"]);
    XCTAssertTrue([contact.emails[1].label isEqualToString:@"Work"]);
    XCTAssertTrue([contact.phones[0].value isEqualToString:@"79036437373"]);
    XCTAssertTrue([contact.phones[0].label isEqualToString:@"Home"]);
    XCTAssertTrue([contact.phones[1].value isEqualToString:@"79036437370"]);
    XCTAssertTrue([contact.phones[1].label isEqualToString:@"Work"]);
    XCTAssertTrue([contact.addresses[0].country isEqualToString:@"USA"]);
    XCTAssertTrue([contact.addresses[0].city isEqualToString:@"New York"]);
    XCTAssertTrue([contact.addresses[0].state isEqualToString:@"NY"]);
    XCTAssertTrue([contact.addresses[0].zip isEqualToString:@"123456"]);
    XCTAssertTrue([contact.addresses[0].street isEqualToString:@"Lenina street"]);
}

#pragma GCC diagnostic pop
@end
