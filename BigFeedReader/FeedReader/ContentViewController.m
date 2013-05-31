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

@property (strong, nonatomic) WebViewDelegate * webViewDelegate;

@end

@implementation ContentViewController

@synthesize webView;
@synthesize article;
@synthesize templateFactory;
@synthesize webViewDelegate;
@synthesize navigationDelegate;
@synthesize loaded;

#pragma mark - Init

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
    NSLog(@"ContentViewController.viewDidLoad called");
    
    [super viewDidLoad];
    self.title = @"Article";
    
    // Set the web view delegate
    self.webViewDelegate = [[WebViewDelegate alloc] initWith:webView];
    [webViewDelegate setNavigationDelegate:navigationDelegate];
    [webView setDelegate:webViewDelegate];
}

// Loads the article into the webView.
- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"ContentViewController.viewWillAppear: called");
    [super viewWillAppear:animated];
    
    // Short circuit.
    if (self.loaded)
        return;
    self.loaded = true;
    
    // Get the article template
    NSString * templateName = [article templateName];
    NSLog(@"ContentViewController.viewWillAppear: Loading template: %@", templateName);
    NSString * subTemplateName = [article subTemplateName];
    Template * template = [templateFactory template:templateName];
    if (template == nil) {
        NSLog(@"Could not load template: %@", templateName);
        [webView loadHTMLString:@"Could not load template"
                        baseURL:[NSURL URLWithString:@""]];
        return;
    }

    // Inject the article data into the template
    NSLog(@"ContentViewController.viewWillAppear: Injecting content into template");
    NSString * contents = [template load:[article jsonData] subTemplate:subTemplateName];
    NSString * path = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/Templates"];
    NSURL * pathURL = [NSURL fileURLWithPath:path];
    
    // Display the content.
    NSLog(@"ContentViewController.viewWillAppear: Loading content into webView");
    [webView loadHTMLString:contents
                    baseURL:pathURL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
