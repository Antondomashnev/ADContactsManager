//
//  ADContactsFieldMaskTests.m
//  Tactup
//
//  Created by Anton Domashnev on 10/10/15.
//  Copyright © 2015 Pieoneers. All rights reserved.
//

@import XCTest;
@import Contacts;

#import "ADContactsFieldMask.h"

@interface ADContactsFieldMaskTests : XCTestCase

@end

@implementation ADContactsFieldMaskTests

- (void)testThatItShouldReturnCorrectMask {
    ADContactsFieldMask *mask1 = [[ADContactsFieldMask alloc] initWithFields:(ADContactField)(ADContactFieldFirstName | ADContactFieldLastName)];
    NSArray<NSString *> *expectedFields1 = @[CNContactGivenNameKey, CNContactFamilyNameKey];
    XCTAssertTrue([mask1.fieldsArray isEqualToArray:expectedFields1]);
    
    ADContactsFieldMask *mask2 = [[ADContactsFieldMask alloc] initWithFields:(ADContactField)(ADContactFieldPhones | ADContactFieldEmails | ADContactFieldAddresses)];
    NSArray<NSString *> *expectedFields2 = @[CNContactPhoneNumbersKey, CNContactEmailAddressesKey, CNContactPostalAddressesKey];
    XCTAssertTrue([mask2.fieldsArray isEqualToArray:expectedFields2]);
    
    ADContactsFieldMask *mask3 = [[ADContactsFieldMask alloc] initWithFields:ADContactFieldAll];
    NSArray<NSString *> *expectedFields3 = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactMiddleNameKey, CNContactOrganizationNameKey, CNContactJobTitleKey, CNContactThumbnailImageDataKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey, CNContactPostalAddressesKey, CNContactSocialProfilesKey, CNContactBirthdayKey, CNContactUrlAddressesKey, CNContactNoteKey, CNContactRelationsKey, CNContactDatesKey, CNContactImageDataKey];
    XCTAssertTrue([mask3.fieldsArray isEqualToArray:expectedFields3]);
}

@end
