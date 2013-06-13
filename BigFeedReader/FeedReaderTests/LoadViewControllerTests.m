//
//  LoadViewControllerTests.m
//  FeedReader
//
//  Created by Dave on 2013-06-12.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "LoadViewControllerTests.h"
#import "LoadViewController.h"
#import "TestUtils.h"
#import <OCMock/OCMock.h>

@interface LoadViewController (Tests)

-(void)readContentFeeds;
-(void)didLoadArticles:(NSMutableArray *) articles sections:(NSMutableArray *)sections;
-(void)didDisplayContent;

@end

@implementation LoadViewControllerTests
{
    BOOL calledDidLoadArticles;
    BOOL calledDidDisplayContent;
}

- (void) testProgressLabelRef {
    // given
    LoadViewController *viewController = [[LoadViewController alloc] initWithNibName:@"LoadViewController" bundle:nil];
    [viewController view];

    // then
    STAssertNotNil(viewController.progressLabel, nil);
}

- (void) testReloadButtonRef {
    // given
    LoadViewController *viewController = [[LoadViewController alloc] initWithNibName:@"LoadViewController" bundle:nil];
    [viewController view];
    
    // then
    STAssertNotNil(viewController.reloadButton, nil);
}

- (void) testReloadButtonAction {
    // given
    LoadViewController *viewController = [[LoadViewController alloc] initWithNibName:@"LoadViewController" bundle:nil];
    [viewController view];

    // then
    UIButton * button = viewController.reloadButton;
    NSArray * array = [button actionsForTarget:viewController forControlEvent:UIControlEventTouchUpInside];
    STAssertTrue([array containsObject:@"reload:"], @"reloadButton must be bound correctly");
}

- (void) testReadContentFeedsIsCalled
{
    // given
    LoadViewController *viewController = [[LoadViewController alloc] initWithNibName:@"LoadViewController" bundle:nil];
    id aMock = [OCMockObject partialMockForObject:viewController];
    [[aMock expect] readContentFeeds];

    // when
    [viewController view];
    
    // then
    [aMock verify];
}

- (void) testDidLoadArticlesIsCalled
{
    // given
    LoadViewController *viewController = [[LoadViewController alloc] initWithNibName:@"LoadViewController" bundle:nil];
    id aMock = [OCMockObject partialMockForObject:viewController];
    [[[aMock stub] andCall:@selector(didLoadArticles:sections:) onObject:self] didLoadArticles:[OCMArg any] sections:[OCMArg any] ];
    
    // when
    [viewController view];
    WaitFor(^BOOL(void) { return calledDidLoadArticles; }, 10);
    
    // then
    STAssertTrue(calledDidLoadArticles, nil);
}

- (void) testDisplayContent
{
    // given
    LoadViewController *viewController = [[LoadViewController alloc] initWithNibName:@"LoadViewController" bundle:nil];
    id aMock = [OCMockObject partialMockForObject:viewController];
    [[[aMock stub] andCall:@selector(didDisplayContent) onObject:self] didDisplayContent];
    // when
    [viewController view];
    WaitFor(^BOOL(void) { return calledDidDisplayContent; }, 10);
    
    // then
    STAssertTrue(calledDidDisplayContent, nil);
}

- (void)didLoadArticles:(NSMutableArray *)articleList sections:(NSMutableArray *)sectionList
{
    calledDidLoadArticles = TRUE;
}

- (void)didDisplayContent {
    calledDidDisplayContent = TRUE;
}



@end
