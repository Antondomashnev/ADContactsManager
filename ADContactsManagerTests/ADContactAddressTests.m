//
//  ADContactAddressTests.m
//  ADContactsManager
//
//  Created by Anton Domashnev on 3/7/16.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

@import XCTest;

#import "ADContactAddress.h"

@interface ADContactAddressTests : XCTestCase

@end

@implementation ADContactAddressTests

- (void)testNotEqualIfClassesAreDifferent {
    ADContactAddress *address1 = [ADContactAddress new];
    NSObject *address2 = [NSObject new];
    XCTAssertFalse([address1 isEqual:address2]);
}

- (void)testNotEqualIfLabelAreDifferent {
    ADContactAddress *address1 = [ADContactAddress new];
    address1.label = @"Home";
    ADContactAddress *address2 = [ADContactAddress new];
    address2.label = @"work";
    XCTAssertFalse([address1 isEqual:address2]);
}

- (void)testNotEqualIfCountriesAreDifferent {
    ADContactAddress *address1 = [ADContactAddress new];
    address1.label = @"Home";
    address1.country = @"Russia";
    ADContactAddress *address2 = [ADContactAddress new];
    address2.label = @"Home";
    address1.country = @"Germany";
    XCTAssertFalse([address1 isEqual:address2]);
}

- (void)testNotEqualIfZipsAreDifferent {
    ADContactAddress *address1 = [ADContactAddress new];
    address1.label = @"Home";
    address1.country = @"Russia";
    address1.state = @"LP";
    address1.zip = @"123456";
    ADContactAddress *address2 = [ADContactAddress new];
    address2.label = @"Home";
    address2.country = @"Russia";
    address2.state = @"LP";
    address2.zip = @"12345";
    XCTAssertFalse([address1 isEqual:address2]);
}

- (void)testNotEqualIfStreetsAreDifferent {
    ADContactAddress *address1 = [ADContactAddress new];
    address1.label = @"Home";
    address1.country = @"Russia";
    address1.state = @"LP";
    address1.zip = @"123456";
    address1.street = @"Lenina";
    ADContactAddress *address2 = [ADContactAddress new];
    address2.label = @"Home";
    address2.country = @"Russia";
    address2.state = @"LP";
    address2.zip = @"123456";
    address2.street = @"Prospekt Mira";
    XCTAssertFalse([address1 isEqual:address2]);
}

- (void)testNotEqualIfCitiesAreDifferent {
    ADContactAddress *address1 = [ADContactAddress new];
    address1.label = @"Home";
    address1.country = @"Russia";
    address1.state = @"LP";
    address1.zip = @"123456";
    address1.street = @"Lenina";
    address1.city = @"Moscow";
    ADContactAddress *address2 = [ADContactAddress new];
    address2.label = @"Home";
    address2.country = @"Russia";
    address2.state = @"LP";
    address2.zip = @"123456";
    address2.street = @"Lenina";
    address2.city = @"Lipetsk";
    XCTAssertFalse([address1 isEqual:address2]);
}

- (void)testEqualIfEverythingIsEqual {
    ADContactAddress *address1 = [ADContactAddress new];
    address1.label = @"Home";
    address1.country = @"Russia";
    address1.state = @"LP";
    address1.zip = @"123456";
    address1.street = @"Lenina";
    address1.city = @"Moscow";
    ADContactAddress *address2 = [ADContactAddress new];
    address2.label = @"Home";
    address2.country = @"Russia";
    address2.state = @"LP";
    address2.zip = @"123456";
    address2.street = @"Lenina";
    address2.city = @"Moscow";
    XCTAssertTrue([address1 isEqual:address2]);
}

@end
