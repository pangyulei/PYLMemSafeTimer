//
//  NSTimer+MemSafe.m
//  asaddadws
//
//  Created by yulei pang on 2019/1/7.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import "NSTimer+MemSafe.h"

#define IgnorePerformSelectorWarning(code) \
    do { \
        _Pragma("clang diagnostic push") \
        _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
        code; \
        _Pragma("clang diagnostic pop") \
    } while (false)

@interface Middleware : NSObject
@property (nonatomic, weak) id aTarget;
@property (nonatomic, assign) SEL aSelector;
@end

@implementation Middleware

- (void)fire:(NSTimer *)sysTimer {
    if ([_aTarget respondsToSelector:_aSelector]) {
        IgnorePerformSelectorWarning(
            [_aTarget performSelector:_aSelector withObject:sysTimer];
        );
    } else if (sysTimer) {
        [sysTimer invalidate];
        sysTimer = nil;
    }
}

@end

@implementation NSTimer (MemSafe)

+ (NSTimer *)pyl_scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
    Middleware *middleware = [Middleware new];
    middleware.aTarget = aTarget;
    middleware.aSelector = aSelector;
    return [NSTimer scheduledTimerWithTimeInterval:ti
                                                        target:middleware selector:@selector(fire:) userInfo:userInfo
                                                       repeats:yesOrNo];
}

@end
