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

@interface ViewController ()

@property (strong, nonatomic) UIPageViewController * pageController;
@property (strong, nonatomic) NSArray * articleList;

@end

@implementation ViewController

@synthesize pageController;
@synthesize articleList;
@synthesize progressLabel;
@synthesize receivedData;

- (void)viewDidLoad
{
    NSLog(@"ViewController.viewDidLoad entered");
    
    [super viewDidLoad];
    
    [self readContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)readContent {
    // Download the feed
    NSURL * url = [NSURL URLWithString:@"http://multitouchdesign.wordpress.com/feed/"];
    
    // Create the request.
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:url
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        receivedData = [NSMutableData data];
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
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    NSLog(@"connection didReceiveData");
    [receivedData appendData:data];
    [progressLabel setText:[NSString stringWithFormat:@"Received %d bytes of data",[receivedData length]]];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // inform the user
    NSLog(@"connection didFailWithError: %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    [progressLabel setText:[error localizedDescription]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"connection connectionDidFinishLoading. Received %d bytes of data",[receivedData length]);
    [self createContentPages];
}

- (void) createContentPages
{
    // Parse the feed
    RSSNewsDataFactory * factory = [[RSSNewsDataFactory alloc] init];
    articleList = [factory parseData:receivedData];
    if (articleList == nil) {
        [progressLabel setText:@"Unable to parse feed content"];
        return;
    }
    
    // Create the template factory
    templateFactory = [[TemplateFactory alloc] init];
    
    // Display the feed data
    [self contentDidLoad];
}

- (void)contentDidLoad {
    
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
    return [self.articleList indexOfObject:[viewController article]];
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
    if (index == [self.articleList count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}


@end
