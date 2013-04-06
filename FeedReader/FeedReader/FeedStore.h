//
//  FeedStore.h
//  FeedReader
//
//  Created by Dave on 2013-04-04.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Feed.h"

@interface FeedStore : NSObject

+ (FeedStore *) singleton;

- (NSArray *)feeds;
- (int)count;
- (BOOL)isEmpty;

- (void) add:(Feed *)feed;
- (void) remove:(Feed *)feed;

-(void)write;

@end
