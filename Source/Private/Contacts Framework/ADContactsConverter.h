//
//  ADContactsConverter.h
//  ADContactsManager
//
//  Created by Anton Domashnev on 10/10/15.
//  Copyright © 2015 Anton Domashnev. All rights reserved.
//

@import Foundation;
@import Contacts;

@class ADContact;

NS_ASSUME_NONNULL_BEGIN

@interface ADContactsConverter : NSObject

- (ADContact *)contactFromFrameworkContact:(CNContact *)frameworkContact;
- (CNContact *)frameworkContactFromContact:(ADContact *)contact;
- (CNMutableContact *)updatedFrameworkContact:(CNContact *)frameworkContact fromContact:(ADContact *)contact;

@end

NS_ASSUME_NONNULL_END