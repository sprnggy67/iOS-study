//
//  TestUtils.h
//  FeedReader
//
//  Created by Dave on 2013-06-13.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <Foundation/Foundation.h>

BOOL WaitFor(BOOL (^block)(void), int seconds);

BOOL Wait(int seconds);

