//
//  ADContactAddress.h
//  ADContactsManager
//
//  Created by Anton Domashnev on 10/6/15.
//  Copyright © 2015 Anton Domashnev. All rights reserved.
//

@import Foundation;

#import "ADContactInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface ADContactAddress : NSObject <ADContactInfo>

@property (nonatomic, copy, nullable) NSString *label;
@property (nonatomic, copy, nullable) NSString *country;
@property (nonatomic, copy, nullable) NSString *state;
@property (nonatomic, copy, nullable) NSString *zip;
@property (nonatomic, copy, nullable) NSString *street;
@property (nonatomic, copy, nullable) NSString *city;

@end

NS_ASSUME_NONNULL_END
