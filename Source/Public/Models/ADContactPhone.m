//
//  ADContactPhone.m
//  ADContactsManager
//
//  Created by Anton Domashnev on 10/6/15.
//  Copyright © 2015 Anton Domashnev. All rights reserved.
//

#import "ADContactPhone.h"

/*-------View Controllers-------*/

/*-------Frameworks-------*/

/*-------Views-------*/

/*-------Helpers & Managers-------*/
#import "ADContactsManagerMacros.h"

/*-------Models-------*/

@interface ADContactPhone ()

@end

@implementation ADContactPhone

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[ADContactPhone class]]) {
        return NO;
    }
    ADContactPhone *phone = (ADContactPhone *)object;

    NSString *phoneLabel = phone.label ? phone.label : @"";
    NSString *selfLabel = self.label ? self.label : @"";
    if (([phoneLabel length] != [selfLabel length]) || ![ADNonnull(phoneLabel) isEqualToString:ADNonnull(selfLabel)]) {
        return NO;
    }

    NSString *phoneValue = phone.value ? phone.value : @"";
    NSString *selfValue = self.value ? self.value : @"";
    if (([phoneValue length] != [selfValue length]) || ![ADNonnull(phoneValue) isEqualToString:ADNonnull(selfValue)]) {
        return NO;
    }
    return YES;
}

- (NSUInteger)hash {
    return [self.value hash] + [self.label hash];
}

@end
