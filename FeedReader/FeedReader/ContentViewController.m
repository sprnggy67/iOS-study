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

- (void)loadContent;

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
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }

    [self loadContent];

    NSLog(@"ContentViewController.viewDidLoad done");   
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"ContentViewController.viewWillAppear: called");

    [super viewWillAppear:animated];
    
//    [self loadContent];

    NSLog(@"ContentViewController.viewWillAppear: done");
}

// Loads the article into the webView.
- (void)loadContent
{
   // Short circuit.
    if (self.loaded)
        return;
    self.loaded = true;
    
    // Get the article template
    NSString * templateName = [article templateName];
    NSLog(@"ContentViewController.loadContent: Loading template: %@", templateName);
    NSString * subTemplateName = [article subTemplateName];
    Template * template = [templateFactory template:templateName];
    if (template == nil) {
        NSLog(@"Could not load template: %@", templateName);
        [webView loadHTMLString:@"Could not load template"
                        baseURL:[NSURL URLWithString:@""]];
        return;
    }

    // Inject the article data into the template
    NSLog(@"ContentViewController.loadContent: Injecting content into template");
    NSString * contents = [template load:[article jsonData] subTemplate:subTemplateName];
    NSString * path = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/Templates"];
    NSURL * pathURL = [NSURL fileURLWithPath:path];
    
    // Display the content.
    NSLog(@"ContentViewController.loadContent: Loading content into webView");
    [webView loadHTMLString:contents
                    baseURL:pathURL];

    NSLog(@"ContentViewController.loadContent: Done loading content into webView");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
