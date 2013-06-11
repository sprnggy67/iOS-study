//
//  FeedStore.h
//
//  Stores and manages the list of feeds.
//
//  Created by Dave on 2013-04-04.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Feed.h"

@interface FeedStore : NSObject

/*
 Returns the single feed store. 
 */
+ (FeedStore *)singleton;

/*
 Returns a testable store.
 pListName must contain a file name of the form "x.plist".
 */
+ (FeedStore *)testable:(NSString *)plistName;

/**
 Returns the feed list
 */

- (NSArray *)feeds;

/**
 Returns the feed count
 */
- (int)count;

/**
 Returns true if the feed store is empty
 */
- (BOOL)isEmpty;

/**
 Adds a feed to the store, and writes it to storage
 */
- (void)add:(Feed *)feed;

/**
 Removes a feed from the store, and writes it to storage
 */

- (void)remove:(Feed *)feed;

/**
 Removes all of the feeds from the store, and writes it to storage
 */
- (void)removeAll;

/**
 Writes the store to storage
 */
-(void)write;

@end
