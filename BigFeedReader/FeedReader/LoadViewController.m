//
//  LoadViewController.m
//
//  Created by Dave on 2013-03-02.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "LoadViewController.h"
#import "FeedStore.h"
#import "NewsDataFactory.h"
#import "RSSNewsDataFactory.h"
#import "Downloader.h"
#import "ArticleTableViewController.h"

@interface LoadViewController ()

@property (strong, nonatomic) NSMutableArray * feedsToLoad;
@property (strong, nonatomic) Feed * currentFeed;
@property (strong, nonatomic) NSMutableData * receivedData;
@property (strong, nonatomic) NSMutableArray * articleList;
@property (strong, nonatomic) NSMutableString * progressText;

-(void)appendProgressString:(NSString *)str;
-(void)appendProgressFormat:(NSString *)format arg:(NSString *)arg;

@end

@implementation LoadViewController

@synthesize progressLabel;
@synthesize reloadButton;
@synthesize feedsToLoad;
@synthesize currentFeed;
@synthesize receivedData;
@synthesize articleList;
@synthesize progressText;

#pragma mark - Init

- (void)viewDidLoad
{
    NSLog(@"LoadViewController.viewDidLoad entered");
    
    [super viewDidLoad];
    
    // Change these lines to get a d
    BOOL proceedNormally = TRUE;
    if (proceedNormally) {
        [self readContentFeeds];
    } else {
        progressLabel.text = @"";
        [reloadButton setHidden:TRUE];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.navigationController setToolbarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)reload:(id)sender {
    [self readContentFeeds];
}

/*
 Loads each feed in the feed store one by one.
 The iteration is implemented locally, but in the future I'd like to implement a
 general purpose downloader, which will iterate through a set of requests and encapsulate
 all of the URLConnection code below.
 */
-(void)readContentFeeds {
    reloadButton.hidden = YES;
    progressText = [[NSMutableString alloc] init];
    progressLabel.text = progressText;
    
    FeedStore * feedStore = [FeedStore singleton];
    self.feedsToLoad = [NSMutableArray arrayWithArray:feedStore.feeds];
    self.articleList = [[NSMutableArray alloc] init];
    [self readNextContentFeed];
}

/*
 Loads the next feed from the feedsToLoadList.
 If there are no more feeds to load it displays the feed content.
 */
-(void)readNextContentFeed {
    if ([feedsToLoad count] > 0) {
        self.currentFeed = [feedsToLoad objectAtIndex:0];
        [feedsToLoad removeObjectAtIndex:0];
        [self readContentFeed:currentFeed];
    } else {
        self.currentFeed = nil;
        [self displayContent];
    }
}

/*
 Loads one feed
 */
-(void)readContentFeed:(Feed *)feed {
    // Update UI
    [self appendProgressString:feed.name];
    
    // Create the download request.
    NSURL * url = [NSURL URLWithString:feed.url];
    if (url == nil) {
        [self appendProgressString:@"Unable to parse feed"];
        [self readNextContentFeed];
        return;
    }
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:url
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    
    // Create a connection with the request and start loading the data
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        self.receivedData = [NSMutableData data];
    } else {
        [self appendProgressString:@"Unable to connect"];
        [self readNextContentFeed];
        return;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    NSLog(@"connection didReceiveResponse");
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"connection didReceiveData");
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    NSLog(@"connection didFailWithError: %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    [self appendProgressString:@"Failed"];
    
    // Read the next feed in the list.
    [self readNextContentFeed];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connection connectionDidFinishLoading. Received %d bytes of data",[receivedData length]);

    // Parse the feed
    RSSNewsDataFactory * factory = [[RSSNewsDataFactory alloc] init];
    NSArray * newArticleList = [factory parseData:receivedData];
    if (newArticleList == nil) {
        [self appendProgressString:@"Unable to parse data"];
        [self readNextContentFeed];
        return;
    }

    // Set the source for each item.
    for (Article * article in newArticleList) {
        article.source = currentFeed.name;
    }
    
    // Add the articles to our running list.
    [self.articleList addObjectsFromArray:newArticleList];

    // Read the next feed in the list.
    [self readNextContentFeed];
}

-(void)appendProgressString:(NSString *)str {
    [progressText appendString:str];
    [progressText appendString:@"\n"];
    progressLabel.text = progressText;
}

-(void)appendProgressFormat:(NSString *)format arg:(NSString *)arg {
    [progressText appendFormat:format, arg];
    [progressText appendString:@"\n"];
    progressLabel.text = progressText;
}

- (void)displayContent {
    ArticleTableViewController * secondView = [[ArticleTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [articleList sortUsingSelector:@selector(compare:)];
    [articleList sortUsingComparator:^NSComparisonResult(id a, id b) {
        Article * articleA = (Article*)a;
        Article * articleB = (Article*)b;
        return [articleB compare:articleA];
    }];
    secondView.articleList = articleList;
    [[self navigationController] pushViewController:secondView animated:YES];

    reloadButton.hidden = NO;
}

@end
