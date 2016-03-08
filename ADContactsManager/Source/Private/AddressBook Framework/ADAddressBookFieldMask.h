//
//  ADAddressBookFieldMask.h
//  ADContactsManager
//
//  Created by Anton Domashnev on 10/10/15.
//  Copyright © 2015 Anton Domashnev. All rights reserved.
//

@import Foundation;

#import "ADContactsTypes.h"

NS_ASSUME_NONNULL_BEGIN

@interface ADAddressBookFieldMask : NSObject

@property (nonatomic, assign, readonly) ADContactField fieldMask;

- (instancetype)initWithFieldMask:(ADContactField)fieldMask;

@end

NS_ASSUME_NONNULL_END