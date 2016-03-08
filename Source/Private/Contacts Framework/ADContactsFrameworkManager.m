//
//  ADContactsFrameworkManager.m
//  ADContactsManager
//
//  Created by Anton Domashnev on 10/6/15.
//  Copyright © 2015 Anton Domashnev. All rights reserved.
//

#import "ADContactsFrameworkManager.h"

/*-------View Controllers-------*/

/*-------Frameworks-------*/
@import Contacts;

/*-------Views-------*/

/*-------Helpers & Managers-------*/
#import "ADContactsManagerError.h"
#import "ADContactsManagerMacros.h"
#import "ADContactsConverter.h"
#import "ADCOntactsManagerUtilities.h"

/*-------Models-------*/
#import "ADContact.h"
#import "ADContactsFieldMask.h"

@interface ADContactsFrameworkManager ()

@property (nonatomic, strong) CNContactStore *contactsStore;
@property (nonatomic, strong) ADContactsConverter *converter;

@end

@implementation ADContactsFrameworkManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contactsStore = [[CNContactStore alloc] init];
        self.converter = [ADContactsConverter new];
    }
    return self;
}

- (instancetype)initWithSystemContactsStore:(CNContactStore *)contactsStore {
    NSParameterAssert(contactsStore);
    self = [super init];
    if (self) {
        self.contactsStore = contactsStore;
        self.converter = [ADContactsConverter new];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - ADContactsManager

- (ADContactsManagerAccessStatus)accessStatus {
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    switch (status) {
        case CNAuthorizationStatusRestricted: {
            return ADContactsManagerAccessStatusRestricted;
        }
        case CNAuthorizationStatusDenied: {
            return ADContactsManagerAccessStatusDenied;
        }
        case CNAuthorizationStatusAuthorized: {
            return ADContactsManagerAccessStatusAuthorized;
        }
        case CNAuthorizationStatusNotDetermined: {
            return ADContactsManagerAccessStatusNotDetermined;
        }
    }
    return ADContactsManagerAccessStatusNotDetermined;
}

- (void)requestAccessWithCallback:(ADContactsManagerAccessBlock)callback {
    ADContactsManagerAccessStatus accessStatus = self.accessStatus;
    switch (accessStatus) {
        case ADContactsManagerAccessStatusDenied:
        case ADContactsManagerAccessStatusRestricted: {
            NSError *error = [ADContactsManagerError errorWithCode:ADContactsManagerErrorCodeContactsFrameworkError message:NSLocalizedString(@"Please allow the app to access your contacts through the Settings.", @"Please allow the app to access your contacts through the Settings.") underlineError:nil];
            ADPerformBlock(callback, accessStatus, error);
            return;
        }
        case ADContactsManagerAccessStatusAuthorized: {
            ADPerformBlock(callback, accessStatus, nil);
            return;
        }
        case ADContactsManagerAccessStatusNotDetermined: {
            ADContactsFrameworkManager __weak *wSelf = self;
            [self.contactsStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError *_Nullable error) {
                ADContactsFrameworkManager __strong *sSelf = wSelf;
                ADPerformBlock(callback, sSelf.accessStatus, error);
            }];
            return;
        }
    }
}

- (void)updateContact:(ADContact *)contact withCallback:(ADContactsManagerUpdateBlock)callback {
    if(!contact){
        NSParameterAssert(contact);
        ADPerformBlock(callback, nil, [ADContactsManagerError validationErrorForParameterName:@"contact" value:contact]);
        return;
    }
    ADContactsFieldMask *fieldsMask = [[ADContactsFieldMask alloc] initWithFields:ADContactFieldAll];
    [self getContactWithIdentifier:contact.contactID fieldsMask:fieldsMask callback:^(CNContact *_Nullable frameworkContact, NSError *_Nullable error) {
        if (error) {
            ADPerformBlock(callback, nil, error);
        } else {
            CNSaveRequest *updateRequest = [CNSaveRequest new];
            CNMutableContact *updatedFrameworkContact = [self.converter updatedFrameworkContact:ADNonnull(frameworkContact) fromContact:contact];
            [updateRequest updateContact:updatedFrameworkContact];
            NSError *error;
            if ([self executeSaveRequest:updateRequest error:&error]) {
                ADPerformBlock(callback, [self.converter contactFromFrameworkContact:updatedFrameworkContact], nil);
            } else {
                ADPerformBlock(callback, nil, error);
            }
        }
    }];
}

- (void)addContact:(ADContact *)contact withCallback:(ADContactsManagerAddBlock)callback {
    if(!contact){
        NSParameterAssert(contact);
        ADPerformBlock(callback, nil, [ADContactsManagerError validationErrorForParameterName:@"contact" value:contact]);
        return;
    }
    
    CNMutableContact *frameworkContact = [[self.converter frameworkContactFromContact:contact] mutableCopy];
    CNSaveRequest *addRequest = [CNSaveRequest new];
    [addRequest addContact:frameworkContact toContainerWithIdentifier:nil];

    NSError *error;
    if ([self executeSaveRequest:addRequest error:&error]) {
        ADPerformBlock(callback, contact, nil);
    } else {
        ADPerformBlock(callback, nil, error);
    }
}

- (void)deleteContact:(ADContact *)contact withCallback:(ADContactsManagerDeleteBlock)callback {
    if(!contact){
        NSParameterAssert(contact);
        ADPerformBlock(callback, NO, [ADContactsManagerError validationErrorForParameterName:@"contact" value:contact]);
        return;
    }
    
    ADContactsFieldMask *fieldsMask = [[ADContactsFieldMask alloc] initWithFields:ADContactFieldFirstName];
    [self getContactWithIdentifier:contact.contactID fieldsMask:fieldsMask callback:^(CNContact *_Nullable contact, NSError *_Nullable error) {
        if (error || !contact) {
            ADPerformBlock(callback, NO, error);
        } else {
            CNSaveRequest *deleteRequest = [CNSaveRequest new];
            [deleteRequest deleteContact:ADNonnull([contact mutableCopy])];
            NSError *error;
            if ([self executeSaveRequest:deleteRequest error:&error]) {
                ADPerformBlock(callback, YES, nil);
            } else {
                ADPerformBlock(callback, NO, error);
            }
        }
    }];
}

- (void)getContactsWithCallback:(ADContactsManagerGetBlock)callback {
    ADContactsFieldMask *fieldsMask = [[ADContactsFieldMask alloc] initWithFields:ADContactFieldAll];
    [self getContacts:fieldsMask withCallback:callback];
}

- (void)getContactsCountWithCallback:(ADContactsManagerCountBlock)callback {
    ADContactsManagerAccessStatus accessStatus = self.accessStatus;
    switch (accessStatus) {
        case ADContactsManagerAccessStatusNotDetermined:
        case ADContactsManagerAccessStatusDenied:
        case ADContactsManagerAccessStatusRestricted: {
            NSError *error = [ADContactsManagerError errorWithCode:ADContactsManagerErrorCodeContactsFrameworkError message:NSLocalizedString(@"Please allow the app to access your contacts through the Settings.", @"Please allow the app to access your contacts through the Settings.") underlineError:nil];
            ADPerformBlock(callback, 0, error);
            break;
        }
        case ADContactsManagerAccessStatusAuthorized: {
            NSUInteger __block contactsCount = 0;
            CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:@[CNContactIdentifierKey]];
            NSError *fetchError = nil;
            [self.contactsStore enumerateContactsWithFetchRequest:request error:&fetchError usingBlock:^(CNContact *_Nonnull contact, BOOL *_Nonnull stop) {
                contactsCount++;
            }];
            if (fetchError) {
                NSError *error = [ADContactsManagerError errorWithCode:ADContactsManagerErrorCodeContactsFrameworkError message:NSLocalizedString(@"Uh oh. Something went wrong", @"Uh oh. Something went wrong") underlineError:nil];
                ADPerformBlock(callback, 0, error);
            } else {
                ADPerformBlock(callback, contactsCount, nil);
            }
            break;
        }
    }
}

