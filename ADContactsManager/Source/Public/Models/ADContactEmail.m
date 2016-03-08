//
//  ADContactEmail.m
//  ADContactsManager
//
//  Created by Anton Domashnev on 10/6/15.
//  Copyright © 2015 Anton Domashnev. All rights reserved.
//

#import "ADContactEmail.h"

/*-------View Controllers-------*/

/*-------Frameworks-------*/

/*-------Views-------*/

/*-------Helpers & Managers-------*/
#import "ADContactsManagerMacros.h"

/*-------Models-------*/

@implementation ADContactEmail

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[ADContactEmail class]]) {
        return NO;
    }
    ADContactEmail *email = (ADContactEmail *)object;

    NSString *emailLabel = email.label ? email.label : @"";
    NSString *selfLabel = self.label ? self.label : @"";
    if (([emailLabel length] != [selfLabel length]) || ![ADNonnull(emailLabel) isEqualToString:ADNonnull(selfLabel)]) {
        return NO;
    }

    NSString *emailValue = email.value ? email.value : @"";
    NSString *selfValue = self.value ? self.value : @"";
    if (([emailValue length] != [selfValue length]) || ![ADNonnull(emailValue) isEqualToString:ADNonnull(selfValue)]) {
        return NO;
    }
    return YES;
}

- (NSUInteger)hash {
    return [self.value hash] + [self.label hash];
}

@end