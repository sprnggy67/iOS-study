//
//  LoadViewController.m
//
//  Created by Dave on 2013-03-02.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "LoadViewController.h"
#import "FeedStore.h"
#import "RSSNewsDataFactory.h"
#import "Downloader.h"
#import "ArticleTableViewController.h"
#import "Section.h"

@interface LoadViewController ()

@property (strong, nonatomic) NSMutableArray * feedsToLoad;
@property (strong, nonatomic) Feed * currentFeed;
@property (strong, nonatomic) NSMutableData * receivedData;
@property (strong, nonatomic) NSMutableArray * sectionList;
@property (strong, nonatomic) NSMutableArray * articleList;
@property (strong, nonatomic) NSMutableString * progressText;

-(void)appendProgressString:(NSString *)str;
-(void)appendProgressFormat:(NSString *)format arg:(NSString *)arg;
-(void)displayContent;
-(void)sortContentByPubDate;
-(void)insertNavigationPages;

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
    [super viewDidLoad];
    
    // Change these lines to get a d
    BOOL proceedNormally = TRUE;
    if (proceedNormally) {
        [self readContentFeeds];
    } else {
        NSLog(@"LoadViewController stopped in viewDidLoad");
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
    self.sectionList = [[NSMutableArray alloc] init];
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
    NSLog(@"readContentFeed %@ %@", feed.name, feed.url);
    
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
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
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
    // Parse the feed
    RSSNewsDataFactory * factory = [[RSSNewsDataFactory alloc] init];
    NSArray * newArticleList = [factory parseData:receivedData];
    if (newArticleList == nil) {
        [self appendProgressString:@"Unable to parse data"];
        [self readNextContentFeed];
        return;
    }

    // Create a section.
    Section * section = [[Section alloc] init:currentFeed.name start:[self.articleList count] length:[newArticleList count]];
    [self.sectionList addObject:section];
    
    // Set the source for each article.
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
    // Prepare the content
    // [self sortContentByPubDate];
    [self insertNavigationPages];
    
    // Load it into the article table view.
    ArticleTableViewController * secondView = [[ArticleTableViewController alloc] initWithStyle:UITableViewStylePlain];
    secondView.articleList = articleList;
    [[self navigationController] pushViewController:secondView animated:YES];

    reloadButton.hidden = NO;
}

-(void)sortContentByPubDate {
    [articleList sortUsingComparator:^NSComparisonResult(id a, id b) {
        Article * articleA = (Article*)a;
        Article * articleB = (Article*)b;
        return [articleB compare:articleA];
    }];
}

-(void)insertNavigationPages {
    int sectionCount = [self.sectionList count];
    int offset = 0;
    
    // Create a front page.
    if (sectionCount > 0) {
        NSMutableArray * children = [NSMutableArray arrayWithCapacity:sectionCount];
        for (Section * section in self.sectionList) {
            Article * article = [self.articleList objectAtIndex:section.start];
            [children addObject:article];
        }
        Article * frontPage = [Article articleWithId:@"Front"
                                            headline:@"Front"
                                            template:@"dynamicTemplate"
                                         subTemplate:@"front3"
                                        withChildren:children];
        [self.articleList insertObject:frontPage atIndex:0];
        
        offset ++;
    }
    
    // Create a front page for every section.
    for (Section * section in self.sectionList) {
        NSMutableArray * children = [NSMutableArray arrayWithCapacity:3];
        int articleIndex = section.start + offset;
        int count = (section.length < 3) ? section.length : 3;
        for (int x = 0; x < count; x++) {
            Article * article = [self.articleList objectAtIndex:(articleIndex + x)];
            [children addObject:article];
        }
        Article * frontPage = [Article articleWithId:section.name
                                            headline:section.name
                                            template:@"dynamicTemplate"
                                         subTemplate:@"front3"
                                        withChildren:children];
        [self.articleList insertObject:frontPage atIndex:(section.start + offset)];
        
        offset ++;
    }
}


@end
