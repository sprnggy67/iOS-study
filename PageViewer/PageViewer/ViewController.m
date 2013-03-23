//
//  ViewController.m
//  PageViewer
//
//  Created by Dave on 2013-03-02.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "ViewController.h"
#import "NewsDataFactory.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize pageController, articleList;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createContentPages];
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createContentPages
{
    // Load the page contents
    NewsDataFactory * factory = [[NewsDataFactory alloc] init];
    articleList= [factory parseResource:@"ArticleList"];
    NSLog(@"Articles: %@", articleList);
    
    // Create the template factory
    templateFactory = [[TemplateFactory alloc] init];
}

- (ContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    // Return the data view controller for the given index.
    if (([self.articleList count] == 0) ||
        (index >= [self.articleList count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    Article * article = [articleList objectAtIndex:index];
    ContentViewController *dataViewController = [[ContentViewController alloc]
                                                 initWithNibName:@"ContentViewController"
                                                 bundle:nil];
    [dataViewController setArticle:article];
    [dataViewController setTemplateFactory:templateFactory];
     
     return dataViewController;
}

- (NSUInteger)indexOfViewController:(ContentViewController *)viewController
{
    return [self.articleList indexOfObject:[viewController article]];
}

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

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:
                        (ContentViewController *)viewController];
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
