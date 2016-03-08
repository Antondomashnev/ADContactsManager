//
//  ADContactTests.m
//  ADContactsManager
//
//  Created by Anton Domashnev on 3/7/16.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

@import XCTest;

#import <OCMock/OCMock.h>

#import "ADContact.h"
#import "ADContactPhone.h"
#import "ADContactEmail.h"
#import "ADContactAddress.h"

@interface ADContactTests : XCTestCase

@end

@implementation ADContactTests

- (void)testNotEqualIfClassesAreDifferent {
    ADContact *contact = [ADContact new];
    NSObject *object = [NSObject new];
    XCTAssertFalse([contact isEqual:object]);
}

- (void)testNotEqualIfFirstNameAreDifferent {
    ADContact *contact1 = [ADContact new];
    contact1.firstName = @"Anton";
    ADContact *contact2 = [ADContact new];
    contact2.firstName = @"Ivan";
    XCTAssertFalse([contact1 isEqual:contact2]);
}

- (void)testNotEqualIfLastNameAreDifferent {
    ADContact *contact1 = [ADContact new];
    contact1.firstName = @"Anton";
    contact1.lastName = @"Ivanov";
    ADContact *contact2 = [ADContact new];
    contact2.firstName = @"Anton";
    contact2.lastName = @"Petrov";
    XCTAssertFalse([contact1 isEqual:contact2]);
}

- (void)testNotEqualIfMiddleNameAreDifferent {
    ADContact *contact1 = [ADContact new];
    contact1.firstName = @"Anton";
    contact1.lastName = @"Ivanov";
    contact1.middleName = @"Alekseevich";
    ADContact *contact2 = [ADContact new];
    contact2.firstName = @"Anton";
    contact2.lastName = @"Ivanov";
    contact2.middleName = @"Ivanovich";
    XCTAssertFalse([contact1 isEqual:contact2]);
}

- (void)testNotEqualIfBirthdayAreDifferent {
    ADContact *contact1 = [ADContact new];
    contact1.firstName = @"Anton";
    contact1.lastName = @"Ivanov";
    contact1.middleName = @"Alekseevich";
    contact1.birthday = [NSDate dateWithTimeIntervalSince1970:1];
    ADContact *contact2 = [ADContact new];
    contact2.firstName = @"Anton";
    contact2.lastName = @"Ivanov";
    contact2.middleName = @"Alekseevich";
    contact2.birthday = [NSDate dateWithTimeIntervalSince1970:0];
    XCTAssertFalse([contact1 isEqual:contact2]);
}

- (void)testNotEqualIfOrganizationsAreDifferent {
    ADContact *contact1 = [ADContact new];
    contact1.firstName = @"Anton";
    contact1.lastName = @"Ivanov";
    contact1.middleName = @"Alekseevich";
    contact1.birthday = [NSDate dateWithTimeIntervalSince1970:1];
    contact1.organization = @"Google";
    ADContact *contact2 = [ADContact new];
    contact2.firstName = @"Anton";
    contact2.lastName = @"Ivanov";
    contact2.middleName = @"Alekseevich";
    contact2.birthday = [NSDate dateWithTimeIntervalSince1970:1];
    contact2.organization = @"Conichi";
    XCTAssertFalse([contact1 isEqual:contact2]);
}

- (void)testNotEqualIfJobTitlesAreDifferent {
    ADContact *contact1 = [ADContact new];
    contact1.firstName = @"Anton";
    contact1.lastName = @"Ivanov";
    contact1.middleName = @"Alekseevich";
    contact1.birthday = [NSDate dateWithTimeIntervalSince1970:1];
    contact1.organization = @"Conichi";
    contact1.jobTitle = @"iOS Developer";
    ADContact *contact2 = [ADContact new];
    contact2.firstName = @"Anton";
    contact2.lastName = @"Ivanov";
    contact2.middleName = @"Alekseevich";
    contact2.birthday = [NSDate dateWithTimeIntervalSince1970:1];
    contact2.organization = @"Conichi";
    contact2.jobTitle = @"Accountant";
    XCTAssertFalse([contact1 isEqual:contact2]);
}

