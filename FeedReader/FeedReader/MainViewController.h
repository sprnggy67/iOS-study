//
//  MainViewController.h
//
//  MainViewController is used to display an array of articles.
//  The articles are displayed in a PageViewController.
//  The user can swipe between them, or navigate directly to an article by index.
//
//  Created by Dave on 2013-03-02.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"
#import "NavigationDelegate.h"

@interface MainViewController : UIViewController <UIPageViewControllerDataSource, NavigationDelegate>

@property (strong, nonatomic) NSArray * articleList;

/**
 Sets the article index to be displayed when the view is loaded.
 By default the article at index 0 is displayed.
 */
-(void)setFirstVisibleIndex:(int)index;

/**
 Returns the visible article index
 */
-(int)getVisibleIndex;

/**
 Returns the visible view controller
 */
-(ContentViewController *)getVisibleViewController;

@end
