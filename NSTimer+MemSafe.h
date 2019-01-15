//
//  NSTimer+MemSafe.h
//  asaddadws
//
//  Created by yulei pang on 2019/1/7.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (MemSafe)
+ (NSTimer *)pyl_scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo;
@end
