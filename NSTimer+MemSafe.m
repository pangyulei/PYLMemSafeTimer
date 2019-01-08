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

@interface MemSafeTimerMiddleware : NSObject
@property (nonatomic, weak) id aTarget;
@property (nonatomic, weak) NSTimer *aTimer;
@property (nonatomic, assign) SEL aSelector;
@end

@implementation MemSafeTimerMiddleware

- (void)fire:(NSTimer *)sysTimer {
    if (_aTarget && [_aTarget respondsToSelector:_aSelector]) {
        IgnorePerformSelectorWarning(
            [_aTarget performSelector:_aSelector withObject:sysTimer];
        );
    } else if (_aTimer) {
        [_aTimer invalidate];
        _aTimer = nil;
    }
}

- (void)dealloc {
    NSLog(@"MemSafeTimerMiddleware Dealloc");
}

@end

@implementation NSTimer (MemSafe)

+ (NSTimer *)memSafe_ScheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
    MemSafeTimerMiddleware *middleware = [MemSafeTimerMiddleware new];
    middleware.aTarget = aTarget;
    middleware.aSelector = aSelector;
    middleware.aTimer = [NSTimer scheduledTimerWithTimeInterval:ti
                                                        target:middleware selector:@selector(fire:) userInfo:userInfo
                                                       repeats:yesOrNo];
    return middleware.aTimer;
}

@end
