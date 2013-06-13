//
//  FeedLoaderTests.m
//  FeedReader
//
//  Created by Dave on 2013-06-13.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "FeedLoaderTests.h"
#import "FeedLoader.h"
#import "FeedStore.h"
#import "Feed.h"
#import "TestUtils.h"
#import <OCMock/OCMock.h>

#pragma mark - tests

@implementation FeedLoaderTests
{
    FeedLoader * feedLoader;
    FeedStore * feedStore;
    
    BOOL calledDidProgress;
    BOOL calledDidLoadArticles;
    NSMutableArray * callbackArticleList;
    NSMutableArray * callbackSectionList;
}

- (void)setUp {
    feedLoader = [[FeedLoader alloc] init];
    feedStore = [FeedStore testable:@"Foo"];
    [feedStore removeAll];
}

- (void)testAllocInit
{
    STAssertNotNil(feedLoader, nil);
}

- (void)testReadZeroContentFeeds
{
    // when
    [feedLoader readContentFeeds:feedStore delegate:self];
    
    // then
    STAssertTrue(calledDidLoadArticles, nil);
}

- (void)addFeed:(NSString *) feedName toStore:(FeedStore *) store
{
    NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:feedName withExtension:@"rss"];
    [store add:[[Feed alloc] initWithName:feedName url:[url absoluteString]]];    
}

- (void)testReadOneContentFeeds
{
    // given
    [self addFeed:@"RSSFeed1" toStore:feedStore];
    
    // when
    [feedLoader readContentFeeds:feedStore delegate:self];
    
    // then
    WaitFor(^BOOL(void) { return calledDidLoadArticles; }, 10);
    STAssertTrue(calledDidLoadArticles, nil);
    STAssertEquals((int)[callbackSectionList count], 1, nil);
    STAssertEquals((int)[callbackArticleList count], 10, nil);
}

- (void)testReadTwoContentFeeds
{
    // given
    [self addFeed:@"RSSFeed1" toStore:feedStore];
    [self addFeed:@"RSSFeed2" toStore:feedStore];
    
    // when
    [feedLoader readContentFeeds:feedStore delegate:self];
    
    // then
    WaitFor(^BOOL(void) { return calledDidLoadArticles; }, 10);
    STAssertTrue(calledDidLoadArticles, nil);
    STAssertEquals((int)[callbackSectionList count], 2, nil);
    STAssertEquals((int)[callbackArticleList count], 11, nil);
}

#pragma mark - FeedLoaderDelegate

- (void)didProgress:(NSString *)str
{
    calledDidProgress = TRUE;
}

- (void)didLoadArticles:(NSMutableArray *)articleList sections:(NSMutableArray *)sectionList
{
    calledDidLoadArticles = TRUE;
    callbackSectionList = sectionList;
    callbackArticleList = articleList;
}


@end
