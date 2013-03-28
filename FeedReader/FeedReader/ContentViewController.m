//
//  ContentViewController.m
//  PageViewer
//
//  Created by Dave on 2013-03-02.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "ContentViewController.h"
#import "WebViewDelegate.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

@synthesize webView, article, templateFactory;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Set the web view delegate
    webViewDelegate = [[WebViewDelegate alloc] initWith:webView];
    [webView setDelegate:webViewDelegate];
}

// Loads the article into the webView.
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Get the article template
    NSString * templateName = [article templateName];
    Template * template = [templateFactory template:templateName];
    if (template == nil) {
        NSLog(@"Could not load template: %@", templateName);
        [webView loadHTMLString:@"Could not load template"
                        baseURL:[NSURL URLWithString:@""]];
        return;
    }

    // Inject the article data into the template and display it.
    NSString * contents = [template load:[article jsonData]];
    NSString * path = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/Templates"];
    NSURL * pathURL = [NSURL fileURLWithPath:path];
    [webView loadHTMLString:contents
                    baseURL:pathURL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
