//
//  ViewController.h
//
//  Loads the feeds and displays loading progress
//
//  Created by Dave on 2013-03-02.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"
#import "FeedLoaderDelegate.h"

@interface LoadViewController : UIViewController <FeedLoaderDelegate>

@property (strong, nonatomic) IBOutlet UILabel * progressLabel;
@property (strong, nonatomic) IBOutlet UIButton * reloadButton;

-(void)readContentFeeds;
-(IBAction)reload:(id)sender;

@end
