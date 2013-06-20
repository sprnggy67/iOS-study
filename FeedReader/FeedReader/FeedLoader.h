//
//  FeedLoader.h
// 
//  FeedLoader provides an algorithm to read a set of feeds defined in a feed store.
//
//  Created by Dave on 2013-06-12.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedStore.h"
#import "FeedLoaderDelegate.h"

@interface FeedLoader : NSObject

/*
 Loads each feed in the feed store one by one.
 Progress is passed back through the delegate.
 */
-(void)readContentFeeds:(FeedStore *) feedStore delegate:(id <FeedLoaderDelegate>) delegate;

@end
