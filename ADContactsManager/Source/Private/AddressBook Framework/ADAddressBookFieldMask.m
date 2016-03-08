//
//  ADAddressBookFieldMask.m
//  ADContactsManager
//
//  Created by Anton Domashnev on 10/10/15.
//  Copyright © 2015 Anton Domashnev. All rights reserved.
//

#import "ADAddressBookFieldMask.h"

@interface ADAddressBookFieldMask ()

@property (nonatomic, assign, readwrite) ADContactField fieldMask;

@end

@implementation ADAddressBookFieldMask

- (instancetype)initWithFieldMask:(ADContactField)fieldMask {
    self = [super init];
    if (self) {
        self.fieldMask = fieldMask;
    }
    return self;
}

@end
