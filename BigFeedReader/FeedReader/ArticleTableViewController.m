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

#import "MainViewController.h"
#import "ArticleTableViewController.h"
#import "FeedTableViewController.h"
#import "Article.h"

@implementation ArticleTableViewController

@synthesize articleList;
@synthesize feedStore;

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

    self.title = @"Articles";
    self.clearsSelectionOnViewWillAppear = NO;
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
                                                  target:self
                                                  action:@selector(menuButtonPressed:)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:animated];
    [super viewWillAppear:animated];
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
    return [articleList count];
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
    Article * article = [articleList objectAtIndex:index];
    cell.textLabel.text = article.headline;
    cell.detailTextLabel.text = article.source;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the article
        int index = [indexPath indexAtPosition:1];
        [articleList removeObjectAtIndex:index];
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark - Table view delegate

-(void)menuButtonPressed:(id)parameter {
    FeedTableViewController *secondView = [[FeedTableViewController alloc] initWithStyle:UITableViewStylePlain];
    secondView.feedStore = feedStore;
    secondView.delegate = self;
    [[self navigationController] pushViewController:secondView animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the feed
    int index = [indexPath indexAtPosition:1];

    // Open the content view controller
    MainViewController * secondView = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    secondView.articleList = articleList;
    [secondView setFirstVisibleIndex:index];
    [[self navigationController] pushViewController:secondView animated:YES];
}

#pragma mark - New feed view delegate

- (void)didModifyTable:(FeedStore *)store {
    // To do
}


@end
