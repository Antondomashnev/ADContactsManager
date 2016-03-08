//
//  ADContactsManagerTests.m
//  Tactup
//
//  Created by Anton Domashnev on 2/14/16.
//  Copyright © 2016 Pieoneers. All rights reserved.
//

@import XCTest;
@import Contacts;

#import <OCMock/OCMock.h>

#import "ADContactsManager.h"
#import "ADAddressBookFrameworkManager.h"
#import "ADContactsFrameworkManager.h"

@interface ADContactsManagerTests : XCTestCase

@end

@implementation ADContactsManagerTests

- (void)testAvailableFrameworks {
    if (NSStringFromClass([CNContactStore class])) {
        NSArray<NSNumber *> *expectedAvailableContactsFrameworks = @[@(ADContactsManagerSystemFrameworkAddressBook), @(ADContactsManagerSystemFrameworkContacts)];
        XCTAssertTrue([[ADContactsManager availableContactsManagerSystemFrameworks] isEqualToArray:expectedAvailableContactsFrameworks]);
    }
    else{
        NSArray<NSNumber *> *expectedAvailableContactsFrameworks = @[@(ADContactsManagerSystemFrameworkAddressBook)];
        XCTAssertTrue([[ADContactsManager availableContactsManagerSystemFrameworks] isEqualToArray:expectedAvailableContactsFrameworks]);
    }
}

- (void)testThatSetPreferredContactsManagerSystemFrameworkShouldSetGivenFrameworkAsPreferredIfAvailable {
    NSArray<NSNumber *> *expectedAvailableContactsFrameworks = @[@(ADContactsManagerSystemFrameworkAddressBook), @(ADContactsManagerSystemFrameworkContacts)];
    
    id contactsManager = OCMClassMock([ADContactsManager class]);
    OCMStub([contactsManager availableContactsManagerSystemFrameworks]).andReturn(expectedAvailableContactsFrameworks);
    
    [ADContactsManager setPreferredContactsManagerSystemFramework:ADContactsManagerSystemFrameworkContacts];
    XCTAssertTrue([ADContactsManager preferredContactsManagerSystemFramework] == ADContactsManagerSystemFrameworkContacts);
    
    [ADContactsManager setPreferredContactsManagerSystemFramework:ADContactsManagerSystemFrameworkAddressBook];
    XCTAssertTrue([ADContactsManager preferredContactsManagerSystemFramework] == ADContactsManagerSystemFrameworkAddressBook);
}

- (void)testThatSetPreferredContactsManagerSystemFrameworkShouldSetDefaultFrameworkAsPreferredIfGivenNotAvailable {
    NSArray<NSNumber *> *expectedAvailableContactsFrameworks = @[@(ADContactsManagerSystemFrameworkAddressBook)];
    
    id contactsManager = OCMClassMock([ADContactsManager class]);
    OCMStub([contactsManager availableContactsManagerSystemFrameworks]).andReturn(expectedAvailableContactsFrameworks);
    
    [ADContactsManager setPreferredContactsManagerSystemFramework:ADContactsManagerSystemFrameworkContacts];
    XCTAssertTrue([ADContactsManager preferredContactsManagerSystemFramework] == ADContactsManagerSystemFrameworkAddressBook);
    
    [ADContactsManager setPreferredContactsManagerSystemFramework:ADContactsManagerSystemFrameworkAddressBook];
    XCTAssertTrue([ADContactsManager preferredContactsManagerSystemFramework] == ADContactsManagerSystemFrameworkAddressBook);
}

- (void)testThatContactsManagerIfPrefferedFrameworkIsAddressBookShouldReturnInstanceOfAddressBookFrameworkManager {
    NSArray<NSNumber *> *expectedAvailableContactsFrameworks = @[@(ADContactsManagerSystemFrameworkAddressBook), @(ADContactsManagerSystemFrameworkContacts)];
    
    id contactsManager = OCMClassMock([ADContactsManager class]);
    OCMStub([contactsManager availableContactsManagerSystemFrameworks]).andReturn(expectedAvailableContactsFrameworks);
    
    [ADContactsManager setPreferredContactsManagerSystemFramework:ADContactsManagerSystemFrameworkAddressBook];
    XCTAssertTrue([[ADContactsManager contactsManager] isKindOfClass:[ADAddressBookFrameworkManager class]]);
}

- (void)testThatContactsManagerIfPrefferedFrameworkIsContactsShouldReturnInstanceOfContactsFrameworkManager {
    if (!NSStringFromClass([CNContactStore class])) {
        return;
    }
    
    NSArray<NSNumber *> *expectedAvailableContactsFrameworks = @[@(ADContactsManagerSystemFrameworkAddressBook), @(ADContactsManagerSystemFrameworkContacts)];
    
    id contactsManager = OCMClassMock([ADContactsManager class]);
    OCMStub([contactsManager availableContactsManagerSystemFrameworks]).andReturn(expectedAvailableContactsFrameworks);
    
    [ADContactsManager setPreferredContactsManagerSystemFramework:ADContactsManagerSystemFrameworkContacts];
    XCTAssertTrue([[ADContactsManager contactsManager] isKindOfClass:[ADContactsFrameworkManager class]]);
}

@end
