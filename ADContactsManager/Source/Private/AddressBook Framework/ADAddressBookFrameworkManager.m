//
//  ADAddressBookFrameworkManager.m
//  ADContactsManager
//
//  Created by Anton Domashnev on 10/10/15.
//  Copyright © 2015 Anton Domashnev. All rights reserved.
//

#import "ADAddressBookFrameworkManager.h"

/*-------View Controllers-------*/

/*-------Frameworks-------*/

/*-------Views-------*/

/*-------Helpers & Managers-------*/
#import "ADContactsManagerUtilities.h"
#import "ADContactsManagerMacros.h"
#import "ADContactsManagerError.h"
#import "ADAddressBookConverter.h"
#import "ADAddressBookFieldMask.h"

/*-------Models-------*/
#import "ADContact.h"

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

@interface ADAddressBookFrameworkManager (){
    ABAddressBookRef ref;
}

@property (nonatomic, strong) ADAddressBookConverter *converter;
@property (nonatomic, strong, nullable) NSError *initializationError;

@end

@implementation ADAddressBookFrameworkManager

- (instancetype)init {
    self = [super init];
    if (self) {
        CFErrorRef error = NULL;
        ref = ABAddressBookCreateWithOptions(NULL, &error);
        ABAddressBookRegisterExternalChangeCallback(ref, addressBookChanged, (__bridge void *)(self));
        if (error) {
            self.initializationError = (__bridge NSError *)(error);
        }
        self.converter = [[ADAddressBookConverter alloc] init];
    }
    return self;
}

- (instancetype)initWithSystemAddressBook:(ABAddressBookRef)addressBook {
    NSParameterAssert(addressBook);
    self = [super init];
    if (self) {
        self.addressBook = addressBook;
        ABAddressBookRegisterExternalChangeCallback(ref, addressBookChanged, (__bridge void *)(self));
        self.converter = [[ADAddressBookConverter alloc] init];
    }
    return self;
}

- (void)dealloc {
    if (ref) {
        CFRelease(ref);
    }
}

#pragma mark - Properties

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdirect-ivar-access"
- (ABAddressBookRef)addressBook {
    return ref;
}

- (void)setAddressBook:(ABAddressBookRef)addressBook {
    ref = addressBook;
}
#pragma clang diagnostic pop

#pragma mark - ADContactsManager

- (ADContactsManagerAccessStatus)accessStatus {
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    switch (status) {
        case kABAuthorizationStatusNotDetermined: {
            return ADContactsManagerAccessStatusNotDetermined;
        }
        case kABAuthorizationStatusRestricted: {
            return ADContactsManagerAccessStatusRestricted;
        }
        case kABAuthorizationStatusDenied: {
            return ADContactsManagerAccessStatusDenied;
        }
        case kABAuthorizationStatusAuthorized: {
            return ADContactsManagerAccessStatusAuthorized;
        }
    }
    return ADContactsManagerAccessStatusNotDetermined;
}

- (void)requestAccessWithCallback:(ADContactsManagerAccessBlock)callback {
    if (self.initializationError) {
        NSError *error = [ADContactsManagerError errorWithCode:ADContactsManagerErrorCodeAddressBookFrameworkError message:NSLocalizedString(@"Something went wrong while accessing your contacts. Please try again later.", @"Something went wrong while accessing your contacts. Please try again later.") underlineError:nil];
        ADPerformBlock(callback, ADContactsManagerAccessStatusRestricted, error);
        return;
    }

    ADContactsManagerAccessStatus accessStatus = self.accessStatus;
    switch (accessStatus) {
        case ADContactsManagerAccessStatusDenied:
        case ADContactsManagerAccessStatusRestricted: {
            NSError *error = [ADContactsManagerError errorWithCode:ADContactsManagerErrorCodeAddressBookFrameworkError message:NSLocalizedString(@"Please allow the app to access your contacts through the Settings.", @"Please allow the app to access your contacts through the Settings.") underlineError:nil];
            ADPerformBlock(callback, accessStatus, error);
            return;
        }
        case ADContactsManagerAccessStatusAuthorized: {
            ADPerformBlock(callback, accessStatus, nil);
            return;
        }
        case ADContactsManagerAccessStatusNotDetermined: {
            ADAddressBookFrameworkManager __weak *wSelf = self;
            ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error) {
                ADAddressBookFrameworkManager __strong *sSelf = wSelf;
                if (!granted) {
                    NSError *error = [ADContactsManagerError errorWithCode:ADContactsManagerErrorCodeAddressBookFrameworkError message:NSLocalizedString(@"Please allow the app to access your contacts through the Settings.", @"Please allow the app to access your contacts through the Settings.") underlineError:nil];
                    ADPerformBlock(callback, sSelf.accessStatus, error);
                } else {
                    ADPerformBlock(callback, sSelf.accessStatus, nil);
                }
            });
            return;
        }
    }
}

