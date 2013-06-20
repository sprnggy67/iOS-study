//
//  ArticleTableViewControllerTests.m
//  FeedReader
//
//  Created by Dave on 2013-06-14.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "ArticleTableViewControllerTests.h"
#import "RSSNewsDataFactory.h"
#import "FeedTableViewController.h"
#import "MainViewController.h"
#import <OCMock/OCMock.h>

@interface ArticleTableViewController (Tests)

-(void)menuButtonPressed:(id)parameter;

@end

@implementation ArticleTableViewControllerTests
{
    ArticleTableViewController * viewController;
    NSMutableArray * articleList;
}

- (void)setUp
{
    viewController = [[ArticleTableViewController alloc] initWithStyle:UITableViewStylePlain];
    articleList = [self createArticleList];
    viewController.articleList = articleList;
}

- (NSMutableArray *)createArticleList {
    NSArray *result = nil;
    RSSNewsDataFactory * factory = [[RSSNewsDataFactory alloc] init];
    result = [factory parseResource:@"RSSFeed1" fromBundle: [NSBundle bundleForClass:[self class]]];
    return [NSMutableArray arrayWithArray:result];
}

- (void)testTitle {
    // given
    [viewController view];
    
    // then
    STAssertEqualObjects(viewController.title, @"Articles", nil);
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
    STAssertEquals((int)[tableView numberOfRowsInSection:0], (int)[articleList count], nil);
}

- (void)testRowContent {
    // given
    [viewController view];
    [viewController viewWillAppear:FALSE];
    
    // then test each row
    UITableView * tableView = viewController.tableView;
    int articleCount = [articleList count];
    for (int x = 0; x < articleCount; x ++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:x inSection:0];
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        Article * article = [articleList objectAtIndex:x];
        STAssertEqualObjects(cell.textLabel.text, article.headline, nil);
        STAssertEqualObjects(cell.detailTextLabel.text, article.source, nil);
    }
}

- (void)testMenuButtonRef {
    // given
    [viewController view];
    
    // then
    STAssertNotNil(viewController.navigationItem.rightBarButtonItem, nil);
}

- (void) testMenuButtonAction {
    // when
    [viewController view];
    
    // then
    UIBarButtonItem * button = viewController.navigationItem.rightBarButtonItem;
    STAssertEquals(button.action, NSSelectorFromString(@"menuButtonPressed:"), nil);
}

- (void) testMenuButtonSelected {
    // given a navigation controller
    UINavigationController *navController = [[UINavigationController alloc] init];
    id navigationController = [OCMockObject partialMockForObject:navController];
    
    // push the SUT
    [navigationController pushViewController:viewController animated:NO];
    STAssertNotNil(viewController.navigationController, nil);
    
    // force the view to load
    [viewController view];
    
    // expect navigation
    [[navigationController expect] pushViewController:[OCMArg checkWithSelector:@selector(isFeedTableViewController:)onObject:self] animated:YES];
    
    // when the menu button is pressed
    [viewController menuButtonPressed:nil];
    
    // verify navigation
    [navigationController verify];
}

- (BOOL) isFeedTableViewController:(id)object
{
    return [object isKindOfClass:[FeedTableViewController class]];
}

- (void) testRowSelected {
    // given a navigation controller
    UINavigationController *navController = [[UINavigationController alloc] init];
    id navigationController = [OCMockObject partialMockForObject:navController];
    
    // push the SUT
    [navigationController pushViewController:viewController animated:NO];
    STAssertNotNil(viewController.navigationController, nil);
    
    // force the view to load
    [viewController view];
    
    // expect navigation
    [[navigationController expect] pushViewController:[OCMArg checkWithSelector:@selector(isMainViewController:)onObject:self] animated:YES];
    
    // when the first row is selected
    [viewController tableView:viewController.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    // verify navigation
    [navigationController verify];
}

- (BOOL) isMainViewController:(id)object
{
    return [object isKindOfClass:[MainViewController class]];
}


@end
