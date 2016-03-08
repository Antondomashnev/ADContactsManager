//
//  ADContact.m
//  ADContactsManager
//
//  Created by Anton Domashnev on 10/6/15.
//  Copyright © 2015 Anton Domashnev. All rights reserved.
//

#import "ADContact.h"

/*-------View Controllers-------*/

/*-------Frameworks-------*/

/*-------Views-------*/

/*-------Helpers & Managers-------*/
#import "ADContactsManagerUtilities.h"
#import "ADContactsManagerMacros.h"

/*-------Models-------*/
#import "ADContactEmail.h"
#import "ADContactPhone.h"
#import "ADContactAddress.h"

@implementation ADContact

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[ADContact class]]) {
        return NO;
    }
    ADContact *contact = (ADContact *)object;

    NSString *contactFirstName = contact.firstName ? contact.firstName : @"";
    NSString *selfContactFirstName = self.firstName ? self.firstName : @"";
    if (([contactFirstName length] != [selfContactFirstName length]) || ![ADNonnull(contactFirstName) isEqualToString:ADNonnull(selfContactFirstName)]) {
        return NO;
    }

    NSString *contactLastName = contact.lastName ? contact.lastName : @"";
    NSString *selfLastName = self.lastName ? self.lastName : @"";
    if (([contactLastName length] != [selfLastName length]) || ![ADNonnull(contactLastName) isEqualToString:ADNonnull(selfLastName)]) {
        return NO;
    }
    
    NSString *contactMiddleName = contact.middleName ? contact.middleName : @"";
    NSString *selfMiddleName = self.middleName ? self.middleName : @"";
    if (([contactMiddleName length] != [contactMiddleName length]) || ![ADNonnull(contactMiddleName) isEqualToString:ADNonnull(selfMiddleName)]) {
        return NO;
    }

    if ((contact.birthday && !self.birthday) ||
        (!contact.birthday && self.birthday) ||
        (![ADNonnull(contact.birthday) isEqualToDate:ADNonnull(self.birthday)] && (contact.birthday && self.birthday))) {
        return NO;
    }

    NSString *contactOrganization = contact.organization ? contact.organization : @"";
    NSString *selfOrganization = self.organization ? self.organization : @"";
    if (([contactOrganization length] != [selfOrganization length]) || ![ADNonnull(contactOrganization) isEqualToString:ADNonnull(selfOrganization)]) {
        return NO;
    }

    NSString *contactJobTitle = contact.jobTitle ? contact.jobTitle : @"";
    NSString *selfJobTitle = self.jobTitle ? self.jobTitle : @"";
    if (([contactJobTitle length] != [selfJobTitle length]) || ![ADNonnull(contactJobTitle) isEqualToString:ADNonnull(selfJobTitle)]) {
        return NO;
    }

    NSArray *contactPhones = contact.phones ? contact.phones : @[];
    NSArray *selfPhones = self.phones ? self.phones : @[];
    if (([contactPhones count] != [selfPhones count]) || ![ADNonnull(contactPhones) isEqualToArray:ADNonnull(selfPhones)]) {
        return NO;
    }

    NSArray *contactEmails = contact.emails ? contact.emails : @[];
    NSArray *selfEmails = self.emails ? self.emails : @[];
    if (([contactEmails count] != [selfEmails count]) || ![ADNonnull(contactEmails) isEqualToArray:ADNonnull(selfEmails)]) {
        return NO;
    }

    NSArray *contactAddresses = contact.addresses ? contact.addresses : @[];
    NSArray *selfAddresses = self.addresses ? self.addresses : @[];
    if (([contactAddresses count] != [selfAddresses count]) || ![ADNonnull(contactAddresses) isEqualToArray:ADNonnull(selfAddresses)]) {
        return NO;
    }
    return YES;
}

- (NSUInteger)hash {
    return [self.firstName hash] + [self.lastName hash] + [self.birthday hash] + [self.organization hash] + [self.jobTitle hash] + [self.phones hash] + [self.emails hash] + [self.addresses hash];
}

@end