//
//  ADContactsFrameworkManagerTests.m
//  Tactup
//
//  Created by Anton Domashnev on 10/10/15.
//  Copyright © 2015 Pieoneers. All rights reserved.
//

@import XCTest;
@import Contacts;

#import <OCMock/OCMock.h>

#import "ADContactsFrameworkManager.h"
#import "ADContactsConverter.h"
#import "ADContact.h"

@interface ADContactsFrameworkManager ()

@property (nonatomic, strong) ADContactsConverter *converter;

@end

@interface ADContactsFrameworkManagerTests : XCTestCase

@end

@implementation ADContactsFrameworkManagerTests

- (void)testAccessStatus {
    id contactStore1 = OCMClassMock([CNContactStore class]);
    OCMStub([contactStore1 authorizationStatusForEntityType:CNEntityTypeContacts]).andReturn(CNAuthorizationStatusRestricted);
    ADContactsFrameworkManager *manager1 = [[ADContactsFrameworkManager alloc] initWithSystemContactsStore:contactStore1];
    XCTAssertTrue([manager1 accessStatus] == ADContactsManagerAccessStatusRestricted);
    
    id contactStore2 = OCMClassMock([CNContactStore class]);
    OCMStub([contactStore2 authorizationStatusForEntityType:CNEntityTypeContacts]).andReturn(CNAuthorizationStatusDenied);
    ADContactsFrameworkManager *manager2 = [[ADContactsFrameworkManager alloc] initWithSystemContactsStore:contactStore2];
    XCTAssertTrue([manager2 accessStatus] == ADContactsManagerAccessStatusDenied);
    
    id contactStore3 = OCMClassMock([CNContactStore class]);
    OCMStub([contactStore3 authorizationStatusForEntityType:CNEntityTypeContacts]).andReturn(CNAuthorizationStatusNotDetermined);
    ADContactsFrameworkManager *manager3 = [[ADContactsFrameworkManager alloc] initWithSystemContactsStore:contactStore3];
    XCTAssertTrue([manager3 accessStatus] == ADContactsManagerAccessStatusNotDetermined);
    
    id contactStore4 = OCMClassMock([CNContactStore class]);
    OCMStub([contactStore4 authorizationStatusForEntityType:CNEntityTypeContacts]).andReturn(CNAuthorizationStatusAuthorized);
    ADContactsFrameworkManager *manager4 = [[ADContactsFrameworkManager alloc] initWithSystemContactsStore:contactStore4];
    XCTAssertTrue([manager4 accessStatus] == ADContactsManagerAccessStatusAuthorized);
}

- (void)testThatItShouldReturnErrorOnRequestAccessIfStatusIsDenied {
    id contactStore = OCMClassMock([CNContactStore class]);
    OCMStub([contactStore authorizationStatusForEntityType:CNEntityTypeContacts]).andReturn(CNAuthorizationStatusDenied);
    ADContactsFrameworkManager *manager = [[ADContactsFrameworkManager alloc] initWithSystemContactsStore:contactStore];
    [manager requestAccessWithCallback:^(ADContactsManagerAccessStatus status, NSError * _Nullable error) {
        XCTAssertTrue(status == ADContactsManagerAccessStatusDenied);
        XCTAssertNotNil(error);
    }];
}

- (void)testThatItShouldReturnErrorOnRequestAccessIfStatusIsRestricted {
    id contactStore = OCMClassMock([CNContactStore class]);
    OCMStub([contactStore authorizationStatusForEntityType:CNEntityTypeContacts]).andReturn(CNAuthorizationStatusRestricted);
    ADContactsFrameworkManager *manager = [[ADContactsFrameworkManager alloc] initWithSystemContactsStore:contactStore];
    [manager requestAccessWithCallback:^(ADContactsManagerAccessStatus status, NSError * _Nullable error) {
        XCTAssertTrue(status == ADContactsManagerAccessStatusRestricted);
        XCTAssertNotNil(error);
    }];
}

