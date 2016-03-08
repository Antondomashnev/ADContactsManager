//
//  ADAddressBookFrameworkManager.h
//  ADContactsManager
//
//  Created by Anton Domashnev on 10/10/15.
//  Copyright © 2015 Anton Domashnev. All rights reserved.
//

#import "ADContactsManager.h"

@import AddressBook;

NS_ASSUME_NONNULL_BEGIN

@interface ADAddressBookFrameworkManager : NSObject <ADContactsManager>

- (instancetype)init;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)initWithSystemAddressBook:(ABAddressBookRef)addressBook;
#pragma GCC diagnostic pop

@end

NS_ASSUME_NONNULL_END