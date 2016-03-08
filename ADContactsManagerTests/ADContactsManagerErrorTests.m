//
//  ADContactsManagerErrorTests.m
//  ADContactsManager
//
//  Created by Anton Domashnev on 3/7/16.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

@import XCTest;

#import "ADContactsManagerError.h"

@interface ADContactsManagerErrorTests : XCTestCase

@end

@implementation ADContactsManagerErrorTests

- (void)testValidationErrorCreation {
    NSError *error = [ADContactsManagerError validationErrorForParameterName:@"parameterName" value:nil];
    XCTAssertTrue(error.code == ADContactsManagerErrorCodeValidationError);
    XCTAssertTrue([error.localizedDescription isEqualToString:@"Invalid value for parameterName: (null)"]);
    XCTAssertNil(error.userInfo[NSUnderlyingErrorKey]);
}

- (void)testErrorCreation {
    NSError *underlyingError = [NSError errorWithDomain:@"" code:0 userInfo:nil];
    NSError *error = [ADContactsManagerError errorWithCode:ADContactsManagerErrorCodeContactsFrameworkError message:@"Message" underlineError:underlyingError];
    XCTAssertTrue(error.code == ADContactsManagerErrorCodeContactsFrameworkError);
    XCTAssertTrue([error.localizedDescription isEqualToString:@"Message"]);
    XCTAssertTrue([error.userInfo[NSUnderlyingErrorKey] isEqual:underlyingError]);
}

@end
