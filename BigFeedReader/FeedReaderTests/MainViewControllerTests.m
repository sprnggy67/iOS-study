//
//  MainViewControllerTests.m
//  FeedReader
//
//  Created by Dave on 2013-06-19.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "MainViewControllerTests.h"
#import "MainViewController.h"
#import "RSSNewsDataFactory.h"

@interface MainViewControllerTests (Helpers)

-(void)checkVisibleArticle:(int)articleIndex;

@end

@implementation MainViewControllerTests
{
    MainViewController * viewController;
    NSArray * articleList;
}

-(void)setUp
{
    // Read the article list.
    RSSNewsDataFactory * factory = [[RSSNewsDataFactory alloc] init];
    articleList = [factory parseResource:@"RSSFeed1" fromBundle: [NSBundle bundleForClass:[self class]]];
    
    // Open the content view controller
    viewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    viewController.articleList = articleList;
}

-(void)testTitle
{
    // when
    [viewController view];
    
    // then
    STAssertEqualObjects(viewController.title, @"In Detail", nil);
}

-(void)testArticle0IsVisibleByDefault
{
    // when
    [viewController view];
    
    // then
    [self checkVisibleArticle:0];
}

-(void)testSetFirstVisibleIndex
{
    // when
    int firstArticleIndex = 3;
    [viewController setFirstVisibleIndex:firstArticleIndex];
    [viewController view];
    
    // then
    [self checkVisibleArticle:firstArticleIndex];
}

-(void)checkVisibleArticle:(int)articleIndex
{
    STAssertEquals([viewController getVisibleIndex], articleIndex, nil);
    Article * expectedVisibleArticle = [articleList objectAtIndex:articleIndex];
    Article * actualVisibleArticle = [viewController getVisibleViewController].article;
    STAssertEqualObjects(actualVisibleArticle, expectedVisibleArticle, @"Incorrect article in ContentViewController");
}

-(void)testNavigateTo
{
    // initialise the view controller
    [viewController view];
    
    // navigate to the last article
    int nextArticleIndex = [articleList count] - 1;
    [viewController navigateTo:[[articleList objectAtIndex:nextArticleIndex] uniqueId]];
    
    // then
    [self checkVisibleArticle:nextArticleIndex];
}


@end
