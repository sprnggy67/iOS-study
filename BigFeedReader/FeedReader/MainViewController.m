//
//  ViewController.m
//  PageViewer
//
//  Created by Dave on 2013-03-02.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "MainViewController.h"
#import "NewsDataFactory.h"
#import "RSSNewsDataFactory.h"
#import "Downloader.h"
#import "FeedTableViewController.h"
#import "FeedStore.h"

@interface MainViewController () {

    int firstVisibleIndex;
    
}

@property (strong, nonatomic) TemplateFactory * templateFactory;
@property (strong, nonatomic) UIPageViewController * pageController;

@end

@implementation MainViewController

@synthesize articleList;
@synthesize templateFactory;
@synthesize pageController;

#pragma mark - Init

- (void)viewDidLoad
{
    NSLog(@"MainViewController.viewDidLoad called");
    
    [super viewDidLoad];
    self.title = @"In Detail";
    [self displayContent];
   
    NSLog(@"MainViewController.viewDidLoad done");
}

-(void)setFirstVisibleIndex:(int)index {
    firstVisibleIndex = index;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayContent {
    // Create the template factory
    templateFactory = [[TemplateFactory alloc] initWithBundle:[NSBundle mainBundle]];
    
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

    // Create the initial page
    ContentViewController *initialViewController = [self viewControllerAtIndex:firstVisibleIndex];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [pageController setViewControllers:viewControllers
                             direction:UIPageViewControllerNavigationDirectionForward
                              animated:NO
                            completion:nil];

    // Add the page view controller to self
    [self addChildViewController:pageController];
    [[self view] addSubview:[pageController view]];
    [pageController didMoveToParentViewController:self];
}

- (ContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    NSLog(@"MainViewController.viewControllerAtIndex:%d called", index);
    
    // If index is out of bounds, return nil.
    int articleCount = [self.articleList count];
    if ((articleCount == 0) || (index >= articleCount)) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    NSLog(@"MainViewController.viewControllerAtIndex: creating ContentViewController");
    Article * article = [articleList objectAtIndex:index];
    ContentViewController *dataViewController = [[ContentViewController alloc]
                                                 initWithNibName:@"ContentViewController"
                                                 bundle:nil];
    [dataViewController setArticle:article];
    [dataViewController setTemplateFactory:templateFactory];
    [dataViewController setNavigationDelegate:self];
     
    NSLog(@"MainViewController.viewControllerAtIndex: done");

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

#pragma mark - Navigation

-(void)menuButtonPressed{
    UIViewController *secondView = [[FeedTableViewController alloc]
                                    initWithStyle:UITableViewStylePlain];
    [[self navigationController] pushViewController:secondView animated:YES];
}

/*
 Asks the receiver to navigate to a specific article.
 */
- (void)navigateTo:(NSString *)destId {
    // Find the article
    int articleIndex = -1;
    int count = [self.articleList count];
    for (int index = 0; index < count; index ++) {
        Article * article = [self.articleList objectAtIndex:index];
        if ([destId isEqualToString:article.uniqueId]) {
            articleIndex = index;
            break;
        }
    }

    // Error check.
    if (articleIndex == -1) {
        NSLog(@"MainViewController: Unable to find destId %@ in navigateTo", destId);
        return;
    }
    
    // Create the new page
    ContentViewController *initialViewController = [self viewControllerAtIndex:articleIndex];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    // Animate to the new page
    __block MainViewController * blocksafeSelf = self;
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished){
            if(finished) {
                // Clear the original page by calling this again.
                // See http://stackoverflow.com/questions/12939280/uipageviewcontroller-navigates-to-wrong-page-with-scroll-transition-style
                dispatch_async(dispatch_get_main_queue(), ^{
                    [blocksafeSelf.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
                });
            }
        }];
}




@end
