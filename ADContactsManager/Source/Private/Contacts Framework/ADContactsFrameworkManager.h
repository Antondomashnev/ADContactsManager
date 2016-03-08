//
//  ADContactsFrameworkManager.h
//  ADContactsManager
//
//  Created by Anton Domashnev on 10/6/15.
//  Copyright © 2015 Anton Domashnev. All rights reserved.
//

#import "ADContactsManager.h"

@class CNContactStore;

NS_ASSUME_NONNULL_BEGIN

@interface ADContactsFrameworkManager : NSObject <ADContactsManager>

- (instancetype)init;

- (instancetype)initWithSystemContactsStore:(CNContactStore *)contactsStore;

@end

NS_ASSUME_NONNULL_END