//
//  NewFeedViewController.h
//
//  Creates a new Feed item and allows the user to edit it.
//
//  Created by Dave on 2013-04-04.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"

@protocol FeedViewControllerDelegate <NSObject>

/*
 Notifies the receiver that a new feed has been created and needs saving.
 */
- (void)didCreateFeed:(Feed *)feed;

/*
 Notifies the receiver that the feed has been modified and needs saving.
 */
- (void)didModifyFeed:(Feed *)feed;

@end

@interface FeedViewController : UIViewController {
    IBOutlet UITextField * name;
    IBOutlet UITextField * url;
}

@property (strong, nonatomic) Feed * feed;
@property (nonatomic, weak) id <FeedViewControllerDelegate> delegate;

@property (strong, nonatomic) UITextField * name;
@property (strong, nonatomic) UITextField * url;
@property (strong, nonatomic) IBOutlet UIButton * saveButton;
@property (strong, nonatomic) IBOutlet UIButton * cancelButton;

/*
 Saves the feed
 */
-(IBAction)save:(id)sender;

/*
 Cancel and close the view controller
 */
-(IBAction)cancel:(id)sender;

@end
