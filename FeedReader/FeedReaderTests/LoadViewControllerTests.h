//
//  LoadViewControllerTests.h
//  FeedReader
//
//  Created by Dave on 2013-06-12.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "FeedStore.h"

@interface LoadViewControllerTests : SenTestCase

- (FeedStore *) createTestableFeedStore;
- (void)addFeed:(NSString *) feedName toStore:(FeedStore *) store;

@end
