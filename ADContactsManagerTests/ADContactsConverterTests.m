//
//  ADContactsConverterTests.m
//  Tactup
//
//  Created by Anton Domashnev on 10/10/15.
//  Copyright © 2015 Pieoneers. All rights reserved.
//

@import XCTest;
@import Contacts;

#import "ADContact.h"
#import "ADContactEmail.h"
#import "ADContactPhone.h"
#import "ADContactAddress.h"
#import "ADContactsConverter.h"

@interface ADContactsConverterTests : XCTestCase

@end

@implementation ADContactsConverterTests

- (void)testContactToFrameworkContactConversion {
    ADContact *contact = [[ADContact alloc] init];
    contact.firstName = @"Petr";
    contact.middleName = @"Ivanovich";
    contact.fullSizePhotoImageData = [@"yayay" dataUsingEncoding:NSUTF8StringEncoding];
    contact.lastName = @"Ivanov";
    contact.organization = @"Pieoneers";
    contact.jobTitle = @"iOS Developer";
    contact.birthday = [NSDate dateWithTimeIntervalSince1970:0];
    
    ADContactPhone *phone1 = [[ADContactPhone alloc] init];
    phone1.value = @"+1-202-555-0199";
    phone1.label = @"Home";
    ADContactPhone *phone2 = [[ADContactPhone alloc] init];
    phone2.value = @"+1-202-555-0195";
    phone2.label = @"Work";
    contact.phones = @[phone1, phone2];
    
    ADContactEmail *email1 = [[ADContactEmail alloc] init];
    email1.value = @"john.piterson@gmail.com";
    email1.label = @"Home";
    ADContactEmail *email2 = [[ADContactEmail alloc] init];
    email2.value = @"john.p@pieoneers.com";
    email2.label = @"Work";
    contact.emails = @[email1, email2];
    
    ADContactAddress *address = [[ADContactAddress alloc] init];
    address.street = @"1600 West Antelope Drive";
    address.zip = @"84041";
    address.city = @"Layton";
    address.state = @"UT";
    address.country = @"USA";
    address.label = @"Home";
    contact.addresses = @[address];
    
    ADContactsConverter *converter = [[ADContactsConverter alloc] init];
    CNContact *frameworkContact = [converter frameworkContactFromContact:contact];
    
    XCTAssertTrue([frameworkContact.givenName isEqualToString:@"Petr"]);
    XCTAssertTrue([frameworkContact.familyName isEqualToString:@"Ivanov"]);
    XCTAssertTrue([frameworkContact.middleName isEqualToString:@"Ivanovich"]);
    XCTAssertTrue([frameworkContact.organizationName isEqualToString:@"Pieoneers"]);
    XCTAssertTrue([frameworkContact.jobTitle isEqualToString:@"iOS Developer"]);
    XCTAssertTrue(frameworkContact.birthday.year == 1970);
    XCTAssertTrue(frameworkContact.birthday.month == 1);
    XCTAssertTrue(frameworkContact.birthday.day == 1);
    XCTAssertTrue([frameworkContact.imageData isEqualToData:[@"yayay" dataUsingEncoding:NSUTF8StringEncoding]]);
    
    CNLabeledValue<CNPhoneNumber *> *frameworkPhone1 = frameworkContact.phoneNumbers[0];
    XCTAssertTrue([frameworkPhone1.label isEqualToString:@"Home"]);
    XCTAssertTrue([frameworkPhone1.value.stringValue isEqualToString:@"+1-202-555-0199"]);
    CNLabeledValue<CNPhoneNumber *> *frameworkPhone2 = frameworkContact.phoneNumbers[1];
    XCTAssertTrue([frameworkPhone2.label isEqualToString:@"Work"]);
    XCTAssertTrue([frameworkPhone2.value.stringValue isEqualToString:@"+1-202-555-0195"]);
    
    CNLabeledValue<NSString *> *frameworkEmail1 = frameworkContact.emailAddresses[0];
    XCTAssertTrue([frameworkEmail1.label isEqualToString:@"Home"]);
    XCTAssertTrue([frameworkEmail1.value isEqualToString:@"john.piterson@gmail.com"]);
    CNLabeledValue<NSString *> *frameworkEmail2 = frameworkContact.emailAddresses[1];
    XCTAssertTrue([frameworkEmail2.label isEqualToString:@"Work"]);
    XCTAssertTrue([frameworkEmail2.value isEqualToString:@"john.p@pieoneers.com"]);
    
    CNLabeledValue<CNPostalAddress *> *frameworkAddress = frameworkContact.postalAddresses[0];
    XCTAssertTrue([frameworkAddress.label isEqualToString:@"Home"]);
    XCTAssertTrue([frameworkAddress.value.country isEqualToString:@"USA"]);
    XCTAssertTrue([frameworkAddress.value.city isEqualToString:@"Layton"]);
    XCTAssertTrue([frameworkAddress.value.state isEqualToString:@"UT"]);
    XCTAssertTrue([frameworkAddress.value.postalCode isEqualToString:@"84041"]);
    XCTAssertTrue([frameworkAddress.value.street isEqualToString:@"1600 West Antelope Drive"]);
}

