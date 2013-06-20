//
//  WebViewDelegateTests.m
//  FeedReader
//
//  Created by Dave on 2013-06-18.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "WebViewDelegateTests.h"
#import "WebViewDelegate.h"
#import "NavigationDelegate.h"
#import <OCMock/OCMock.h>
#import <UIKit/UIWebView.h>

@interface WebViewDelegate (Tests)

-(void)log:(NSString *) args;
-(void)logv:(NSString *) args, ...;
-(void)navigateTo:(NSString *) args;
-(void)time:(NSString *) args;
-(void)timeEnd:(NSString *) args onError:(NSString *) errorCallback;

@end

@implementation WebViewDelegateTests
{
    WebViewDelegate * webViewDelegate;
    id mockWebView;
    BOOL logvIsGood;
}

-(void)setUp
{
    mockWebView = [OCMockObject mockForClass:[UIWebView class]];
    webViewDelegate = [[WebViewDelegate alloc] initWith:mockWebView];
}

-(void)testLog
{
    // given
    NSString * helloWorld = @"Hello World";
    id wrap = [OCMockObject partialMockForObject:webViewDelegate];
    [[wrap expect] logv:@"UIWebViewDelegate.log: %@", helloWorld];
    
    // when
    [self loadRequest:@"log" args: helloWorld];
    
    // then
    [wrap verify];
}

-(void)loadRequest:(NSString *)functionName args:(NSString *) args
{
    NSString * string = [NSString stringWithFormat:@"js2ios://{\"functionname\":\"%@\",\"args\":\"%@\"}", functionName, args];
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:string]];
    [webViewDelegate webView:mockWebView shouldStartLoadWithRequest:request navigationType:UIWebViewNavigationTypeOther];
}

-(void)testTime
{
    // given
    NSString * helloWorld = @"Hello World";
    id wrap = [OCMockObject partialMockForObject:webViewDelegate];
    [[wrap expect] logv:@"UIWebViewDelegate.time: %@", helloWorld];
    
    // when
    [self loadRequest:@"time" args:helloWorld];
    
    // then
    [wrap verify];
}

-(void)testTimeEnd
{
    // start a timer
    NSString * helloWorld = @"Hello World";
    [self loadRequest:@"time" args:helloWorld];

    // get ready to end the timer
    id wrap = [OCMockObject partialMockForObject:webViewDelegate];
    [[[wrap stub] andCall:@selector(verifyLogv:) onObject:self] logv:[OCMArg any]];

    // end the timer
    [self loadRequest:@"timeEnd" args:helloWorld];
    
    // confirm the output
    STAssertTrue(logvIsGood, @"timeEnd was not called correctly");
}

-(void)verifyLogv:(NSString *)format, ...
{
    // TODO: Confirm that the timer name and value are logged as well.
    NSRange range = [format rangeOfString:@"UIWebViewDelegate.timeEnd:"];
    if (range.location == NSNotFound)
        logvIsGood = FALSE;
    else
        logvIsGood = TRUE;
}

-(void)testNavigateTo
{
    // given
    NSString * helloWorld = @"Hello World";    
    id navDelegate = [OCMockObject mockForProtocol:@protocol(NavigationDelegate)];
    [[navDelegate expect] navigateTo:helloWorld];
    webViewDelegate.navigationDelegate = navDelegate;
    
    // when
    [self loadRequest:@"navigateTo" args:helloWorld];
    
    // then
    [navDelegate verify];
}


@end
