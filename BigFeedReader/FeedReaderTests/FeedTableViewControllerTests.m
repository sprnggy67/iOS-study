//
//  FeedTableViewControllerTests.m
//  FeedReader
//
//  Created by Dave on 2013-06-17.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "FeedTableViewControllerTests.h"
#import "FeedTableViewController.h"
#import <OCMock/OCMock.h>

@interface FeedTableViewController (Tests)

-(void)openCreateVC:(id)parameter;

@end

@implementation FeedTableViewControllerTests
{
    FeedTableViewController * viewController;
    FeedStore * feedStore;
    Feed * feed1;
}

- (void)setUp
{
    viewController = [[FeedTableViewController alloc] initWithStyle:UITableViewStylePlain];
    feedStore = [FeedStore testable:@"FeedTableFeedStore.plist"];
    feed1 = [[Feed alloc] initWithName:@"TestFeed1" url:@"TestURL"];
    [feedStore add:feed1];
    [feedStore add:[[Feed alloc] initWithName:@"TestFeed2" url:@"TestURL"]];
    viewController.feedStore = feedStore;
}

- (void)testTitle {
    // given
    [viewController view];
    
    // then
    STAssertEqualObjects(viewController.title, @"Feeds", nil);
}

- (void)testSectionCount {
    // given
    [viewController view];
    
    // then
    UITableView * tableView = viewController.tableView;
    STAssertEquals((int)[tableView numberOfSections], 1, nil);
}

- (void)testRowCount {
    // given
    [viewController view];
    
    // then
    UITableView * tableView = viewController.tableView;
    STAssertEquals((int)[tableView numberOfRowsInSection:0], (int)[feedStore count], nil);
}

- (void)testRowContent {
    // given
    [viewController view];
    [viewController viewWillAppear:FALSE];
    
    // then test each row
    UITableView * tableView = viewController.tableView;
    NSArray * feeds = [feedStore feeds];
    int feedCount = [feeds count];
    for (int x = 0; x < feedCount; x ++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:x inSection:0];
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        Feed * feed = [feeds
                       objectAtIndex:x];
        STAssertEqualObjects(cell.textLabel.text, feed.name, nil);
    }
}

- (void)testAddButtonRef {
    // given
    [viewController view];
    
    // then
    STAssertNotNil(viewController.navigationItem.rightBarButtonItem, nil);
}

- (void) testAddButtonAction {
    // when
    [viewController view];
    
    // then
    UIBarButtonItem * button = viewController.navigationItem.rightBarButtonItem;
    STAssertEquals(button.action, NSSelectorFromString(@"openCreateVC:"), nil);
}

- (void)testMenuButtonSelected {
    // given a navigation controller
    id navController = [self createMockNavController];
    
    // force the view to load
    [viewController view];
    
    // expect navigation
    [[navController expect] pushViewController:[OCMArg checkWithSelector:@selector(isFeedViewController:)onObject:self] animated:YES];
    
    // when the menu button is pressed
    [viewController openCreateVC:nil];
    
    // verify navigation
    [navController verify];
}

- (id)createMockNavController
{
    // create a mock navigation controller
    UINavigationController * realController = [[UINavigationController alloc] init];
    id mockController = [OCMockObject partialMockForObject:realController];
    
    // push the SUT
    [mockController pushViewController:viewController animated:NO];
    STAssertNotNil(viewController.navigationController, nil);

    return mockController;
}

- (BOOL)isFeedViewController:(id)object
{
    return [object isKindOfClass:[FeedViewController class]];
}

- (void)testRowSelected {
    // create a mock navigation controller
    id navController = [self createMockNavController];
    
    // force the view to load
    [viewController view];
    
    // expect navigation
    [[navController expect] pushViewController:[OCMArg checkWithSelector:@selector(isFeedEditViewController:)onObject:self] animated:YES];
    
    // when the first row is selected
    [viewController tableView:viewController.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    // verify navigation
    [navController verify];
}

- (BOOL)isFeedEditViewController:(id)object
{
    if ([object isKindOfClass:[FeedViewController class]]) {
        FeedViewController * vc = (FeedViewController *)object;
        return (vc.feed != nil);
    }
    return false;
}

- (void)testDidCreateFeed {
    // given
    [viewController view];
    [viewController viewWillAppear:FALSE];
    
    // add a new feed to the vc
    Feed * newFeed = [[Feed alloc] initWithName:@"TestFeed3" url:@"TestURL"];
    [viewController didCreateFeed:newFeed];
    
    // confirm that a new row is displayed
    UITableView * tableView = viewController.tableView;
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    STAssertEqualObjects(cell.textLabel.text, @"TestFeed3", nil);
}

- (void)testDelegateDidModifyTableIsCalledWhenDidCreateFeed {
    // create a delegate mock
    id delegate = [self createMockDelegate];
    
    // modify the feed
    [self testDidCreateFeed];
    [viewController viewWillDisappear:TRUE];
    
    // confirm that didModifyTable was called
    [delegate verify];
}

-(id)createMockDelegate
{
    id delegate = [OCMockObject mockForProtocol:@protocol(FeedTableViewControllerDelegate)];
    [viewController setDelegate:delegate];
    [[delegate expect] didModifyTable:[OCMArg any]];
    return delegate;
}

- (void)testDidModifyFeed {
    // given
    [viewController view];
    [viewController viewWillAppear:FALSE];
    
    // modify feed 1 in the vc
    feed1.name = @"ModifiedName";
    [viewController didModifyFeed:feed1];
    
    // confirm that row 0 has been updated
    UITableView * tableView = viewController.tableView;
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    STAssertEqualObjects(cell.textLabel.text, @"ModifiedName", nil);
}

- (void)testDelegateDidModifyTableIsCalledWhenDidModifyFeed {
    // create a delegate mock
    id delegate = [self createMockDelegate];

    // modify the feed
    [self testDidModifyFeed];
    [viewController viewWillDisappear:TRUE];

    // confirm that didModifyTable was called
    [delegate verify];
}

- (void)testDeleteFeed {
    // given
    [viewController view];
    [viewController viewWillAppear:FALSE];
    
    // remove feed 1
    UITableView * tableView = viewController.tableView;
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [viewController tableView: tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
    
    // confirm that row 0 has been deleted
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    STAssertEqualObjects(cell.textLabel.text, @"TestFeed2", nil);
}

- (void)testDelegateDidModifyTableIsCalledWhenDidDeleteFeed {
    // create a delegate mock
    id delegate = [self createMockDelegate];
    
    // modify the feed
    [self testDeleteFeed];
    [viewController viewWillDisappear:TRUE];
    
    // confirm that didModifyTable was called
    [delegate verify];
}


@end
