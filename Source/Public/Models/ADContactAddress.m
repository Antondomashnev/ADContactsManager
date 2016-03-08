//
//  ADContactAddress.m
//  ADContactsManager
//
//  Created by Anton Domashnev on 10/6/15.
//  Copyright © 2015 Anton Domashnev. All rights reserved.
//

#import "ADContactAddress.h"

/*-------View Controllers-------*/

/*-------Frameworks-------*/

/*-------Views-------*/

/*-------Helpers & Managers-------*/
#import "ADContactsManagerMacros.h"

/*-------Models-------*/

@implementation ADContactAddress

#pragma mark - ADContactInfo

- (NSString *)value {
    NSString *result = [NSString stringWithFormat:@"%@%@%@%@",
                        [self.street length] > 0 ? [NSString stringWithFormat:@"%@,\n", self.street]:@"",
                        [self.city length] > 0 ? [NSString stringWithFormat:@"%@,\n", self.city]    :@"",
                        [self.zip length] > 0 ? [NSString stringWithFormat:@"%@,\n", self.zip]      :@"",
                        [self.country length] > 0 ? self.country                                    :@""];
    if ([result hasSuffix:@",\n"]) {
        result = [result substringToIndex:[result length] - 2];
    }
    return [result copy];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[ADContactAddress class]]) {
        return NO;
    }
    ADContactAddress *address = (ADContactAddress *)object;

    NSString *addressLabel = address.label ? address.label : @"";
    NSString *selfLabel = self.label ? self.label : @"";
    if (([addressLabel length] != [selfLabel length]) || ![ADNonnull(addressLabel) isEqualToString:ADNonnull(selfLabel)]) {
        return NO;
    }

    NSString *addressValue = address.value ? address.value : @"";
    NSString *selfValue = self.value ? self.value : @"";
    if (([addressValue length] != [selfValue length]) || ![ADNonnull(addressValue) isEqualToString:ADNonnull(selfValue)]) {
        return NO;
    }

    return YES;
}

- (NSUInteger)hash {
    return [self.label hash] + [self.value hash];
}

@end