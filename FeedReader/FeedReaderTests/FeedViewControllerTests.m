//
//  FeedViewControllerTests.m
//  FeedReader
//
//  Created by Dave on 2013-06-19.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "FeedViewControllerTests.h"
#import "FeedViewController.h"
#import <OCMock/OCMock.h>

@implementation FeedViewControllerTests
{
    FeedViewController * viewController;
}

- (void)setUp
{
    viewController = [[FeedViewController alloc] initWithNibName:@"FeedViewController" bundle:nil];
}

- (void) testTitle {
    // given
    [viewController view];
    
    // then
    STAssertEqualObjects(viewController.title, @"Edit Feed", nil);
}

- (void) testNameField {
    // given
    [viewController view];
    
    // then
    STAssertNotNil(viewController.name, nil);
    STAssertEqualObjects(viewController.name.text, @"", nil);
}

- (void) testUrlField {
    // given
    [viewController view];
    
    // then
    STAssertNotNil(viewController.url, nil);
    STAssertEqualObjects(viewController.url.text, @"", nil);
}

- (void) testNameAndUrlFieldsArePopulatedWithFeedData {
    // given
    Feed * feed = [[Feed alloc] initWithName:@"Name" url:@"Url"];
    viewController.feed = feed;
    [viewController view];
    
    // then
    STAssertEqualObjects(viewController.name.text, feed.name, nil);
    STAssertEqualObjects(viewController.url.text, feed.url, nil);
}

- (void) testSaveButton {
    // given
    [viewController view];
    
    // then
    UIButton * button = viewController.saveButton;
    STAssertNotNil(button, @"saveButton is not defined");
    NSArray * array = [button actionsForTarget:viewController forControlEvent:UIControlEventTouchUpInside];
    STAssertTrue([array containsObject:@"save:"], @"saveButton must be bound correctly");
}

- (void) testCancelButton {
    // given
    [viewController view];
    
    // then
    UIButton * button = viewController.cancelButton;
    STAssertNotNil(button, @"cancelButton is not defined");
    NSArray * array = [button actionsForTarget:viewController forControlEvent:UIControlEventTouchUpInside];
    STAssertTrue([array containsObject:@"cancel:"], @"cancelButton must be bound correctly");
}

- (void) testDidCreateFeed {
    // define the feed attributes
    NSString * name = @"theName";
    NSString * url = @"http://url";
    
    // load the view controller
    [viewController view];
    
    // define the delegate mock
    // didCreateFeed should be called
    id delegate = [OCMockObject mockForProtocol:@protocol(FeedViewControllerDelegate)];
    [[delegate expect] didCreateFeed:[OCMArg checkWithBlock:^BOOL(Feed * feed) {
        return [feed.name isEqualToString:name] && [feed.url isEqualToString:url];
    } ]];
    viewController.delegate = delegate;

    // enter the feed attributes into the view controller and save.
    viewController.name.text = name;
    viewController.url.text = url;
    [viewController save:nil];
    
    // confirm that didCreateFeed was called
    [delegate verify];
}

- (void) testDidModifyFeed {
    // create a basic feed
    Feed * feed = [[Feed alloc] initWithName:@"Name" url:@"Url"];
    viewController.feed = feed;
    
    // define the modified feed attributes
    NSString * aNewName = @"aNewName";
    NSString * aNewUrl = @"aNewUrl";
    
    // load the view controller
    [viewController view];
    
    // define the delegate mock
    // didModifyFeed should be called
    id delegate = [OCMockObject mockForProtocol:@protocol(FeedViewControllerDelegate)];
    [[delegate expect] didModifyFeed:[OCMArg checkWithBlock:^BOOL(Feed * feed) {
        return [feed.name isEqualToString:aNewName] && [feed.url isEqualToString:aNewUrl];
    } ]];
    viewController.delegate = delegate;
    
    // change the feed attributes int the view controller and save
    viewController.name.text = aNewName;
    viewController.url.text = aNewUrl;
    [viewController save:nil];
    
    // confirm that didModifyFeed was called
    [delegate verify];
}

@end
