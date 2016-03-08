//
//  ADContactPhone.h
//  ADContactsManager
//
//  Created by Anton Domashnev on 10/6/15.
//  Copyright © 2015 Anton Domashnev. All rights reserved.
//

@import Foundation;

#import "ADContactInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface ADContactPhone : NSObject <ADContactInfo>

@property (nonatomic, copy) NSString *value;

@property (nonatomic, copy, nullable) NSString *label;

@end

NS_ASSUME_NONNULL_END
