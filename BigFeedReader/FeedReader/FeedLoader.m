//
//  FeedReader.m
//  FeedReader
//
//  Created by Dave on 2013-06-12.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "FeedLoader.h"
#import "Feed.h"
#import "FeedStore.h"
#import "RSSNewsDataFactory.h"
#import "Section.h"

@interface FeedLoader ()

@property (nonatomic, weak) id <FeedLoaderDelegate> loaderDelegate;
@property (strong, nonatomic) NSMutableArray * feedsToLoad;
@property (strong, nonatomic) Feed * currentFeed;
@property (strong, nonatomic) NSMutableData * receivedData;
@property (strong, nonatomic) NSMutableArray * sectionList;
@property (strong, nonatomic) NSMutableArray * articleList;
@property (strong, nonatomic) NSMutableString * progressText;

-(void)appendProgressString:(NSString *)str;
-(void)appendProgressFormat:(NSString *)format arg:(NSString *)arg;

@end


@implementation FeedLoader

@synthesize feedsToLoad;
@synthesize currentFeed;
@synthesize receivedData;
@synthesize articleList;
@synthesize loaderDelegate;

-(void)readContentFeeds:(FeedStore *) feedStore delegate:(id <FeedLoaderDelegate>) delegate
{
    self.loaderDelegate = delegate;
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
        [loaderDelegate didLoadArticles:self.articleList sections:self.sectionList];
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
    [loaderDelegate didProgress:str];
}

-(void)appendProgressFormat:(NSString *)format arg:(NSString *)arg {
    [loaderDelegate didProgress:[NSString stringWithFormat:format, arg]];
}

@end