- (void)testFrameworkContactToContactConversion {
    CNMutableContact *frameworkContact = [CNMutableContact new];
    frameworkContact.givenName = @"Petr";
    frameworkContact.familyName = @"Ivanov";
    frameworkContact.organizationName = @"Pieoneers";
    frameworkContact.jobTitle = @"iOS Developer";
    
    NSDateComponents *components = [NSDateComponents new];
    components.day = 1;
    components.month = 1;
    components.year = 1970;
    components.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    frameworkContact.birthday = components;
    
    CNPhoneNumber *frameworkPhone1 = [CNPhoneNumber phoneNumberWithStringValue:@"+1-202-555-0199"];
    CNLabeledValue<CNPhoneNumber *> *value1 = [[CNLabeledValue alloc] initWithLabel:@"Home" value:frameworkPhone1];
    CNPhoneNumber *frameworkPhone2 = [CNPhoneNumber phoneNumberWithStringValue:@"+1-202-555-0195"];
    CNLabeledValue<CNPhoneNumber *> *value2 = [[CNLabeledValue alloc] initWithLabel:@"Work" value:frameworkPhone2];
    frameworkContact.phoneNumbers = @[value1, value2];
    
    CNLabeledValue<NSString *> *frameworkEmail1 = [[CNLabeledValue alloc] initWithLabel:@"Home" value:@"john.piterson@gmail.com"];
    CNLabeledValue<NSString *> *frameworkEmail2 = [[CNLabeledValue alloc] initWithLabel:@"Work" value:@"john.p@pieoneers.com"];
    frameworkContact.emailAddresses = @[frameworkEmail1, frameworkEmail2];
    
    CNMutablePostalAddress *frameworkAddress = [[CNMutablePostalAddress alloc] init];
    frameworkAddress.country = @"USA";
    frameworkAddress.city = @"Layton";
    frameworkAddress.state = @"UT";
    frameworkAddress.postalCode = @"84041";
    frameworkAddress.street = @"1600 West Antelope Drive";
    CNLabeledValue<CNPostalAddress *> *value3 = [[CNLabeledValue alloc] initWithLabel:@"Home" value:frameworkAddress];
    frameworkContact.postalAddresses = @[value3];
    
    ADContactsConverter *converter = [[ADContactsConverter alloc] init];
    ADContact *contact = [converter contactFromFrameworkContact:frameworkContact];
    
    XCTAssertTrue([contact.firstName isEqualToString:@"Petr"]);
    XCTAssertTrue([contact.lastName isEqualToString:@"Ivanov"]);
    XCTAssertTrue([contact.organization isEqualToString:@"Pieoneers"]);
    XCTAssertTrue([contact.jobTitle isEqualToString:@"iOS Developer"]);
    XCTAssertTrue([contact.birthday isEqualToDate:[NSDate dateWithTimeIntervalSince1970:0]]);
    
    ADContactPhone *phone1 = contact.phones[0];
    XCTAssertTrue([phone1.label isEqualToString:@"Home"]);
    XCTAssertTrue([phone1.value isEqualToString:@"+1-202-555-0199"]);
    ADContactPhone *phone2 = contact.phones[1];
    XCTAssertTrue([phone2.label isEqualToString:@"Work"]);
    XCTAssertTrue([phone2.value isEqualToString:@"+1-202-555-0195"]);
    
    ADContactEmail *email1 = contact.emails[0];
    XCTAssertTrue([email1.label isEqualToString:@"Home"]);
    XCTAssertTrue([email1.value isEqualToString:@"john.piterson@gmail.com"]);
    ADContactEmail *email2 = contact.emails[1];
    XCTAssertTrue([email2.label isEqualToString:@"Work"]);
    XCTAssertTrue([email2.value isEqualToString:@"john.p@pieoneers.com"]);
    
    ADContactAddress *address = contact.addresses[0];
    XCTAssertTrue([address.label isEqualToString:@"Home"]);
    XCTAssertTrue([address.country isEqualToString:@"USA"]);
    XCTAssertTrue([address.city isEqualToString:@"Layton"]);
    XCTAssertTrue([address.state isEqualToString:@"UT"]);
    XCTAssertTrue([address.zip isEqualToString:@"84041"]);
    XCTAssertTrue([address.street isEqualToString:@"1600 West Antelope Drive"]);
}

