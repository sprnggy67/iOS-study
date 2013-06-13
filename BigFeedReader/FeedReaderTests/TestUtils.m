//
//  TestUtils.m
//  FeedReader
//
//  Created by Dave on 2013-06-13.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "TestUtils.h"

BOOL WaitFor(BOOL (^block)(void))
{
    NSTimeInterval start = [[NSProcessInfo processInfo] systemUptime];
    BOOL blockValue = block();
    while(!blockValue &&
          [[NSProcessInfo processInfo] systemUptime] - start <= 10)
    {
        [[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode beforeDate: [NSDate date]];
        blockValue = block();
    }
    return blockValue;
}