- (void)testThatItShouldReturnStatusAuthorizedIfAlreadyAuthorized {
    id contactStore = OCMClassMock([CNContactStore class]);
    OCMStub([contactStore authorizationStatusForEntityType:CNEntityTypeContacts]).andReturn(CNAuthorizationStatusAuthorized);
    ADContactsFrameworkManager *manager = [[ADContactsFrameworkManager alloc] initWithSystemContactsStore:contactStore];
    [manager requestAccessWithCallback:^(ADContactsManagerAccessStatus status, NSError * _Nullable error) {
        XCTAssertTrue(status == ADContactsManagerAccessStatusAuthorized);
        XCTAssertNil(error);
    }];
}

- (void)testThatItShouldRequestAccessFromContactStoreIfStatusIsNotDetermined {
    id contactStore = OCMClassMock([CNContactStore class]);
    OCMStub([contactStore authorizationStatusForEntityType:CNEntityTypeContacts]).andReturn(CNAuthorizationStatusNotDetermined);
    OCMExpect([contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:OCMOCK_ANY]);
    
    ADContactsFrameworkManager *manager = [[ADContactsFrameworkManager alloc] initWithSystemContactsStore:contactStore];
    [manager requestAccessWithCallback:OCMOCK_ANY];
    
    OCMVerifyAll(contactStore);
}

- (void)testThatItShouldReturnErrorIfAddContactToRestrictedContactStore {
    id contactStore = OCMClassMock([CNContactStore class]);
    OCMStub([contactStore authorizationStatusForEntityType:CNEntityTypeContacts]).andReturn(CNAuthorizationStatusRestricted);
    
    id contact = OCMClassMock([ADContact class]);
    
    ADContactsFrameworkManager *manager = [[ADContactsFrameworkManager alloc] initWithSystemContactsStore:contactStore];
    [manager addContact:contact withCallback:^(ADContact * _Nullable contact, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertNil(contact);
    }];
}

- (void)testThatItShouldReturnErrorIfAddContactToDeniedContactStore {
    id contactStore = OCMClassMock([CNContactStore class]);
    OCMStub([contactStore authorizationStatusForEntityType:CNEntityTypeContacts]).andReturn(CNAuthorizationStatusDenied);
    
    id contact = OCMClassMock([ADContact class]);
    
    ADContactsFrameworkManager *manager = [[ADContactsFrameworkManager alloc] initWithSystemContactsStore:contactStore];
    [manager addContact:contact withCallback:^(ADContact * _Nullable contact, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertNil(contact);
    }];
}

- (void)testThatItShouldReturnErrorIfAddContactToNotAuthorizedContactStore {
    id contactStore = OCMClassMock([CNContactStore class]);
    OCMStub([contactStore authorizationStatusForEntityType:CNEntityTypeContacts]).andReturn(CNAuthorizationStatusNotDetermined);
    
    id contact = OCMClassMock([ADContact class]);
    
    ADContactsFrameworkManager *manager = [[ADContactsFrameworkManager alloc] initWithSystemContactsStore:contactStore];
    [manager addContact:contact withCallback:^(ADContact * _Nullable contact, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertNil(contact);
    }];
}

- (void)testThatItShouldSaveAndReturnContactIfContactStoreIsAuthorized {
    id contactStore = OCMClassMock([CNContactStore class]);
    OCMStub([contactStore authorizationStatusForEntityType:CNEntityTypeContacts]).andReturn(CNAuthorizationStatusAuthorized);
    OCMStub([contactStore executeSaveRequest:OCMOCK_ANY error:[OCMArg anyObjectRef]]).andReturn(YES);
    
    id contact = OCMClassMock([ADContact class]);
    
    ADContactsFrameworkManager *manager = [[ADContactsFrameworkManager alloc] initWithSystemContactsStore:contactStore];
    [manager addContact:contact withCallback:^(ADContact * _Nullable contact, NSError * _Nullable error) {
        XCTAssertNotNil(contact);
        XCTAssertNil(error);
    }];
}