- (void)getContactsCountWithCallback:(ADContactsManagerCountBlock)callback {
    [self isAuthorized:^(BOOL success, NSError *error) {
        if (!success) {
            ADPerformBlock(callback, 0, error);
            return;
        }
        CFIndex peopleCount = ABAddressBookGetPersonCount(self.addressBook);
        ADPerformBlock(callback, peopleCount, nil);
    }];
}

- (void)getContactsWithCallback:(ADContactsManagerGetBlock)callback {
    [self isAuthorized:^(BOOL success, NSError *error) {
        if (!success) {
            ADPerformBlock(callback, nil, error);
            return;
        }
        ADAddressBookFieldMask *fieldMask = [[ADAddressBookFieldMask alloc] initWithFieldMask:ADContactFieldAll];
        NSMutableArray<ADContact *> *arrayOfContacts = [NSMutableArray array];
        CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(self.addressBook);
        CFIndex peopleCount = CFArrayGetCount(people);
        for (int i = 0; i < peopleCount; i++) {
            ABRecordRef person = CFArrayGetValueAtIndex(people, i);
            ADContact *contact = [self.converter contactFromAddressBookFrameworkContact:person fieldMask:fieldMask];
            [arrayOfContacts addObject:contact];
        }
        CFRelease(people);
        ADPerformBlock(callback, [arrayOfContacts copy], nil);
    }];
}

- (void)addContact:(ADContact *)contact withCallback:(ADContactsManagerAddBlock)callback {
    if(!contact){
        NSParameterAssert(contact);
        return;
    }
    
    [self isAuthorized:^(BOOL success, NSError *error) {
        if (!success) {
            ADPerformBlock(callback, nil, error);
            return;
        }

        CFErrorRef *addContactError = NULL;
        ADAddressBookFieldMask *fieldMask = [[ADAddressBookFieldMask alloc] initWithFieldMask:ADContactFieldAll];
        ABRecordRef newPerson = [self.converter newAddressBookFrameworkContactFromContact:contact fieldMask:fieldMask];
        if (!ABAddressBookAddRecord(self.addressBook, newPerson, addContactError)) {
            if (addContactError) {
                NSError *errorObject = (__bridge NSError *)*addContactError;
                ADPerformBlock(callback, nil, errorObject)
                CFRelease(addContactError);
            }
            ADPerformBlock(callback, nil, nil);
        } else {
            [self saveChangesInAddressBook:self.addressBook callback:^(NSError *saveError) {
                    if (saveError) {
                        ADPerformBlock(callback, nil, saveError);
                    } else {
                        contact.contactID = [NSString stringWithFormat:@"%d", ABRecordGetRecordID(newPerson)];
                        ADPerformBlockOnMainThread(callback, contact, nil);
                    }
                }];
        }
    }];
}

- (void)updateContact:(ADContact *)contact withCallback:(ADContactsManagerUpdateBlock)callback {
    if(!contact){
        NSParameterAssert(contact);
        return;
    }
    
    [self isAuthorized:^(BOOL success, NSError *error) {
        if (!success) {
            ADPerformBlock(callback, nil, error);
            return;
        }

        ADAddressBookFieldMask *fieldMask = [[ADAddressBookFieldMask alloc] initWithFieldMask:ADContactFieldAll];
        ABRecordRef personToUpdate = ABAddressBookGetPersonWithRecordID(self.addressBook, [contact.contactID intValue]);
        if(!personToUpdate){
            ADPerformBlock(callback, nil, nil);
            return;
        }

        [self.converter updatedAddressBookFrameworkContact:personToUpdate fromContact:contact fieldMask:fieldMask];
        [self saveChangesInAddressBook:self.addressBook callback:^(NSError *saveError) {
                if (saveError) {
                    ADPerformBlockOnMainThread(callback, nil, saveError);
                } else {
                    ADPerformBlockOnMainThread(callback, contact, nil);
                }
            }];
    }];
}

