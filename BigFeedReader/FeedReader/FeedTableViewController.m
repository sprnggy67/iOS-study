//
//  FeedTableViewController.m
//  FeedReader
//
//  For information on passing data back and forth between view controllers, see:
//  http://developer.apple.com/library/ios/#featuredarticles/ViewControllerPGforiPhoneOS/ManagingDataFlowBetweenViewControllers/ManagingDataFlowBetweenViewControllers.html#//apple_ref/doc/uid/TP40007457-CH8-SW9
//
//  Created by Dave on 2013-04-02.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "FeedTableViewController.h"
#import "FeedViewController.h"
#import "FeedStore.h"

@interface FeedTableViewController () {
    BOOL wasModified;
}

@end

@implementation FeedTableViewController

@synthesize feedStore;
@synthesize delegate;

#pragma mark - Init

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Feeds";
    self.clearsSelectionOnViewWillAppear = NO;
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                  target:self
                                                  action:@selector(openCreateVC:)];
    self.toolbarItems = [NSArray arrayWithObjects:self.editButtonItem,nil];
    self.navigationController.toolbarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    if (wasModified) {
        [delegate didModifyTable:feedStore];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [feedStore count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    int index = [indexPath indexAtPosition:1];
    Feed * feed = [[feedStore feeds] objectAtIndex:index];
    cell.textLabel.text = feed.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the feed data
        int index = [indexPath indexAtPosition:1];
        Feed * feed = [[feedStore feeds] objectAtIndex:index];
        [feedStore remove:feed];
        wasModified = YES;
        
        // Delete the feed row
        [tableView reloadData];
        
        // The following code fails in ocunit tests, so I have switched to reloadData
        // [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark - Table view delegate

-(void)openCreateVC:(id)parameter {
    [self openFeedVC:NULL];
}

-(void)openFeedVC:(Feed *)feed {
    FeedViewController *secondView = [[FeedViewController alloc] initWithNibName:@"FeedViewController" bundle:nil];
    [secondView setFeed:feed];
    [secondView setDelegate:self];
    [[self navigationController] pushViewController:secondView animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the feed
    int index = [indexPath indexAtPosition:1];
    Feed * feed = [[feedStore feeds] objectAtIndex:index];

    // Open the child view controller
    [self openFeedVC:feed];
}

#pragma mark - New feed view delegate

- (void)didCreateFeed:(Feed *)feed {
    [feedStore add:feed];
    [[self tableView] reloadData];
    wasModified = YES;
}

- (void)didModifyFeed:(Feed *)feed {
    [feedStore write];
    [[self tableView] reloadData];
    wasModified = YES;
}


@end
