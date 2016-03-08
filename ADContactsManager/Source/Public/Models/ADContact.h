//
//  ADContact.h
//  ADContactsManager
//
//  Created by Anton Domashnev on 10/6/15.
//  Copyright © 2015 Anton Domashnev. All rights reserved.
//

@import Foundation;

@class ADContactAddress;
@class ADContactPhone;
@class ADContactEmail;

NS_ASSUME_NONNULL_BEGIN

@interface ADContact : NSObject

@property (nonatomic, copy) NSString *contactID;

@property (nonatomic, copy, nullable) NSString *firstName;
@property (nonatomic, copy, nullable) NSString *lastName;
@property (nonatomic, copy, nullable) NSString *middleName;
@property (nonatomic, strong, nullable) NSDate *birthday;

@property (nonatomic, copy, nullable) NSString *organization;
@property (nonatomic, copy, nullable) NSString *jobTitle;

@property (nonatomic, strong, nullable) NSData *thumbnailPhotoImageData;
@property (nonatomic, strong, nullable) NSData *fullSizePhotoImageData;

@property (nonatomic, strong, nullable) NSArray<ADContactPhone *> *phones;
@property (nonatomic, strong, nullable) NSArray<ADContactEmail *> *emails;
@property (nonatomic, strong, nullable) NSArray<ADContactAddress *> *addresses;

@property (nonatomic, strong, nullable) NSDate *updatedAt;

@end

NS_ASSUME_NONNULL_END