- (void)deleteContact:(ADContact *)contact withCallback:(ADContactsManagerDeleteBlock)callback {
    if(!contact){
        NSParameterAssert(contact);
        return;
    }
    
    ADAddressBookFrameworkManager __weak *wSelf = self;
    [self isAuthorized:^(BOOL success, NSError *error) {
        if (!success) {
            ADPerformBlock(callback, NO, error);
            return;
        }

        CFErrorRef *deleteContactError = NULL;
        ABRecordRef personToDelete = ABAddressBookGetPersonWithRecordID(self.addressBook, [contact.contactID intValue]);;
        if(!personToDelete){
            ADPerformBlock(callback, NO, [ADContactsManagerError errorWithCode:ADContactsManagerErrorCodeAddressBookFrameworkError message:[NSString stringWithFormat:NSLocalizedString(@"Failed to delete contact. Contact with id %@ not found", nil), contact.contactID] underlineError:nil]);
            return;
        }

        ADAddressBookFrameworkManager __strong *sSelf = wSelf;
        if (!ABAddressBookRemoveRecord(sSelf.addressBook, personToDelete, deleteContactError)) {
            if(deleteContactError){
                NSError *errorObject = (__bridge NSError *)*deleteContactError;
                ADPerformBlock(callback, NO, [ADContactsManagerError errorWithCode:ADContactsManagerErrorCodeAddressBookFrameworkError message:[NSString stringWithFormat:NSLocalizedString(@"Failed to delete contact. Address book error %@", nil), errorObject.localizedDescription] underlineError:errorObject]);
                CFRelease(deleteContactError);
            }
            else {
                ADPerformBlock(callback, NO, [ADContactsManagerError errorWithCode:ADContactsManagerErrorCodeAddressBookFrameworkError message:NSLocalizedString(@"Failed to delete contact. Unknown error", nil) underlineError:nil]);
            }
        } else {
            [self saveChangesInAddressBook:sSelf.addressBook callback:^(NSError *saveError) {
                    if (saveError) {
                        ADPerformBlock(callback, NO, [ADContactsManagerError errorWithCode:ADContactsManagerErrorCodeAddressBookFrameworkError message:[NSString stringWithFormat:NSLocalizedString(@"Failed to delete contact. Can not save changes in address book %@", nil), saveError.localizedDescription] underlineError:saveError]);
                    } else {
                        ADPerformBlock(callback, YES, nil);
                    }
                }];
        }
    }];
}

#pragma mark - Helpers

void addressBookChanged(ABAddressBookRef addressBook, CFDictionaryRef info, void *context) {
    //This ia a hack. I don't know why but is there are changed in address book it still will return old persons.
    //To avoid this situation we reinitializing address book and reassign it in address book manager
    ADAddressBookFrameworkManager *manager = (__bridge ADAddressBookFrameworkManager *)context;
    manager.addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
}

- (void)isAuthorized:(ADContactsManagerBooleanErrorBlock)callback {
    ADContactsManagerAccessStatus accessStatus = self.accessStatus;
    switch (accessStatus) {
        case ADContactsManagerAccessStatusNotDetermined:
        case ADContactsManagerAccessStatusDenied:
        case ADContactsManagerAccessStatusRestricted: {
            NSError *error = [ADContactsManagerError errorWithCode:ADContactsManagerErrorCodeAddressBookFrameworkError message:NSLocalizedString(@"Please allow the app to access your contacts through the Settings.", @"Please allow the app to access your contacts through the Settings.") underlineError:nil];
            ADPerformBlock(callback, NO, error);
            break;
        }
        case ADContactsManagerAccessStatusAuthorized: {
            ADPerformBlock(callback, YES, nil);
            break;
        }
    }
}

- (void)saveChangesInAddressBook:(ABAddressBookRef)book callback:(void (^)(NSError *error))callback {
    if (!ABAddressBookHasUnsavedChanges(book)) {
        ADPerformBlock(callback, nil);
        return;
    }
    
    CFErrorRef *error = NULL;
    if (!ABAddressBookSave(book, error)) {
        NSError *errorObject = (__bridge NSError *)*error;
        ADPerformBlock(callback, errorObject);
        CFRelease(error);
        return;
    }
    ADPerformBlock(callback, nil);
}

@end

#pragma GCC diagnostic pop