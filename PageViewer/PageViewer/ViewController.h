//
//  ViewController.h
//  PageViewer
//
//  Created by Dave on 2013-03-02.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"

@interface ViewController : UIViewController <UIPageViewControllerDataSource>
{
    UIPageViewController * pageController;
    NSArray * articleList;
    TemplateFactory * templateFactory;
}

@property (strong) UIPageViewController * pageController;
@property (strong) NSArray * articleList;

@end
