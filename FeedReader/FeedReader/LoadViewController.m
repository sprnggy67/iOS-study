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
@property (strong, nonatomic) NSMutableData * receivedData;
@property (strong, nonatomic) NSMutableArray * articleList;

@end

@implementation LoadViewController

@synthesize progressLabel;
@synthesize feedsToLoad;
@synthesize receivedData;
@synthesize articleList;

#pragma mark - Init

- (void)viewDidLoad
{
    NSLog(@"LoadViewController.viewDidLoad entered");
    
    [super viewDidLoad];
    [self readContentFeeds];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 Loads each feed in the feed store one by one.
 The iteration is implemented locally, but in the future I'd like to implement a
 general purpose downloader, which will iterate through a set of requests and encapsulate
 all of the URLConnection code below.
 */
-(void)readContentFeeds {
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
        Feed * nextFeed = [feedsToLoad objectAtIndex:0];
        [feedsToLoad removeObjectAtIndex:0];
        [self readContentFeed:nextFeed];
    } else {
        [self displayContent];
    }
}

/*
 Loads one feed
 */
-(void)readContentFeed:(Feed *)feed {
    // Create the download request.
    NSURL * url = [NSURL URLWithString:feed.url];
    if (url == nil) {
        [progressLabel setText:@"Unable to parse feed"];
        return;
    }
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:url
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    
    // Create a connection with the request and start loading the data
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        self.receivedData = [NSMutableData data];
        [progressLabel setText:@"Connected"];
    } else {
        [progressLabel setText:@"Unable to connect"];
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
    [progressLabel setText:[NSString stringWithFormat:@"Received %d bytes of data",[receivedData length]]];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    NSLog(@"connection didFailWithError: %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    [progressLabel setText:[error localizedDescription]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connection connectionDidFinishLoading. Received %d bytes of data",[receivedData length]);

    // Parse the feed
    RSSNewsDataFactory * factory = [[RSSNewsDataFactory alloc] init];
    NSArray * newArticleList = [factory parseData:receivedData];
    if (newArticleList == nil) {
        [progressLabel setText:@"Unable to parse feed content"];
        return;
    }

    [self.articleList addObjectsFromArray:newArticleList];

    // Read the next feed in the list.
    [self readNextContentFeed];
}

- (void)displayContent {
    ArticleTableViewController * secondView = [[ArticleTableViewController alloc] initWithStyle:UITableViewStylePlain];
    secondView.articleList = articleList;
    [[self navigationController] pushViewController:secondView animated:YES];
}

@end
