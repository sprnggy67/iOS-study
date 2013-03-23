//
//  WebViewDelegate.m
//  PageViewer
//
//  Created by Dave on 2013-03-22.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "WebViewDelegate.h"

@implementation WebViewDelegate

@synthesize webView;

-(id)initWith:(UIWebView *)view {
    [self setWebView:view];
    return self;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSURL *url = [request URL];
    NSString *urlStr = url.absoluteString;
    return [self processURL:urlStr];
}

- (BOOL) processURL:(NSString *) url
{
    NSString *urlStr = [NSString stringWithString:url];
    
    NSString *protocolPrefix = @"js2ios://";
    
    // process only our custom protocol
    if ([[urlStr lowercaseString] hasPrefix:protocolPrefix])
    {
        // strip protocol from the URL. We will get input to call a native method
        urlStr = [urlStr substringFromIndex:protocolPrefix.length];
        
        // Decode the url string
        urlStr = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSError *jsonError;
        
        // parse JSON input in the URL
        NSDictionary *callInfo = [NSJSONSerialization
                                  JSONObjectWithData:[urlStr dataUsingEncoding:NSUTF8StringEncoding]
                                  options:kNilOptions
                                  error:&jsonError];
        
        // check if there was error in parsing JSON input
        if (jsonError != nil)
        {
            NSLog(@"Error parsing JSON for the url %@",url);
            return NO;
        }
        
        // Get function name. It is a required input
        NSString *functionName = [callInfo objectForKey:@"functionname"];
        if (functionName == nil)
        {
            NSLog(@"Missing function name");
            return NO;
        }
        
        NSString *successCallback = [callInfo objectForKey:@"success"];
        NSString *errorCallback = [callInfo objectForKey:@"error"];
        NSArray *argsArray = [callInfo objectForKey:@"args"];
        
        [self callNativeFunction:functionName withArgs:argsArray onSuccess:successCallback onError:errorCallback];
        
        // Do not load this url in the WebView
        return NO;
        
    }
    
    return YES;
}

- (void) callNativeFunction:(NSString *) name withArgs:(NSArray *) args onSuccess:(NSString *) successCallback onError:(NSString *) errorCallback
{
    if ([name compare:@"log" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        if (args != NULL)
        {
            NSLog(@"UIWebView log: %@", args);
        }
        else
        {
            NSString *resultStr = [NSString stringWithFormat:@"Error calling function %@. Error : Missing argument", name];
            [self callErrorCallback:errorCallback withMessage:resultStr];
            NSLog(@"UIWebView log: %@", resultStr);
        }
    }
    else
    {
        //Unknown function called from JavaScript
        NSString *resultStr = [NSString stringWithFormat:@"Cannot process function %@. Function not found", name];
        [self callErrorCallback:errorCallback withMessage:resultStr];
        NSLog(@"UIWebView delegate: %@", resultStr);
    }
}

-(void) callSuccessCallback:(NSString *) name withRetValue:(id) retValue forFunction:(NSString *) funcName
{
    if (name != nil)
    {
        //call succes handler
        
        NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
        [resultDict setObject:retValue forKey:@"result"];
        [self callJSFunction:name withArgs:resultDict];
    }
    else
    {
        NSLog(@"Result of function %@ = %@", funcName,retValue);
    }
    
}
-(void) callErrorCallback:(NSString *) name withMessage:(NSString *) msg
{
    if (name != nil)
    {
        //call error handler
        
        NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
        [resultDict setObject:msg forKey:@"error"];
        [self callJSFunction:name withArgs:resultDict];
    }
    else
    {
        NSLog(@"%@",msg);
    }
    
}

-(void) callJSFunction:(NSString *) name withArgs:(NSMutableDictionary *) args
{
    NSError *jsonError;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:args options:0 error:&jsonError];
    
    if (jsonError != nil)
    {
        //call error callback function here
        NSLog(@"Error creating JSON from the response  : %@",[jsonError localizedDescription]);
        return;
    }
    
    //initWithBytes:length:encoding
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"jsonStr = %@", jsonStr);
    
    if (jsonStr == nil)
    {
        NSLog(@"jsonStr is null. count = %d", [args count]);
    }
    
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@('%@');",name,jsonStr]];
}

@end
