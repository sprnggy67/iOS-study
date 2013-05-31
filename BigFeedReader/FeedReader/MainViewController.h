//
//  MainViewController.h
//  PageViewer
//
//  Created by Dave on 2013-03-02.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"
#import "NavigationDelegate.h"

// The top level controller for the application. It contains a page view controller.
@interface MainViewController : UIViewController <UIPageViewControllerDataSource, NavigationDelegate>

@property (strong, nonatomic) NSMutableArray * articleList;

-(void)setFirstVisibleIndex:(int)index;

/*
 Launches the feed view controller
 */
-(void)menuButtonPressed;

@end
