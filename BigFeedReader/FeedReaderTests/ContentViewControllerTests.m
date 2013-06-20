//
//  ContentViewControllerTests.m
//  FeedReader
//
//  Created by Dave on 2013-06-19.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "ContentViewControllerTests.h"
#import "ContentViewController.h"
#import "ArticleTests.h"
#import <OCMock/OCMock.h>
#import "TestUtils.h"

@implementation ContentViewControllerTests
{
    ContentViewController * viewController;
    Article * article;
    TemplateFactory * templateFactory;
}

-(void)setUp
{
    // Create an article
    article = [ArticleTests createArticle:@"Headline" template:@"Template3" standFirst:@"Standfirst" body:@"Body"];
    
    // Create a template factory
    templateFactory = [[TemplateFactory alloc] initWithBundle:[NSBundle bundleForClass:[self class]]];
    
    // Create the content view controller
    viewController = [[ContentViewController alloc]
                      initWithNibName:@"ContentViewController"
                      bundle:nil];
    [viewController setArticle:article];
    [viewController setTemplateFactory:templateFactory];
}

-(void)testTitle
{
    // when
    [viewController view];
    
    // then
    STAssertEqualObjects(viewController.title, @"Article", nil);
}

-(void)testWebViewContent
{
    // when
    [viewController view];
    [viewController viewWillAppear:FALSE];
    
    // wait for the web view to load
    Wait(1);
    
    // then
    UIWebView * webView = [viewController webView];
    STAssertNotNil(webView, nil);
    NSString * html = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
    STAssertEqualObjects(html, @"<html><head></head><body>Hello World</body></html>", nil);
}


@end
