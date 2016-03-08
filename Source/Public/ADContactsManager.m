//
//  ADContactsManager.m
//  ADContactsManager
//
//  Created by Anton Domashnev on 10/6/15.
//  Copyright © 2015 Anton Domashnev. All rights reserved.
//

#import "ADContactsManager.h"

/*-------View Controllers-------*/

/*-------Frameworks-------*/
@import Contacts;
@import AddressBook;

/*-------Views-------*/

/*-------Helpers & Managers-------*/
#import "ADContactsFrameworkManager.h"
#import "ADAddressBookFrameworkManager.h"

/*-------Models-------*/

@implementation ADContactsManager

#pragma mark - Interface

static ADContactsManagerSystemFramework preferredContactsManagerSystemFramework;
+ (void)setPreferredContactsManagerSystemFramework:(ADContactsManagerSystemFramework)framework {
    if ([[self availableContactsManagerSystemFrameworks] containsObject:@(preferredContactsManagerSystemFramework)]) {
        preferredContactsManagerSystemFramework = framework;
    }
    else {
        preferredContactsManagerSystemFramework = ADContactsManagerSystemFrameworkAddressBook;
    }
}

+ (ADContactsManagerSystemFramework)preferredContactsManagerSystemFramework {
    if ([[self availableContactsManagerSystemFrameworks] containsObject:@(preferredContactsManagerSystemFramework)]){
        return preferredContactsManagerSystemFramework;
    }
    else{
        return ADContactsManagerSystemFrameworkAddressBook;
    }
}

+ (NSArray<NSNumber *> *)availableContactsManagerSystemFrameworks {
    if (NSStringFromClass([CNContactStore class])) {
        return @[@(ADContactsManagerSystemFrameworkAddressBook), @(ADContactsManagerSystemFrameworkContacts)];
    } else {
        return @[@(ADContactsManagerSystemFrameworkAddressBook)];
    }
}

+ (id<ADContactsManager>)contactsManager {
    switch ([self preferredContactsManagerSystemFramework]) {
        case ADContactsManagerSystemFrameworkAddressBook:
            return [self addressBookFrameworkManager];
        case ADContactsManagerSystemFrameworkContacts:
            return [self contactsFrameworkManager];
    }
}

#pragma mark - Helpers

+ (id<ADContactsManager>)contactsFrameworkManager {
    static id<ADContactsManager> contactsFrameworkManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        contactsFrameworkManager = [ADContactsFrameworkManager new];
    });
    return contactsFrameworkManager;
}

+ (id<ADContactsManager>)addressBookFrameworkManager {
    static id<ADContactsManager> contactsFrameworkManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        contactsFrameworkManager = [ADAddressBookFrameworkManager new];
    });
    return contactsFrameworkManager;
}

@end