- (void)testThatItShouldReturnErrorIfDeleteContactFromRestrictedContactStore {
    id contactStore = OCMClassMock([CNContactStore class]);
    OCMStub([contactStore authorizationStatusForEntityType:CNEntityTypeContacts]).andReturn(CNAuthorizationStatusRestricted);
    
    id contact = OCMClassMock([ADContact class]);
    
    ADContactsFrameworkManager *manager = [[ADContactsFrameworkManager alloc] initWithSystemContactsStore:contactStore];
    [manager deleteContact:contact withCallback:^(BOOL result, NSError * _Nullable error) {
        XCTAssertFalse(result);
        XCTAssertNotNil(error);
    }];
}

- (void)testThatItShouldReturnErrorIfDeleteContactFromDeniedContactStore {
    id contactStore = OCMClassMock([CNContactStore class]);
    OCMStub([contactStore authorizationStatusForEntityType:CNEntityTypeContacts]).andReturn(CNAuthorizationStatusDenied);
    
    id contact = OCMClassMock([ADContact class]);
    
    ADContactsFrameworkManager *manager = [[ADContactsFrameworkManager alloc] initWithSystemContactsStore:contactStore];
    [manager deleteContact:contact withCallback:^(BOOL result, NSError * _Nullable error) {
        XCTAssertFalse(result);
        XCTAssertNotNil(error);
    }];
}

- (void)testThatItShouldReturnErrorIfDeleteContactFromNotAuthorizedContactStore {
    id contactStore = OCMClassMock([CNContactStore class]);
    OCMStub([contactStore authorizationStatusForEntityType:CNEntityTypeContacts]).andReturn(CNAuthorizationStatusNotDetermined);
    
    id contact = OCMClassMock([ADContact class]);
    
    ADContactsFrameworkManager *manager = [[ADContactsFrameworkManager alloc] initWithSystemContactsStore:contactStore];
    [manager deleteContact:contact withCallback:^(BOOL result, NSError * _Nullable error) {
        XCTAssertFalse(result);
        XCTAssertNotNil(error);
    }];
}

- (void)testThatItShouldReturnErrorOnGetContactsFromRestrictedStore {
    id contactStore = OCMClassMock([CNContactStore class]);
    OCMStub([contactStore authorizationStatusForEntityType:CNEntityTypeContacts]).andReturn(CNAuthorizationStatusRestricted);
    
    ADContactsFrameworkManager *manager = [[ADContactsFrameworkManager alloc] initWithSystemContactsStore:contactStore];
    [manager getContactsWithCallback:^(NSArray<ADContact *> * _Nullable contactsArray, NSError * _Nullable error) {
        XCTAssertNil(contactsArray);
        XCTAssertNotNil(error);
    }];
}

- (void)testThatItShouldReturnErrorOnGetContactsFromDeniedStore {
    id contactStore = OCMClassMock([CNContactStore class]);
    OCMStub([contactStore authorizationStatusForEntityType:CNEntityTypeContacts]).andReturn(CNAuthorizationStatusDenied);
    
    ADContactsFrameworkManager *manager = [[ADContactsFrameworkManager alloc] initWithSystemContactsStore:contactStore];
    [manager getContactsWithCallback:^(NSArray<ADContact *> * _Nullable contactsArray, NSError * _Nullable error) {
        XCTAssertNil(contactsArray);
        XCTAssertNotNil(error);
    }];
}

- (void)testThatItShouldReturnErrorOnGetContactsFromNotAuthorizedStore {
    id contactStore = OCMClassMock([CNContactStore class]);
    OCMStub([contactStore authorizationStatusForEntityType:CNEntityTypeContacts]).andReturn(CNAuthorizationStatusNotDetermined);
    
    ADContactsFrameworkManager *manager = [[ADContactsFrameworkManager alloc] initWithSystemContactsStore:contactStore];
    [manager getContactsWithCallback:^(NSArray<ADContact *> * _Nullable contactsArray, NSError * _Nullable error) {
        XCTAssertNil(contactsArray);
        XCTAssertNotNil(error);
    }];
}

