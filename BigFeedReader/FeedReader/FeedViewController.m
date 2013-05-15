//
//  NewFeedViewController.m
//  FeedReader
//
//  Created by Dave on 2013-04-04.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "FeedViewController.h"

@interface FeedViewController ()

@end

@implementation FeedViewController

@synthesize feed;
@synthesize name;
@synthesize url;
@synthesize delegate;

#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Edit Feed";
    if (feed != nil) {
        [name setText:feed.name];
        [url setText:feed.url];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Interaction

-(IBAction)save:(id)sender {
    if (delegate != nil) {
        if (feed == nil) {
            feed = [[Feed alloc] initWithName:[name text] url:[url text]];
            [delegate didCreateFeed:feed];
        } else {
            feed.name = [name text];
            feed.url = [url text];
            [delegate didModifyFeed:feed];
        }
    }
    [[self navigationController] popViewControllerAnimated:YES];
}

-(IBAction)cancel:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}



@end
