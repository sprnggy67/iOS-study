//
//  WebViewDelegate.m
//  PageViewer
//
//  Created by Dave on 2013-03-22.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "WebViewDelegate.h"

@interface WebViewDelegate ()

@property (weak) UIWebView *webView;
@property (nonatomic, strong) NSMutableDictionary * timeDictionary;

- (void) onMissingArgument:(NSString *)name withArgs:(NSObject *) args onError:(NSString *) errorCallback;

@end

@implementation WebViewDelegate

@synthesize webView;
@synthesize navigationDelegate;

NSString *const PROTOCOL_PREFIX = @"js2ios://";

-(id)initWith:(UIWebView *)view {
    self = [super init];
    if (self) {
        self.webView = view;
        self.timeDictionary = [[NSMutableDictionary alloc] init];
    }
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
    
    // process only our custom protocol
    if ([[urlStr lowercaseString] hasPrefix:PROTOCOL_PREFIX])
    {
        // strip protocol from the URL. We will get input to call a native method
        urlStr = [urlStr substringFromIndex:PROTOCOL_PREFIX.length];
        
        // Decode the url string
        urlStr = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        // parse JSON input in the URL
        NSError *jsonError;
        NSDictionary *callInfo = [NSJSONSerialization
                                  JSONObjectWithData:[urlStr dataUsingEncoding:NSUTF8StringEncoding]
                                  options:kNilOptions
                                  error:&jsonError];
        if (callInfo == nil)
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
        NSObject * args = [callInfo objectForKey:@"args"];
        
        [self callNativeFunction:functionName withArgs:args onSuccess:successCallback onError:errorCallback];
        
        // Do not load this url in the WebView
        return NO;
    }
    
    return YES;
}

- (void) callNativeFunction:(NSString *) name withArgs:(NSObject *) args onSuccess:(NSString *) successCallback onError:(NSString *) errorCallback
{
    if ([name isEqualToString:@"log"]) {
        if (args != nil) {
            NSLog(@"UIWebView.log: %@", args);
        }  else {
            [self onMissingArgument:name withArgs:args onError:errorCallback];
        }
    } else if ([name isEqualToString:@"navigateTo"]) {
        if (args != nil) {
            if (navigationDelegate != nil) {
                [navigationDelegate navigateTo:(NSString *)args];
            }
        } else {
            [self onMissingArgument:name withArgs:args onError:errorCallback];
        }
    } else if ([name isEqualToString:@"time"]) {
        if (args != nil) {
            NSString * key = (NSString *) args;
            [self.timeDictionary setObject:[NSDate date] forKey:key];
            NSLog(@"UIWebView.time: %@", key);
        } else {
            [self onMissingArgument:name withArgs:args onError:errorCallback];
        }
    } else if ([name isEqualToString:@"timeEnd"]) {
        if (args != nil) {
            NSString * key = (NSString *) args;
            NSDate * startDate = [self.timeDictionary objectForKey:key];
            if (startDate != nil) {
                double timePassed_ms = [startDate timeIntervalSinceNow] * -1000.0;
                NSLog(@"UIWebView.timeEnd: %@ (%fms)", key, timePassed_ms);
                [self.timeDictionary removeObjectForKey:key];
            } else {
                [self onMissingArgument:name withArgs:args onError:errorCallback];
            }
        } else {
            [self onMissingArgument:name withArgs:args onError:errorCallback];
        }
    } else {
        //Unknown function called from JavaScript
        NSString *resultStr = [NSString stringWithFormat:@"Cannot process function %@. Function not found", name];
        [self callErrorCallback:errorCallback withMessage:resultStr];
        NSLog(@"UIWebView delegate: %@", resultStr);
    }
}

-(void) onMissingArgument:(NSString *)name withArgs:(NSObject *) args onError:(NSString *) errorCallback {
    NSString *resultStr = [NSString stringWithFormat:@"Error calling function %@. Error : Missing argument", name];
    [self callErrorCallback:errorCallback withMessage:resultStr];
    NSLog(@"UIWebView.log: %@", resultStr);
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
    
    if (jsonData == nil)
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
        NSLog(@"jsonStr is nil. count = %d", [args count]);
    }
    
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@('%@');",name,jsonStr]];
}

@end