#pragma mark - Helpers

- (void)getContactWithIdentifier:(NSString *)identifier fieldsMask:(ADContactsFieldMask *)fieldsMask callback:(nullable void (^)(CNContact *__nullable contact, NSError *__nullable error))callback {
    ADContactsManagerAccessStatus accessStatus = self.accessStatus;
    switch (accessStatus) {
        case ADContactsManagerAccessStatusNotDetermined:
        case ADContactsManagerAccessStatusDenied:
        case ADContactsManagerAccessStatusRestricted: {
            ADPerformBlock(callback, nil, [ADContactsManagerError errorWithCode:ADContactsManagerErrorCodeContactsFrameworkError message:NSLocalizedString(@"Please allow the app to access your contacts through the Settings.", @"Please allow the app to access your contacts through the Settings.") underlineError:nil]);
            return;
        }
        case ADContactsManagerAccessStatusAuthorized: {
            break;
        }
    }
    
    if (!identifier) {
        ADPerformBlock(callback, nil, [ADContactsManagerError errorWithCode:ADContactsManagerErrorCodeValidationError message:@"identifier can not be nil" underlineError:nil]);
        return;
    }
    
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:fieldsMask.fieldsArray];
    request.predicate = [CNContact predicateForContactsWithIdentifiers:@[identifier]];
    CNContact __block *foundContact = nil;
    NSError *fetchError = nil;
    [self.contactsStore enumerateContactsWithFetchRequest:request error:&fetchError usingBlock:^(CNContact *_Nonnull contact, BOOL *_Nonnull stop) {
        foundContact = contact;
        if (stop) {
            *stop = YES;
        }
    }];
    ADPerformBlock(callback, foundContact, fetchError);
}

