//
//  FeedTableViewController.h
//
//  Displays a list of feeds with Add and Delete support.
//
//  Created by Dave on 2013-04-02.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewFeedViewController.h"
#import "FeedStore.h"

@protocol FeedTableViewControllerDelegate <NSObject>

/*
 Notifies the receiver that the feed table has been modified.
 */
- (void)didModifyTable:(FeedStore *) store;

@end

@interface FeedTableViewController : UITableViewController <NewFeedViewControllerDelegate>

@property (nonatomic, weak) id <FeedTableViewControllerDelegate> delegate;

@end
