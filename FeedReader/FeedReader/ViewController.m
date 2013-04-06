//
//  ViewController.m
//  PageViewer
//
//  Created by Dave on 2013-03-02.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "ViewController.h"
#import "NewsDataFactory.h"
#import "RSSNewsDataFactory.h"
#import "Downloader.h"
#import "FeedTableViewController.h"
#import "FeedStore.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableData * receivedData;
@property (strong, nonatomic) NSMutableArray * feedsToLoad;

@property (strong, nonatomic) UIPageViewController * pageController;
@property (strong, nonatomic) NSMutableArray * articleList;
@property (strong, nonatomic) TemplateFactory * templateFactory;

@end

@implementation ViewController

@synthesize receivedData;
@synthesize feedsToLoad;

@synthesize pageController;
@synthesize articleList;
@synthesize progressLabel;
@synthesize templateFactory;

#pragma mark - Init

- (void)viewDidLoad
{
    NSLog(@"ViewController.viewDidLoad entered");
    
    [super viewDidLoad];
    self.title = @"Articles";
    [self setupNavigation];
    [self readContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupNavigation {
    [super viewDidLoad];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
                                  target:self
                                  action:@selector(menuButtonPressed)];
    
    [[self navigationItem] setRightBarButtonItem:barButton];
}

-(void)menuButtonPressed{
    UIViewController *secondView = [[FeedTableViewController alloc]
                                    initWithStyle:UITableViewStylePlain];
    [[self navigationController] pushViewController:secondView animated:YES];
}

/*
 Loads each feed in the feed store one by one.
 The iteration is implemented locally, but in the future I'd like to implement a
 general purpose downloader, which will iterate through a set of requests and encapsulate
 all of the URLConnection code below.
 */
-(void)readContent {
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
        [self contentDidLoad];
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

#pragma mark - View management

/*
 Displays the feed data
 */
- (void)contentDidLoad {
    // Create the template factory
    templateFactory = [[TemplateFactory alloc] init];
    
    // Create the page controller
    NSDictionary *options = [NSDictionary dictionaryWithObject:
                             [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                        forKey: UIPageViewControllerOptionSpineLocationKey];
    self.pageController = [[UIPageViewController alloc]
                           initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                           navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                           options: options];
    
    pageController.dataSource = self;
    [[pageController view] setFrame:[[self view] bounds]];
    
    ContentViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [pageController setViewControllers:viewControllers
                             direction:UIPageViewControllerNavigationDirectionForward
                              animated:NO
                            completion:nil];
    
    [self addChildViewController:pageController];
    [[self view] addSubview:[pageController view]];
    [pageController didMoveToParentViewController:self];
    
    NSLog(@"ViewController.viewDidLoad done");
}

- (ContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    NSLog(@"ViewController.viewControllerAtIndex:%d entered", index);
    
    // If index is out of bounds, return nil.
    int articleCount = [self.articleList count];
    if ((articleCount == 0) || (index >= articleCount)) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    Article * article = [articleList objectAtIndex:index];
    ContentViewController *dataViewController = [[ContentViewController alloc]
                                                 initWithNibName:@"ContentViewController"
                                                 bundle:nil];
    [dataViewController setArticle:article];
    [dataViewController setTemplateFactory:templateFactory];
     
    NSLog(@"ViewController.viewControllerAtIndex:%d done", index);

    return dataViewController;
}

- (NSUInteger)indexOfViewController:(ContentViewController *)viewController
{
    return [articleList indexOfObject:[viewController article]];
}

// Returns the previous view controller in the pager.
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(ContentViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

// Returns the next view controller in the pager.
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(ContentViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [articleList count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}


@end
