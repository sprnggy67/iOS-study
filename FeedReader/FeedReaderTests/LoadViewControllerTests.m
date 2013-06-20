//
//  LoadViewControllerTests.m
//  FeedReader
//
//  Created by Dave on 2013-06-12.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "LoadViewControllerTests.h"
#import "LoadViewController.h"
#import "ArticleTableViewController.h"
#import "TestUtils.h"
#import <OCMock/OCMock.h>

@interface LoadViewController (Tests)

-(void)didDisplayContent:(NSArray *)articleList with:(UIViewController *)vc;

@end

@implementation LoadViewControllerTests
{
    LoadViewController * viewController;
    BOOL calledDidDisplayContent;
    NSArray * callbackArticleList;
    UIViewController * callbackVC;
}

- (void)setUp
{
    viewController = [[LoadViewController alloc] initWithNibName:@"LoadViewController" bundle:nil];
    viewController.feedStore = [self createTestableFeedStore];
    calledDidDisplayContent = FALSE;
}

- (FeedStore *) createTestableFeedStore {
    FeedStore * feedStore = [FeedStore testable:@"FeedStoreTests.plist"];
    [self addFeed:@"RSSFeed2" toStore:feedStore];
    return feedStore;
}

- (void)addFeed:(NSString *) feedName toStore:(FeedStore *) store
{
    NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:feedName withExtension:@"rss"];
    [store add:[[Feed alloc] initWithName:feedName url:[url absoluteString]]];
}

- (void) testProgressLabelRef {
    // given
    [viewController view];

    // then
    STAssertNotNil(viewController.progressLabel, nil);
}

- (void) testReloadButtonRef {
    // when
    [viewController view];
    
    // then
    STAssertNotNil(viewController.reloadButton, nil);
}

- (void) testReloadButtonAction {
    // when
    [viewController view];

    // then
    UIButton * button = viewController.reloadButton;
    NSArray * array = [button actionsForTarget:viewController forControlEvent:UIControlEventTouchUpInside];
    STAssertTrue([array containsObject:@"reload:"], @"reloadButton must be bound correctly");
}

- (void) testDisplayContent
{
    // given
    id aMock = [OCMockObject partialMockForObject:viewController];
    [[[aMock stub] andCall:@selector(didDisplayContent:with:) onObject:self] didDisplayContent:[OCMArg any] with:[OCMArg any]];

    // when
    [viewController view];
    WaitFor(^BOOL(void) { return calledDidDisplayContent; }, 10);
    
    // then
    // confirm that the right articles have been loaded
    STAssertTrue(calledDidDisplayContent, nil);
    STAssertEquals((int)[callbackArticleList count], 3, nil);
    
    // confirm that the ArticleTableViewController is now active
    STAssertTrue([callbackVC isKindOfClass:[ArticleTableViewController class]], nil);
}

#pragma mark - Observer methods

- (void)didDisplayContent:(NSArray *)articleList with:(UIViewController *) vc
{
    calledDidDisplayContent = TRUE;
    callbackArticleList = articleList;
    callbackVC = vc;
}



@end
