//
//  ADContactPhoneTests.m
//  ADContactsManager
//
//  Created by Anton Domashnev on 3/7/16.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

@import XCTest;

#import "ADContactPhone.h"

@interface ADContactPhoneTests : XCTestCase

@end

@implementation ADContactPhoneTests

- (void)testNotEqualIfClassesAreDifferent {
    ADContactPhone *phone1 = [ADContactPhone new];
    NSObject *phone2 = [NSObject new];
    XCTAssertFalse([phone1 isEqual:phone2]);
}

- (void)testNotEqualIfValueAreDifferent {
    ADContactPhone *phone1 = [ADContactPhone new];
    phone1.value = @"1234567890";
    ADContactPhone *phone2 = [ADContactPhone new];
    phone2.value = @"0987654321";
    XCTAssertFalse([phone1 isEqual:phone2]);
}

- (void)testNotEqualIfLabelAreDifferent {
    ADContactPhone *phone1 = [ADContactPhone new];
    phone1.value = @"1234567890";
    phone1.label = @"Home";
    ADContactPhone *phone2 = [ADContactPhone new];
    phone2.value = @"1234567890";
    phone2.label = @"Work";
    XCTAssertFalse([phone1 isEqual:phone2]);
}

- (void)testEqualIfEverythingIsEqual {
    ADContactPhone *phone1 = [ADContactPhone new];
    phone1.value = @"1234567890";
    phone1.label = @"Home";
    ADContactPhone *phone2 = [ADContactPhone new];
    phone2.value = @"1234567890";
    phone2.label = @"Home";
    XCTAssertTrue([phone1 isEqual:phone2]);
}

@end