- (void)testThatUpdatedFrameworkContactShouldReturnUpdateFrameworkContact {
    ADContactsConverter *converter = [[ADContactsConverter alloc] init];
    
    CNMutableContact *frameworkContactToUpdate = [CNMutableContact new];
    frameworkContactToUpdate.givenName = @"Petr";
    frameworkContactToUpdate.familyName = @"Ivanov";
    frameworkContactToUpdate.organizationName = @"Pieoneers";
    frameworkContactToUpdate.jobTitle = @"iOS Developer";
    
    NSDateComponents *components = [NSDateComponents new];
    components.day = 1;
    components.month = 1;
    components.year = 1970;
    components.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    frameworkContactToUpdate.birthday = components;
    
    CNPhoneNumber *frameworkPhone1 = [CNPhoneNumber phoneNumberWithStringValue:@"+1-202-555-0199"];
    CNLabeledValue<CNPhoneNumber *> *value1 = [[CNLabeledValue alloc] initWithLabel:@"Home" value:frameworkPhone1];
    CNPhoneNumber *frameworkPhone2 = [CNPhoneNumber phoneNumberWithStringValue:@"+1-202-555-0195"];
    CNLabeledValue<CNPhoneNumber *> *value2 = [[CNLabeledValue alloc] initWithLabel:@"Work" value:frameworkPhone2];
    frameworkContactToUpdate.phoneNumbers = @[value1, value2];
    
    CNLabeledValue<NSString *> *frameworkEmail1 = [[CNLabeledValue alloc] initWithLabel:@"Home" value:@"john.piterson@gmail.com"];
    CNLabeledValue<NSString *> *frameworkEmail2 = [[CNLabeledValue alloc] initWithLabel:@"Work" value:@"john.p@pieoneers.com"];
    frameworkContactToUpdate.emailAddresses = @[frameworkEmail1, frameworkEmail2];
    
    CNMutablePostalAddress *frameworkAddress = [[CNMutablePostalAddress alloc] init];
    frameworkAddress.country = @"USA";
    frameworkAddress.city = @"Layton";
    frameworkAddress.state = @"UT";
    frameworkAddress.postalCode = @"84041";
    frameworkAddress.street = @"1600 West Antelope Drive";
    CNLabeledValue<CNPostalAddress *> *value3 = [[CNLabeledValue alloc] initWithLabel:@"Home" value:frameworkAddress];
    frameworkContactToUpdate.postalAddresses = @[value3];
    
    ADContact *contact = [ADContact new];
    contact.firstName = @"Ivan";
    contact.lastName = @"Ivanov";
    contact.birthday = [NSDate dateWithTimeIntervalSince1970:0];
    
    ADContactPhone *phone2 = [ADContactPhone new];
    phone2.label = @"Work";
    phone2.value = @"+1-202-555-0195";
    contact.phones = @[phone2];
    
    ADContactEmail *email1 = [ADContactEmail new];
    email1.label = @"Home";
    email1.value = @"john.piterson@gmail.com";
    ADContactEmail *email2 = [ADContactEmail new];
    email2.label = @"Home";
    email2.value = @"ivan.ivanov@pieoneers.com";
    contact.emails = @[email1, email2];
    
    CNMutableContact *updatedframeworkContact = [converter updatedFrameworkContact:[frameworkContactToUpdate copy] fromContact:contact];
    
    XCTAssertTrue([updatedframeworkContact.givenName isEqualToString:@"Ivan"]);
    XCTAssertTrue([updatedframeworkContact.familyName isEqualToString:@"Ivanov"]);
    XCTAssertTrue([updatedframeworkContact.middleName isEqualToString:@""]);
    XCTAssertTrue([updatedframeworkContact.organizationName isEqualToString:@""]);
    XCTAssertTrue([updatedframeworkContact.jobTitle isEqualToString:@""]);
    XCTAssertTrue(updatedframeworkContact.birthday.year == 1970);
    XCTAssertTrue(updatedframeworkContact.birthday.month == 1);
    XCTAssertTrue(updatedframeworkContact.birthday.day == 1);
    
    CNLabeledValue<CNPhoneNumber *> *updatedFrameworkPhone1 = updatedframeworkContact.phoneNumbers[0];
    XCTAssertTrue([updatedFrameworkPhone1.label isEqualToString:@"Work"]);
    XCTAssertTrue([updatedFrameworkPhone1.value.stringValue isEqualToString:@"+1-202-555-0195"]);
    
    CNLabeledValue<NSString *> *updatedFrameworkEmail1 = updatedframeworkContact.emailAddresses[0];
    XCTAssertTrue([updatedFrameworkEmail1.label isEqualToString:@"Home"]);
    XCTAssertTrue([updatedFrameworkEmail1.value isEqualToString:@"john.piterson@gmail.com"]);
    CNLabeledValue<NSString *> *updatedFrameworkEmail2 = updatedframeworkContact.emailAddresses[1];
    XCTAssertTrue([updatedFrameworkEmail2.label isEqualToString:@"Home"]);
    XCTAssertTrue([updatedFrameworkEmail2.value isEqualToString:@"ivan.ivanov@pieoneers.com"]);
    
    XCTAssertTrue([updatedframeworkContact.postalAddresses count] == 0);
}

@end
