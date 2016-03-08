//
//  ADContactsManagerMacros.h
//  ADContactsManager
//
//  Created by Anton Domashnev on 2/14/16.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

#define ADPerformBlock(block, ...) { \
        if (block) { \
            block(__VA_ARGS__); \
        } \
}

#define ADPerformBlockOnMainThread(block, ...) { \
        dispatch_async(dispatch_get_main_queue(), ^(void) { \
            if (block) { \
                block(__VA_ARGS__); \
            } \
        }); \
}

#define ADPerformBlockOnMainThreadAfterDelay(delay, block, ...) { \
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ \
            if (block) { \
                block(__VA_ARGS__); \
            } \
        }); \
}

#define ADPostNotificationOnMainThread(name, anObject, anUserInfo) { \
        if ([NSThread isMainThread]) { \
            [[NSNotificationCenter defaultCenter] postNotificationName:name object:anObject userInfo:anUserInfo]; \
        } \
        else { \
            ADPerformBlockOnMainThread (^{ \
                [[NSNotificationCenter defaultCenter] postNotificationName:name object:anObject userInfo:anUserInfo]; \
            }); \
        } \
}

#define ADNonnull(x) (id __nonnull)x