- (void)testThatItShouldReturnContactsOnGetContactsFromAuthorizedStore {
    id contactStore = OCMClassMock([CNContactStore class]);
    id frameworkContact = OCMClassMock([CNContact class]);
    OCMStub([contactStore authorizationStatusForEntityType:CNEntityTypeContacts]).andReturn(CNAuthorizationStatusAuthorized);
    OCMStub([contactStore enumerateContactsWithFetchRequest:OCMOCK_ANY error:[OCMArg anyObjectRef] usingBlock:OCMOCK_ANY]).andDo(^(NSInvocation *invocation){
        void(^block)(CNContact *contact, BOOL *stop) = nil;
        [invocation getArgument:&block atIndex:4];
        block(frameworkContact, [OCMArg anyPointer]);
    });
    
    id contact = OCMClassMock([ADContact class]);
    id converter = OCMClassMock([ADContactsConverter class]);
    OCMStub([converter contactFromFrameworkContact:OCMOCK_ANY]).andReturn(contact);
    
    NSArray *expectedArray = @[contact];
    
    ADContactsFrameworkManager *manager = [[ADContactsFrameworkManager alloc] initWithSystemContactsStore:contactStore];
    manager.converter = converter;
    [manager getContactsWithCallback:^(NSArray<ADContact *> * _Nullable contactsArray, NSError * _Nullable error) {
        XCTAssertTrue([contactsArray isEqualToArray:expectedArray]);
        XCTAssertNil(error);
    }];
}

- (void)testThatUpdateContactShouldReturnErrorIfContactStoreIsNotAuthorized {
    id contactStore = OCMClassMock([CNContactStore class]);
    OCMStub([contactStore authorizationStatusForEntityType:CNEntityTypeContacts]).andReturn(CNAuthorizationStatusDenied);
    
    ADContactsFrameworkManager *manager = [[ADContactsFrameworkManager alloc] initWithSystemContactsStore:contactStore];
    [manager updateContact:[ADContact new] withCallback:^(ADContact * _Nullable contact, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertNil(contact);
    }];
}

- (void)testThatUpdateContactShouldReturnErrorIfContactStoreAccessNotDetermined {
    id contactStore = OCMClassMock([CNContactStore class]);
    OCMStub([contactStore authorizationStatusForEntityType:CNEntityTypeContacts]).andReturn(CNAuthorizationStatusNotDetermined);
    
    ADContactsFrameworkManager *manager = [[ADContactsFrameworkManager alloc] initWithSystemContactsStore:contactStore];
    [manager updateContact:[ADContact new] withCallback:^(ADContact * _Nullable contact, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertNil(contact);
    }];
}

- (void)testThatUpdateContactShouldReturnErrorIfContactStoreAccessRestricted {
    id contactStore = OCMClassMock([CNContactStore class]);
    OCMStub([contactStore authorizationStatusForEntityType:CNEntityTypeContacts]).andReturn(CNAuthorizationStatusRestricted);
    
    ADContactsFrameworkManager *manager = [[ADContactsFrameworkManager alloc] initWithSystemContactsStore:contactStore];
    [manager updateContact:[ADContact new] withCallback:^(ADContact * _Nullable contact, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertNil(contact);
    }];
}

- (void)testThatUpdateContactShouldReturnErrorIfContactToUpdateDoesNotHaveIdentifier {
    id contactStore = OCMClassMock([CNContactStore class]);
    OCMStub([contactStore authorizationStatusForEntityType:CNEntityTypeContacts]).andReturn(CNAuthorizationStatusAuthorized);
    
    ADContact *contact = [[ADContact alloc] init];
    
    ADContactsFrameworkManager *manager = [[ADContactsFrameworkManager alloc] initWithSystemContactsStore:contactStore];
    [manager updateContact:contact withCallback:^(ADContact * _Nullable contact, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertNil(contact);
    }];
}

