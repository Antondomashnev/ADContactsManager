//
//  ADContact.h
//  ADContactsManager
//
//  Created by Anton Domashnev on 9/12/15.
//  Copyright (c) 2015 Anton Domashnev. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@protocol ADContactInfo <NSObject>

/**
 * Returns value of the contact field - e.x. - phone number string
 */
- (NSString *)value;

/**
 * Returns label of the contact field - e.x. 'home'
 */
- (nullable NSString *)label;

@end

NS_ASSUME_NONNULL_END