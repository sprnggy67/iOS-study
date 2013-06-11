//
//  FeedTests.m
//  FeedReader
//
//  Created by Dave on 2013-06-11.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "FeedTests.h"
#import "Feed.h"

@implementation FeedTests

- (void)testInitWithName
{
    // Create test data.
    Feed * result = [[Feed alloc] initWithName:@"FeedOne" url:@"http://www.test.com/feed"];

    // Test the article.
    STAssertNotNil(result, @"initWithName returned nil");
}

- (void)testToDictionary
{
    // Create test data.
    Feed * feed = [[Feed alloc] initWithName:@"FeedOne" url:@"http://www.test.com/feed"];
    
    // Run the method
    NSDictionary * dictionary = [feed toDictionary];
    
    // Test the article.
    STAssertNotNil(dictionary, @"toDictionary returned nil");
}

- (void)testFeedFromDictionary
{
    // Create test data.
    Feed * feed = [[Feed alloc] initWithName:@"FeedOne" url:@"http://www.test.com/feed"];
    
    // Run the method
    NSDictionary * dictionary = [feed toDictionary];
    Feed * feed2 = [Feed feedFromDictionary:dictionary];
    
    // Test the article.
    STAssertNotNil(feed2, @"toDictionary returned nil");
    STAssertEqualObjects(feed2.name, feed.name, @"feed name is incorrect");
    STAssertEqualObjects(feed2.url, feed.url, @"feed url is incorrect");
}


@end
