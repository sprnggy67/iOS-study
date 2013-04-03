//
//  ContentViewController.m
//  PageViewer
//
//  Created by Dave on 2013-03-02.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIWebView.h>
#import "WebViewDelegate.h"
#import "TemplateFactory.h"
#import "Template.h"
#import "Article.h"

// A controller for article content.
@interface ContentViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView * webView;
@property (strong, nonatomic) Article * article;
@property (strong, nonatomic) TemplateFactory * templateFactory;


@end

