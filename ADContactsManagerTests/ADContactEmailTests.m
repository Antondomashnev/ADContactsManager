//
//  ADContactEmailTests.m
//  ADContactsManager
//
//  Created by Anton Domashnev on 3/7/16.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

@import XCTest;

#import "ADContactEmail.h"

@interface ADContactEmailTests : XCTestCase

@end

@implementation ADContactEmailTests

- (void)testNotEqualIfClassesAreDifferent {
    ADContactEmail *email1 = [ADContactEmail new];
    NSObject *email2 = [NSObject new];
    XCTAssertFalse([email1 isEqual:email2]);
}

- (void)testNotEqualIfValueAreDifferent {
    ADContactEmail *email1 = [ADContactEmail new];
    email1.value = @"1234567890";
    ADContactEmail *email2 = [ADContactEmail new];
    email2.value = @"0987654321";
    XCTAssertFalse([email1 isEqual:email2]);
}

- (void)testNotEqualIfLabelAreDifferent {
    ADContactEmail *email1 = [ADContactEmail new];
    email1.value = @"1234567890";
    email1.label = @"Home";
    ADContactEmail *email2 = [ADContactEmail new];
    email2.value = @"1234567890";
    email2.label = @"Work";
    XCTAssertFalse([email1 isEqual:email2]);
}

- (void)testEqualIfEverythingIsEqual {
    ADContactEmail *email1 = [ADContactEmail new];
    email1.value = @"1234567890";
    email1.label = @"Home";
    ADContactEmail *email2 = [ADContactEmail new];
    email2.value = @"1234567890";
    email2.label = @"Home";
    XCTAssertTrue([email1 isEqual:email2]);
}

@end
