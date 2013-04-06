//
//  NewFeedViewController.h
//  FeedReader
//
//  Created by Dave on 2013-04-04.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"

@protocol NewFeedViewControllerDelegate <NSObject>

/*
 Notifies the receiver that the feed has been changed and needs saving.
 */
- (void)didSaveFeed:(Feed *)feed;

@end


@interface NewFeedViewController : UIViewController {
    IBOutlet UITextField * name;
    IBOutlet UITextField * url;
}

@property (weak, nonatomic) Feed * feed;
@property (strong, nonatomic) UITextField * name;
@property (strong, nonatomic) UITextField * url;
@property (nonatomic, weak) id <NewFeedViewControllerDelegate> delegate;

/*
 Saves the feed
 */
-(IBAction)save:(id)sender;

/*
 Cancel and close the view controller
 */
-(IBAction)cancel:(id)sender;

@end