- (void)testThatUpdateContactShouldReturnContactIfSucceeded {
    id contactStore = OCMClassMock([CNContactStore class]);
    OCMStub([contactStore authorizationStatusForEntityType:CNEntityTypeContacts]).andReturn(CNAuthorizationStatusAuthorized);
    
    BOOL *boolRef = NULL;
    id frameworkContact = OCMPartialMock([CNContact new]);
    OCMStub([frameworkContact identifier]).andReturn(@"11223344556677889900");
    OCMStub([contactStore enumerateContactsWithFetchRequest:OCMOCK_ANY error:[OCMArg anyObjectRef] usingBlock:OCMOCK_ANY]).andDo(^(NSInvocation *invocation){
        void(^block)(CNContact *contact, BOOL *stop) = nil;
        [invocation getArgument:&block atIndex:4];
        block(frameworkContact, boolRef);
    });
    
    CNSaveRequest *request = [CNSaveRequest new];
    CNMutableContact *updatedContact = [frameworkContact mutableCopy];
    [request updateContact:updatedContact];
    OCMStub([contactStore executeSaveRequest:OCMOCK_ANY error:[OCMArg anyObjectRef]]).andReturn(YES);
    
    ADContact *contact = [[ADContact alloc] init];
    contact.contactID = @"11223344556677889900";
    
    ADContactsFrameworkManager *manager = [[ADContactsFrameworkManager alloc] initWithSystemContactsStore:contactStore];
    [manager updateContact:contact withCallback:^(ADContact * _Nullable contact, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(contact);
    }];
}

- (void)testThatGetContactsCountShouldReturnErrorIfContactStoreIsNotAuthorized {
    id contactStore = OCMClassMock([CNContactStore class]);
    OCMStub([contactStore authorizationStatusForEntityType:CNEntityTypeContacts]).andReturn(CNAuthorizationStatusDenied);
    
    ADContactsFrameworkManager *manager = [[ADContactsFrameworkManager alloc] initWithSystemContactsStore:contactStore];
    [manager getContactsCountWithCallback:^(NSUInteger contactsCount, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertTrue(contactsCount == 0);
    }];
}

- (void)testThatGetContactsCountShouldReturnErrorIfContactStoreAccessNotDetermined {
    id contactStore = OCMClassMock([CNContactStore class]);
    OCMStub([contactStore authorizationStatusForEntityType:CNEntityTypeContacts]).andReturn(CNAuthorizationStatusDenied);
    
    ADContactsFrameworkManager *manager = [[ADContactsFrameworkManager alloc] initWithSystemContactsStore:contactStore];
    [manager getContactsCountWithCallback:^(NSUInteger contactsCount, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertTrue(contactsCount == 0);
    }];
}

- (void)testThatGetContactsCountShouldReturnErrorIfContactStoreAccessRestricted {
    id contactStore = OCMClassMock([CNContactStore class]);
    OCMStub([contactStore authorizationStatusForEntityType:CNEntityTypeContacts]).andReturn(CNAuthorizationStatusDenied);
    
    ADContactsFrameworkManager *manager = [[ADContactsFrameworkManager alloc] initWithSystemContactsStore:contactStore];
    [manager getContactsCountWithCallback:^(NSUInteger contactsCount, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertTrue(contactsCount == 0);
    }];
}

- (void)testThatGetContactsCountShouldReturnContactsCountWhenSucceeded {
    id contactStore = OCMClassMock([CNContactStore class]);
    OCMStub([contactStore authorizationStatusForEntityType:CNEntityTypeContacts]).andReturn(CNAuthorizationStatusAuthorized);
    
    OCMStub([contactStore enumerateContactsWithFetchRequest:OCMOCK_ANY error:[OCMArg anyObjectRef] usingBlock:OCMOCK_ANY]).andDo(^(NSInvocation *invocation){
        void(^block)(CNContact *contact, BOOL *stop) = nil;
        [invocation getArgument:&block atIndex:4];
        for (NSInteger i = 0; i < 10; i++) {
            block(nil, nil);
        }
    });
    
    ADContactsFrameworkManager *manager = [[ADContactsFrameworkManager alloc] initWithSystemContactsStore:contactStore];
    [manager getContactsCountWithCallback:^(NSUInteger contactsCount, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertTrue(contactsCount == 10);
    }];
}



@end
