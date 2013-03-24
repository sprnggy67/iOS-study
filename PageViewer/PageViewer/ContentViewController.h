//
//  ContentViewController.h
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

@interface ContentViewController : UIViewController <UIWebViewDelegate> {
    IBOutlet UIWebView * webView;
    @private
    Article * article;
    WebViewDelegate * webViewDelegate;
    TemplateFactory * templateFactory;
}

@property (strong, nonatomic) IBOutlet UIWebView * webView;
@property (strong, nonatomic) Article * article;
@property (strong, nonatomic) TemplateFactory * templateFactory;

@end

