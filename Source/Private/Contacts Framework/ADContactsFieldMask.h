//
//  ADContactsFieldMask.h
//  ADContactsManager
//
//  Created by Anton Domashnev on 10/7/15.
//  Copyright © 2015 Anton Domashnev. All rights reserved.
//

@import Foundation;

#import "ADContactsTypes.h"

NS_ASSUME_NONNULL_BEGIN

@interface ADContactsFieldMask : NSObject

@property (nonatomic, strong, readonly) NSArray<NSString *> *fieldsArray;

- (instancetype)initWithFields:(ADContactField)fieldsMask;

@end

NS_ASSUME_NONNULL_END