- (void)testNotEqualIfPhonesAreDifferent {
    ADContact *contact1 = [ADContact new];
    contact1.firstName = @"Anton";
    contact1.lastName = @"Ivanov";
    contact1.middleName = @"Alekseevich";
    contact1.birthday = [NSDate dateWithTimeIntervalSince1970:1];
    contact1.organization = @"Conichi";
    contact1.jobTitle = @"iOS Developer";
    
    ADContact *contact2 = [ADContact new];
    contact2.firstName = @"Anton";
    contact2.lastName = @"Ivanov";
    contact2.birthday = [NSDate dateWithTimeIntervalSince1970:1];
    contact2.middleName = @"Alekseevich";
    contact2.organization = @"Conichi";
    contact2.jobTitle = @"iOS Developer";
    
    ADContactPhone *phone1 = OCMPartialMock([ADContactPhone new]);
    ADContactPhone *phone2 = OCMPartialMock([ADContactPhone new]);
    contact2.phones = OCMPartialMock(@[phone2]);
    contact1.phones = OCMPartialMock(@[phone1]);
    OCMStub([contact1.phones isEqualToArray:contact2.phones]).andReturn(NO);
    OCMStub([contact2.phones isEqualToArray:contact1.phones]).andReturn(NO);
    
    XCTAssertFalse([contact1 isEqual:contact2]);
}

- (void)testNotEqualIfEmailsAreDifferent {
    ADContact *contact1 = [ADContact new];
    contact1.firstName = @"Anton";
    contact1.lastName = @"Ivanov";
    contact1.middleName = @"Alekseevich";
    contact1.birthday = [NSDate dateWithTimeIntervalSince1970:1];
    contact1.organization = @"Conichi";
    contact1.jobTitle = @"iOS Developer";
    
    ADContact *contact2 = [ADContact new];
    contact2.firstName = @"Anton";
    contact2.lastName = @"Ivanov";
    contact2.birthday = [NSDate dateWithTimeIntervalSince1970:1];
    contact2.middleName = @"Alekseevich";
    contact2.organization = @"Conichi";
    contact2.jobTitle = @"iOS Developer";
    
    ADContactPhone *phone1 = OCMPartialMock([ADContactPhone new]);
    ADContactPhone *phone2 = OCMPartialMock([ADContactPhone new]);
    contact2.phones = OCMPartialMock(@[phone2]);
    contact1.phones = OCMPartialMock(@[phone1]);
    OCMStub([contact1.phones isEqualToArray:contact2.phones]).andReturn(YES);
    OCMStub([contact2.phones isEqualToArray:contact1.phones]).andReturn(YES);
    
    ADContactEmail *email1 = OCMPartialMock([ADContactEmail new]);
    ADContactEmail *email2 = OCMPartialMock([ADContactEmail new]);
    contact2.emails = OCMPartialMock(@[email2]);
    contact1.emails = OCMPartialMock(@[email1]);
    OCMStub([contact1.emails isEqualToArray:contact2.emails]).andReturn(NO);
    OCMStub([contact2.emails isEqualToArray:contact1.emails]).andReturn(NO);

    XCTAssertFalse([contact1 isEqual:contact2]);
}

