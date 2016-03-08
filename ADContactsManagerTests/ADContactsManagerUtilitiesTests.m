//
//  ADContactsManagerUtilitiesTests.m
//  ADContactsManager
//
//  Created by Anton Domashnev on 3/7/16.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

@import XCTest;

#import "ADContactsManagerUtilities.h"

@interface ADContactsManagerUtilitiesTests : XCTestCase

@end

@implementation ADContactsManagerUtilitiesTests

- (void)testThatStringIsEqualToStringShouldReturnYESIfBothStringsAreNil {
    XCTAssertTrue([ADContactsManagerUtilities string:nil isEqualToString:nil]);
}

- (void)testThatStringIsEqualToStringShouldReturnYESIfBothStringsAreEqual {
    XCTAssertTrue([ADContactsManagerUtilities string:@"a" isEqualToString:@"a"]);
}

- (void)testThatStringIsEqualToStringShouldReturnNOIfFirstStringIsNilAndAnotherIsNot {
    XCTAssertFalse([ADContactsManagerUtilities string:nil isEqualToString:@"a"]);
}

- (void)testThatStringIsEqualToStringShouldReturnNOIfSecondStringIsNilAndAnotherIsNot {
    XCTAssertFalse([ADContactsManagerUtilities string:@"a" isEqualToString:nil]);
}

- (void)testThatStringIsEqualToStringShouldReturnNOIfBothStringsAreNotNilAndNotEqual {
    XCTAssertFalse([ADContactsManagerUtilities string:@"a" isEqualToString:@"b"]);
}

@end
