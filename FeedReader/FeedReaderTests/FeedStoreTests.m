//
//  FeedStoreTests.m
//  FeedReader
//
//  Created by Dave on 2013-06-11.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "FeedStoreTests.h"

@implementation FeedStoreTests

@synthesize feedStore;

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    self.feedStore = [FeedStore testable:@"FeedStoreTests.plist"];
}

- (void)tearDown
{
    // Tear-down code here.
    self.feedStore = nil;
    
    [super tearDown];
}

- (void)testSingleton
{
    FeedStore * singleton = [FeedStore singleton];
    STAssertNotNil(singleton, @"singleton is nil");
}

- (void)testTestable
{
    FeedStore * testable = [FeedStore testable:@"Testable.plist"];
    STAssertNotNil(testable, @"testable returned nil");
}

- (void)testSetup
{
    STAssertNotNil(feedStore, @"setup returned nil");
    STAssertTrue([feedStore isEmpty], @"feedStore must be empty");
}

- (void)testAdd
{
    Feed * feed = [[Feed alloc] initWithName:@"TestFeed" url:@"TestURL"];
    [feedStore add:feed];
    
    STAssertEquals([feedStore count], 1, @"feedStore count should be 1");
    
    Feed * actualFeed = [[feedStore feeds]objectAtIndex:0];
    
    STAssertEquals(actualFeed, feed, @"feedStore at 0 must match");
}

- (void)testCount
{
    [feedStore add:[[Feed alloc] initWithName:@"TestFeed1" url:@"TestURL"]];
    [feedStore add:[[Feed alloc] initWithName:@"TestFeed2" url:@"TestURL"]];
    [feedStore add:[[Feed alloc] initWithName:@"TestFeed3" url:@"TestURL"]];
    
    STAssertEquals([feedStore count], 3, @"feedStore count should be 3");
}

- (void)testRemove
{
    Feed * feed = [[Feed alloc] initWithName:@"TestFeed" url:@"TestURL"];
    [feedStore add:feed];
    [feedStore remove:feed];
    
    STAssertEquals([feedStore count], 0, @"feedStore count should be 0");
    STAssertTrue([feedStore isEmpty], @"feedStore must be empty");
}

- (void)testRemoveAll
{
    Feed * feed = [[Feed alloc] initWithName:@"TestFeed" url:@"TestURL"];
    [feedStore add:feed];
    [feedStore removeAll];
    
    STAssertEquals([feedStore count], 0, @"feedStore count should be 0");
    STAssertTrue([feedStore isEmpty], @"feedStore must be empty");
}




@end
