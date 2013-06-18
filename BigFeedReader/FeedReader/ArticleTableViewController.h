//
//  ArticleTableViewController.h
//
//  Displays a list of articles.
//
//  Created by Dave on 2013-04-02.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedTableViewController.h"
#import "FeedStore.h"

@interface ArticleTableViewController : UITableViewController <FeedTableViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray * articleList;
@property (strong, nonatomic) FeedStore * feedStore;

@end
