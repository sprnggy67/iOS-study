//
//  LoadViewControllerTests.m
//  FeedReader
//
//  Created by Dave on 2013-06-12.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "LoadViewControllerTests.h"
#import "LoadViewController.h"
#import <OCMock/OCMock.h>

@implementation LoadViewControllerTests

- (void) testViewBinding {
    LoadViewController *viewController = [[LoadViewController alloc] initWithNibName:@"LoadViewController" bundle:nil];

    [viewController loadView];

    STAssertNotNil(viewController.progressLabel, nil);
    STAssertNotNil(viewController.reloadButton, nil);
}

- (void) testActionBinding {
    LoadViewController *viewController = [[LoadViewController alloc] initWithNibName:@"LoadViewController" bundle:nil];

    [viewController loadView];

    UIButton * button = viewController.reloadButton;
    NSArray * array = [button actionsForTarget:viewController forControlEvent:UIControlEventTouchUpInside];

    STAssertEqualObjects([array objectAtIndex:0], @"reload:", @"reloadButton must be bound correctly");
}

- (void) testReadContentFeedsIsCalled
{
    LoadViewController *viewController = [[LoadViewController alloc] initWithNibName:@"LoadViewController" bundle:nil];

    id aMock = [OCMockObject partialMockForObject:viewController];
    [[aMock expect] readContentFeeds];

    UIView * view = viewController.view;
    NSLog(@"Loading %@", view);
    
    [aMock verify];
}

@end