- (void)testNotEqualIfAddressesAreDifferent {
    ADContact *contact1 = [ADContact new];
    contact1.firstName = @"Anton";
    contact1.lastName = @"Ivanov";
    contact1.middleName = @"Alekseevich";
    contact1.birthday = [NSDate dateWithTimeIntervalSince1970:1];
    contact1.organization = @"Conichi";
    contact1.jobTitle = @"iOS Developer";
    
    ADContact *contact2 = [ADContact new];
    contact2.firstName = @"Anton";
    contact2.lastName = @"Ivanov";
    contact2.birthday = [NSDate dateWithTimeIntervalSince1970:1];
    contact2.middleName = @"Alekseevich";
    contact2.organization = @"Conichi";
    contact2.jobTitle = @"iOS Developer";
    
    ADContactPhone *phone1 = OCMPartialMock([ADContactPhone new]);
    ADContactPhone *phone2 = OCMPartialMock([ADContactPhone new]);
    contact2.phones = OCMPartialMock(@[phone2]);
    contact1.phones = OCMPartialMock(@[phone1]);
    OCMStub([contact1.phones isEqualToArray:contact2.phones]).andReturn(YES);
    OCMStub([contact2.phones isEqualToArray:contact1.phones]).andReturn(YES);
    
    ADContactEmail *email1 = OCMPartialMock([ADContactEmail new]);
    ADContactEmail *email2 = OCMPartialMock([ADContactEmail new]);
    contact2.emails = OCMPartialMock(@[email2]);
    contact1.emails = OCMPartialMock(@[email1]);
    OCMStub([contact1.emails isEqualToArray:contact2.emails]).andReturn(YES);
    OCMStub([contact2.emails isEqualToArray:contact1.emails]).andReturn(YES);
    
    ADContactAddress *address1 = OCMPartialMock([ADContactAddress new]);
    ADContactAddress *address2 = OCMPartialMock([ADContactAddress new]);
    contact2.addresses = OCMPartialMock(@[address2]);
    contact1.addresses = OCMPartialMock(@[address1]);
    OCMStub([contact1.addresses isEqualToArray:contact2.addresses]).andReturn(NO);
    OCMStub([contact2.addresses isEqualToArray:contact1.addresses]).andReturn(NO);
    
    XCTAssertFalse([contact1 isEqual:contact2]);
}

- (void)testEqualIfEverythingIsEqual {
    ADContact *contact1 = [ADContact new];
    contact1.firstName = @"Anton";
    contact1.lastName = @"Ivanov";
    contact1.middleName = @"Alekseevich";
    contact1.birthday = [NSDate dateWithTimeIntervalSince1970:1];
    contact1.organization = @"Conichi";
    contact1.jobTitle = @"iOS Developer";
    
    ADContact *contact2 = [ADContact new];
    contact2.firstName = @"Anton";
    contact2.lastName = @"Ivanov";
    contact2.birthday = [NSDate dateWithTimeIntervalSince1970:1];
    contact2.middleName = @"Alekseevich";
    contact2.organization = @"Conichi";
    contact2.jobTitle = @"iOS Developer";
    
    ADContactPhone *phone1 = OCMPartialMock([ADContactPhone new]);
    ADContactPhone *phone2 = OCMPartialMock([ADContactPhone new]);
    contact2.phones = OCMPartialMock(@[phone2]);
    contact1.phones = OCMPartialMock(@[phone1]);
    OCMStub([contact1.phones isEqualToArray:contact2.phones]).andReturn(YES);
    OCMStub([contact2.phones isEqualToArray:contact1.phones]).andReturn(YES);
    
    ADContactEmail *email1 = OCMPartialMock([ADContactEmail new]);
    ADContactEmail *email2 = OCMPartialMock([ADContactEmail new]);
    contact2.emails = OCMPartialMock(@[email2]);
    contact1.emails = OCMPartialMock(@[email1]);
    OCMStub([contact1.emails isEqualToArray:contact2.emails]).andReturn(YES);
    OCMStub([contact2.emails isEqualToArray:contact1.emails]).andReturn(YES);
    
    ADContactAddress *address1 = OCMPartialMock([ADContactAddress new]);
    ADContactAddress *address2 = OCMPartialMock([ADContactAddress new]);
    contact2.addresses = OCMPartialMock(@[address2]);
    contact1.addresses = OCMPartialMock(@[address1]);
    OCMStub([contact1.addresses isEqualToArray:contact2.addresses]).andReturn(YES);
    OCMStub([contact2.addresses isEqualToArray:contact1.addresses]).andReturn(YES);
    
    XCTAssertTrue([contact1 isEqual:contact2]);
}

@end
