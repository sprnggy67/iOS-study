//
//  WebViewDelegate.h
//  PageViewer
//
//  Created by Dave on 2013-03-22.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIWebView.h>
#import "NavigationDelegate.h"

// A bridge between the web and native layers, supporting communication in both directions
@interface WebViewDelegate : NSObject <UIWebViewDelegate>

@property (nonatomic, weak) id <NavigationDelegate> navigationDelegate;

-(id)initWith:(UIWebView *)webView;


@end
