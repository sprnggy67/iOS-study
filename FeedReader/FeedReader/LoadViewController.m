//
//  LoadViewController.m
//
//  Created by Dave on 2013-03-02.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "LoadViewController.h"
#import "FeedStore.h"
#import "RSSNewsDataFactory.h"
#import "Downloader.h"
#import "ArticleTableViewController.h"
#import "Section.h"
#import "FeedLoader.h"

@interface LoadViewController ()

@property (strong, nonatomic) NSMutableArray * sectionList;
@property (strong, nonatomic) NSMutableArray * articleList;
@property (strong, nonatomic) NSMutableString * progressText;

-(void)readContentFeeds;
-(void)displayContent;
-(void)sortContentByPubDate;
-(void)insertNavigationPages;
-(void)didDisplayContent:(NSArray *) articles with:(UIViewController *) vc;

@end

@implementation LoadViewController

@synthesize progressLabel;
@synthesize reloadButton;
@synthesize feedStore;
@synthesize articleList;
@synthesize progressText;

#pragma mark - Init

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Change proceedNormally to FALSE to get a screenshot
    BOOL proceedNormally = TRUE;
    if (proceedNormally) {
        [self readContentFeeds];
    } else {
        NSLog(@"LoadViewController stopped in viewDidLoad");
        progressLabel.text = @"";
        [reloadButton setHidden:TRUE];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.navigationController setToolbarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)readContentFeeds {
    reloadButton.hidden = YES;
    progressText = [[NSMutableString alloc] init];
    progressLabel.text = progressText;
    
    FeedLoader * feedLoader = [[FeedLoader alloc] init];
    [feedLoader readContentFeeds:feedStore delegate:self];
}

#pragma mark - FeedLoaderDelegate

-(void)didProgress:(NSString *)str
{
    [progressText appendString:str];
    [progressText appendString:@"\n"];
    progressLabel.text = progressText;
}

-(void)didLoadArticles:(NSMutableArray *) articles sections:(NSMutableArray *)sections
{
    self.articleList = articles;
    self.sectionList = sections;
    [self displayContent];
}

#pragma mark - Display

- (void)displayContent {
    // Prepare the content
    [self insertNavigationPages];
    
    // Load it into the article table view.
    ArticleTableViewController * secondView = [[ArticleTableViewController alloc] initWithStyle:UITableViewStylePlain];
    secondView.articleList = articleList;
    secondView.feedStore = feedStore;
    [[self navigationController] pushViewController:secondView animated:YES];

    reloadButton.hidden = NO;
    
    [self didDisplayContent:articleList with:secondView];
}

-(void)didDisplayContent:(NSArray *) articles with:(UIViewController *) vc
{
    // This method exists for test purposes.
    // Do not remove it.
}

-(void)insertNavigationPages {
    int sectionCount = [self.sectionList count];
    int offset = 0;
    
    // Create a front page.
    /*
    if (sectionCount > 0) {
        NSMutableArray * children = [NSMutableArray arrayWithCapacity:sectionCount];
        for (Section * section in self.sectionList) {
            Article * article = [self.articleList objectAtIndex:section.start];
            [children addObject:article];
        }
        Article * frontPage = [Article articleWithId:@"Front"
                                            headline:@"Front"
                                            template:@"dynamicTemplate"
                                         subTemplate:@"front3"
                                        withChildren:children];
        [self.articleList insertObject:frontPage atIndex:0];
        
        offset ++;
    }
     */
    
    // Create a front page for every section.
    for (Section * section in self.sectionList) {
        NSMutableArray * children = [NSMutableArray arrayWithCapacity:3];
        int articleIndex = section.start + offset;
        int count = (section.length < 3) ? section.length : 3;
        for (int x = 0; x < count; x++) {
            Article * article = [self.articleList objectAtIndex:(articleIndex + x)];
            [children addObject:article];
        }
        Article * frontPage = [Article articleWithId:section.name
                                            headline:section.name
                                            template:@"dynamicTemplate"
                                         subTemplate:@"front3"
                                        withChildren:children];
        [self.articleList insertObject:frontPage atIndex:(section.start + offset)];
        
        offset ++;
    }

    // Create a multi scroll page for the last few articles in the first section.
    {
        Section * section = [self.sectionList objectAtIndex:0];
        NSMutableArray * children = [NSMutableArray arrayWithCapacity:4];
        int count = 4;
        offset = 1; // front page + section page
        if (section.length >= count) {
            int articleIndex = section.start + (section.length - count) + offset;
            for (int x = 0; x < count; x++) {
                Article * article = [self.articleList objectAtIndex:(articleIndex + x)];
                [children addObject:article];
            }
            Article * multiScroll = [Article articleWithId:@"Recap"
                                                headline:@"The Last Four Articles"
                                                template:@"dynamicTemplate"
                                             subTemplate:@"multiScroll"
                                            withChildren:children];
            multiScroll.source = section.name;
            [self.articleList insertObject:multiScroll atIndex:(section.start + section.length + offset)];
            
            offset ++;
            
        }
    }
}

-(void)sortContentByPubDate {
    [articleList sortUsingComparator:^NSComparisonResult(id a, id b) {
        Article * articleA = (Article*)a;
        Article * articleB = (Article*)b;
        return [articleB compare:articleA];
    }];
}

-(IBAction)reload:(id)sender {
    [self readContentFeeds];
}

@end