- (BOOL)executeSaveRequest:(CNSaveRequest *)request error:(NSError *__autoreleasing *_Nullable)error {
    if (!request) {
        [ADContactsManagerUtilities error:error setError:[ADContactsManagerError validationErrorForParameterName:@"request" value:request]];
        return NO;
    }

    ADContactsManagerAccessStatus accessStatus = self.accessStatus;
    switch (accessStatus) {
        case ADContactsManagerAccessStatusNotDetermined:
        case ADContactsManagerAccessStatusDenied:
        case ADContactsManagerAccessStatusRestricted: {
            [ADContactsManagerUtilities error:error setError:[ADContactsManagerError errorWithCode:ADContactsManagerErrorCodeContactsFrameworkError message:NSLocalizedString(@"Please allow the app to access your contacts through the Settings.", @"Please allow the app to access your contacts through the Settings.") underlineError:nil]];
            return NO;
        }
        case ADContactsManagerAccessStatusAuthorized: {
            return [self.contactsStore executeSaveRequest:request error:error];
        }
    }
}

- (void)getContacts:(ADContactsFieldMask *)fieldsMask withCallback:(ADContactsManagerGetBlock)callback {
    ADContactsManagerAccessStatus accessStatus = self.accessStatus;
    switch (accessStatus) {
        case ADContactsManagerAccessStatusNotDetermined:
        case ADContactsManagerAccessStatusDenied:
        case ADContactsManagerAccessStatusRestricted: {
            NSError *error = [ADContactsManagerError errorWithCode:ADContactsManagerErrorCodeContactsFrameworkError message:NSLocalizedString(@"Please allow the app to access your contacts through the Settings.", @"Please allow the app to access your contacts through the Settings.") underlineError:nil];
            ADPerformBlock(callback, nil, error);
            break;
        }
        case ADContactsManagerAccessStatusAuthorized: {
            NSMutableArray<CNContact *> *frameworkContactsArray = [NSMutableArray array];
            CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:fieldsMask.fieldsArray];
            NSError *fetchError = nil;
            [self.contactsStore enumerateContactsWithFetchRequest:request error:&fetchError usingBlock:^(CNContact *_Nonnull contact, BOOL *_Nonnull stop) {
                [frameworkContactsArray addObject:contact];
            }];
            if (fetchError) {
                NSError *error = [ADContactsManagerError errorWithCode:ADContactsManagerErrorCodeContactsFrameworkError message:NSLocalizedString(@"Uh oh. Something went wrong", @"Uh oh. Something went wrong") underlineError:nil];
                ADPerformBlock(callback, nil, error);
            } else {
                NSMutableArray<ADContact *> *contactsArray = [NSMutableArray array];
                for (CNContact *frameworkContact in frameworkContactsArray) {
                    [contactsArray addObject:[self.converter contactFromFrameworkContact:frameworkContact]];
                }
                ADPerformBlock(callback, [contactsArray copy], nil);
            }
            break;
        }
    }
}

@end
